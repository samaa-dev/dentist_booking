import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static Future<void> init() async {
    if (kReleaseMode) {
      _urlSupabase = const String.fromEnvironment('URL_SUPABASE');
      _supabaseKey = const String.fromEnvironment('SUPABASE_KEY');
      _clinicDisplayName = const String.fromEnvironment('CLINIC_DISPLAY_NAME', defaultValue: '');
      _clinicTagline = const String.fromEnvironment('CLINIC_TAGLINE', defaultValue: '');
      _clinicRoomNumber = const String.fromEnvironment('CLINIC_ROOM_NUMBER', defaultValue: '');
      _clinicDoctorName = const String.fromEnvironment('CLINIC_DOCTOR_NAME', defaultValue: '');
      _tvAnnouncementEnabled = _parseBool(
        const String.fromEnvironment('TV_ANNOUNCEMENT_ENABLED', defaultValue: 'true'),
        defaultValue: true,
      );
      _tvOverlayHoldAfterSpeechMs = _parseInt(
        const String.fromEnvironment('TV_OVERLAY_HOLD_AFTER_SPEECH_MS', defaultValue: '1500'),
        defaultValue: 1500,
      );
      _tvOverlayHoldWhenSilentMs = _parseInt(
        const String.fromEnvironment('TV_OVERLAY_HOLD_WHEN_SILENT_MS', defaultValue: '5000'),
        defaultValue: 5000,
      );

      if (_urlSupabase.isEmpty || _supabaseKey.isEmpty) {
        throw Exception(
          'Missing environment variables for release mode. Ensure --dart-define is set.',
        );
      }
    } else {
      await dotenv.load(fileName: '.env');
      _urlSupabase = dotenv.env['URL_SUPABASE'] ?? '';
      _supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';
      _clinicDisplayName = dotenv.env['CLINIC_DISPLAY_NAME'] ?? '';
      _clinicTagline = dotenv.env['CLINIC_TAGLINE'] ?? '';
      _clinicRoomNumber = dotenv.env['CLINIC_ROOM_NUMBER'] ?? '';
      _clinicDoctorName = dotenv.env['CLINIC_DOCTOR_NAME'] ?? '';
      _tvAnnouncementEnabled = _parseBool(
        dotenv.env['TV_ANNOUNCEMENT_ENABLED'],
        defaultValue: true,
      );
      _tvOverlayHoldAfterSpeechMs = _parseInt(
        dotenv.env['TV_OVERLAY_HOLD_AFTER_SPEECH_MS'],
        defaultValue: 1500,
      );
      _tvOverlayHoldWhenSilentMs = _parseInt(
        dotenv.env['TV_OVERLAY_HOLD_WHEN_SILENT_MS'],
        defaultValue: 5000,
      );

      if (_urlSupabase.isEmpty || _supabaseKey.isEmpty) {
        throw Exception(
          'Missing environment variables in .env file.',
        );
      }
    }
  }

  static late String _urlSupabase;
  static late String _supabaseKey;
  static String _clinicDisplayName = '';
  static String _clinicTagline = '';
  static String _clinicRoomNumber = '';
  static String _clinicDoctorName = '';
  static bool _tvAnnouncementEnabled = true;
  static int _tvOverlayHoldAfterSpeechMs = 1500;
  static int _tvOverlayHoldWhenSilentMs = 5000;

  static bool _parseBool(String? value, {required bool defaultValue}) {
    if (value == null || value.trim().isEmpty) return defaultValue;
    final v = value.trim().toLowerCase();
    if (v == 'true' || v == '1' || v == 'yes') return true;
    if (v == 'false' || v == '0' || v == 'no') return false;
    return defaultValue;
  }

  static int _parseInt(String? value, {required int defaultValue}) {
    if (value == null || value.trim().isEmpty) return defaultValue;
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed < 0) return defaultValue;
    return parsed;
  }

  static String get urlSupabase => _urlSupabase;
  static String get supabaseKey => _supabaseKey;

  /// Optional: clinic name for TV display header (e.g. "عيادة الأسنان التخصصية").
  static String get clinicDisplayName =>
      _clinicDisplayName.isNotEmpty ? _clinicDisplayName : 'عيادة الأسنان التخصصية';

  /// Optional: clinic tagline for TV display header.
  static String get clinicTagline =>
      _clinicTagline.isNotEmpty ? _clinicTagline : 'رعاية طبية متميزة لابتسامة واثقة';

  /// Legacy: no longer used in TV UI (kept for backward-compatible .env / dart-define).
  static String get clinicRoomNumber => _clinicRoomNumber;

  /// Optional: doctor name shown under direction text, e.g. "د. أحمد محمد".
  static String get clinicDoctorName => _clinicDoctorName;

  /// When false, overlay shows without TTS (uses [tvOverlayHoldWhenSilent]).
  static bool get tvAnnouncementEnabled => _tvAnnouncementEnabled;

  /// Extra time the call overlay stays visible after TTS completes.
  static Duration get tvOverlayHoldAfterSpeech =>
      Duration(milliseconds: _tvOverlayHoldAfterSpeechMs);

  /// How long the overlay stays when TTS is disabled.
  static Duration get tvOverlayHoldWhenSilent =>
      Duration(milliseconds: _tvOverlayHoldWhenSilentMs);
}
