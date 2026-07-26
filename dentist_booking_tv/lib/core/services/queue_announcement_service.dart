import 'package:audioplayers/audioplayers.dart';
import 'package:dentist_booking_tv/core/config/env_config.dart';
import 'package:dentist_booking_tv/core/constants/tv_display_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Attention chime + Arabic TTS for queue turn call — orchestrated by
/// [CalledNumberOverlay].
class QueueAnnouncementService {
  static const attentionChimeDuration = Duration(milliseconds: 2500);

  /// Brief gap after chime so audioplayers can release Android audio focus
  /// before flutter_tts requests it.
  static const _audioFocusGap = Duration(milliseconds: 200);

  static const _chimeAsset = 'sounds/queue_chime.wav';

  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _chimePlayer = AudioPlayer();
  bool _initialized = false;
  int _generation = 0;
  bool _ttsDidStart = false;

  Future<void> init() async {
    if (_initialized) return;
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(true);

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

  /// Plays the attention chime once (~2.5s) before TTS.
  Future<void> playAttentionChime() async {
    final generation = ++_generation;

    try {
      await _chimePlayer.stop();
      await _chimePlayer.play(AssetSource(_chimeAsset));

      await Future.any([
        _chimePlayer.onPlayerComplete.first,
        Future.delayed(attentionChimeDuration),
      ]);

      if (generation != _generation) return;
      await _chimePlayer.stop();

      // Let audioplayers release audio focus before TTS requests it.
      if (generation == _generation) {
        await Future.delayed(_audioFocusGap);
      }
    } catch (e) {
      debugPrint('TV chime error: $e');
      // Preserve timing so the call sequence still feels paced.
      if (generation == _generation) {
        await Future.delayed(attentionChimeDuration);
        await Future.delayed(_audioFocusGap);
      }
    }
  }

  /// Speaks the turn announcement once; completes when TTS finishes or is stopped.
  /// Retries once if the engine fails silently (speak returns without starting).
  Future<void> speakTurnOnce(int turnNumber) async {
    if (!EnvConfig.tvAnnouncementEnabled) return;

    await init();

    // Only stop the chime player — do NOT call tts.stop() on an idle engine
    // (that can poison the next speak() on some Android TV firmwares).
    try {
      await _chimePlayer.stop();
    } catch (e) {
      debugPrint('TV chime stop error: $e');
    }

    final generation = ++_generation;
    final text = TvDisplayStrings.queueTurnAnnouncement(turnNumber);

    if (generation != _generation) return;

    _ttsDidStart = false;
    try {
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TV TTS speak error: $e');
    }

    if (generation != _generation) return;

    // Silent failure: speak returned without the start handler firing.
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
      await _chimePlayer.stop();
    } catch (e) {
      debugPrint('TV chime stop error: $e');
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
    await _chimePlayer.dispose();
  }
}
