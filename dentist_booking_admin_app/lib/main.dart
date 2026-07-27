import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'app/app.dart';
import 'core/app_setup.dart' as di;
import 'core/config/env_config.dart';
import 'generated/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvConfig.init();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );

  await Supabase.initialize(
    url: EnvConfig.urlSupabase,
    anonKey: EnvConfig.supabaseKey,
  );

  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting('ar');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await di.setUp();

  timeago.setLocaleMessages('ar', timeago.ArMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar', 'DZ'), Locale('en')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ar', 'DZ'),
      useOnlyLangCode: true,
      assetLoader: const CodegenLoader(),
      child: const DentistBookingAdminApp(),
    ),
  );
}
