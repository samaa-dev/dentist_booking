import 'package:dentist_booking_tv/app/app.dart';
import 'package:dentist_booking_tv/core/app_setup.dart' as di;
import 'package:dentist_booking_tv/core/config/env_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvConfig.init();

  await Supabase.initialize(
    url: EnvConfig.urlSupabase,
    anonKey: EnvConfig.supabaseKey,
  );

  await di.setUp();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const DentistBookingTvApp());
}
