import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dentist_booking_tv/core/config/env_config.dart';
import 'package:dentist_booking_tv/core/constants/tv_display_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';

/// Attention chime + Arabic turn announcement — orchestrated by
/// [CalledNumberOverlay].
///
/// Preferred path: synthesize TTS to a file, then play chime + speech through
/// the same [AudioPlayer] so the gap between them is fixed (no audio-focus
/// handoff between audioplayers and flutter_tts).
class QueueAnnouncementService {
  static const attentionChimeDuration = Duration(milliseconds: 2500);

  /// Fixed silence after chime before speech when both play on one player.
  static const postChimeGap = Duration(milliseconds: 250);

  /// Gap used only on the legacy speak() fallback (audio focus handoff).
  static const _audioFocusGap = Duration(milliseconds: 200);

  static const _chimeAsset = 'sounds/queue_chime.wav';
  static const _maxCachedFiles = 20;
  static const _minSpeechBytes = 100;

  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();
  bool _initialized = false;
  int _generation = 0;
  bool _ttsDidStart = false;

  Directory? _cacheDir;
  final Map<String, String> _speechCache = {};
  final List<String> _cacheOrder = [];

  Future<void> init() async {
    if (_initialized) return;
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(true);
    await _tts.awaitSynthCompletion(true);

    _tts.setStartHandler(() {
      _ttsDidStart = true;
    });
    _tts.setErrorHandler((msg) {
      debugPrint('TV TTS error: $msg');
    });

    final languageSet = await _setArabicLanguage();
    if (!languageSet) {
      debugPrint('TV TTS: Arabic language not available on device');
    }

    _initialized = true;
  }

  Future<bool> _setArabicLanguage() async {
    for (final code in ['ar-SA', 'ar']) {
      final result = await _tts.setLanguage(code);
      if (result == 1) return true;
    }
    return false;
  }

  Future<Directory> _ensureCacheDir() async {
    if (_cacheDir != null) return _cacheDir!;
    final root = await getTemporaryDirectory();
    final dir = Directory('${root.path}/queue_announcements');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _cacheDir = dir;
    return dir;
  }

  String _cacheKey(int turnNumber, String text) => '$turnNumber:${text.hashCode}';

  /// Plays chime then turn announcement with a fixed post-chime gap.
  ///
  /// Synthesizes speech in parallel with the chime when possible, then plays
  /// both clips on the same [AudioPlayer]. Falls back to live [FlutterTts.speak]
  /// if synthesis fails.
  Future<void> announceTurn(int turnNumber) async {
    final generation = ++_generation;

    final speechFuture = EnvConfig.tvAnnouncementEnabled
        ? _resolveSpeechPath(turnNumber, generation)
        : Future<String?>.value(null);

    await _playChime(generation);
    if (generation != _generation) return;

    if (!EnvConfig.tvAnnouncementEnabled) return;

    await Future.delayed(postChimeGap);
    if (generation != _generation) return;

    final speechPath = await speechFuture;
    if (generation != _generation) return;

    if (speechPath != null) {
      await _playSpeechFile(speechPath, generation);
    } else {
      await _speakTurnFallback(turnNumber, generation);
    }
  }

  Future<String?> _resolveSpeechPath(int turnNumber, int generation) async {
    await init();
    if (generation != _generation) return null;

    final text = TvDisplayStrings.queueTurnAnnouncement(turnNumber);
    final key = _cacheKey(turnNumber, text);

    final cached = _speechCache[key];
    if (cached != null && await File(cached).exists()) {
      return cached;
    }

    try {
      final dir = await _ensureCacheDir();
      if (generation != _generation) return null;

      final path = '${dir.path}/turn_${turnNumber}_${text.hashCode}.wav';
      final result = await _tts.synthesizeToFile(text, path, true);
      if (generation != _generation) return null;

      final file = File(path);
      final ok = result == 1 &&
          await file.exists() &&
          await file.length() >= _minSpeechBytes;
      if (!ok) {
        debugPrint(
          'TV TTS synthesize failed or empty '
          '(result=$result, exists=${await file.exists()})',
        );
        return null;
      }

      _rememberCache(key, path);
      return path;
    } catch (e) {
      debugPrint('TV TTS synthesizeToFile error: $e');
      return null;
    }
  }

  void _rememberCache(String key, String path) {
    if (_speechCache.containsKey(key)) {
      _cacheOrder.remove(key);
    }
    _speechCache[key] = path;
    _cacheOrder.add(key);

    while (_cacheOrder.length > _maxCachedFiles) {
      final oldest = _cacheOrder.removeAt(0);
      final oldPath = _speechCache.remove(oldest);
      if (oldPath != null) {
        try {
          File(oldPath).deleteSync();
        } catch (_) {}
      }
    }
  }

  Future<void> _playChime(int generation) async {
    try {
      await _player.stop();
      if (generation != _generation) return;

      await _player.play(AssetSource(_chimeAsset));

      await Future.any([
        _player.onPlayerComplete.first,
        Future.delayed(attentionChimeDuration),
      ]);

      if (generation != _generation) return;
      await _player.stop();
    } catch (e) {
      debugPrint('TV chime error: $e');
      if (generation == _generation) {
        await Future.delayed(attentionChimeDuration);
      }
    }
  }

  Future<void> _playSpeechFile(String path, int generation) async {
    try {
      await _player.stop();
      if (generation != _generation) return;

      await _player.play(DeviceFileSource(path));

      await Future.any([
        _player.onPlayerComplete.first,
        // Safety cap so a stuck player cannot hang the overlay forever.
        Future.delayed(const Duration(seconds: 30)),
      ]);

      if (generation != _generation) return;
      await _player.stop();
    } catch (e) {
      debugPrint('TV speech file play error: $e');
    }
  }

  /// Legacy path: live TTS after chime (used when synthesizeToFile fails).
  Future<void> _speakTurnFallback(int turnNumber, int generation) async {
    await init();
    if (generation != _generation) return;

    // Extra focus gap only needed when handing off to the TTS engine.
    await Future.delayed(_audioFocusGap);
    if (generation != _generation) return;

    final text = TvDisplayStrings.queueTurnAnnouncement(turnNumber);

    _ttsDidStart = false;
    try {
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TV TTS speak error: $e');
    }

    if (generation != _generation) return;

    if (!_ttsDidStart) {
      debugPrint('TV TTS: silent failure detected, retrying once');
      await Future.delayed(const Duration(milliseconds: 400));
      if (generation != _generation) return;

      _ttsDidStart = false;
      try {
        await _tts.speak(text);
      } catch (e) {
        debugPrint('TV TTS retry error: $e');
      }
    }
  }

  Future<void> _stopPlayback() async {
    try {
      await _player.stop();
    } catch (e) {
      debugPrint('TV player stop error: $e');
    }
    if (!_initialized) return;
    try {
      await _tts.stop();
    } catch (e) {
      debugPrint('TV TTS stop error: $e');
    }
  }

  Future<void> stop() async {
    _generation++;
    await _stopPlayback();
  }

  Future<void> dispose() async {
    await stop();
    await _player.dispose();
    await _clearSpeechCache();
  }

  Future<void> _clearSpeechCache() async {
    _speechCache.clear();
    _cacheOrder.clear();
    final dir = _cacheDir;
    _cacheDir = null;
    if (dir == null) return;
    try {
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      debugPrint('TV announcement cache clear error: $e');
    }
  }
}
