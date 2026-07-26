import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static Future<void> init() async {
    if (kReleaseMode) {
      // 🟢 In release mode, use dart-define
      _urlSupabase = const String.fromEnvironment('URL_SUPABASE');
      _supabaseKey = const String.fromEnvironment('SUPABASE_KEY');

      // Add validation to ensure variables are not empty
      if (_urlSupabase.isEmpty || _supabaseKey.isEmpty) {
        throw Exception(
          'Missing environment variables for release mode. Ensure --dart-define is set.',
        );
      }
    } else {
      // 🧩 In debug mode, read from .env file
      await dotenv.load(fileName: ".env");
      _urlSupabase = dotenv.env['URL_SUPABASE'] ?? '';
      _supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';

      // Add validation for debug mode
      if (_urlSupabase.isEmpty || _supabaseKey.isEmpty) {
        throw Exception(
          'Missing environment variables in .env file.',
        );
      }
    }
  }

  static late String _urlSupabase;
  static late String _supabaseKey;

  static String get urlSupabase => _urlSupabase;
  static String get supabaseKey => _supabaseKey;
}
