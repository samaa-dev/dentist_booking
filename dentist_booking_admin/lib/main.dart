import 'package:dentist_booking_admin/app/app.dart';
import 'package:dentist_booking_admin/core/routes/app_route.dart';
import 'package:dentist_booking_admin/generated/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:window_manager/window_manager.dart';

import 'core/app_setup.dart' as di;
import 'core/bloc_observer.dart';
import 'core/config/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  await EnvConfig.init();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );

  await Supabase.initialize(
    url: EnvConfig.urlSupabase,
    anonKey: EnvConfig.supabaseKey,
    authOptions: const FlutterAuthClientOptions(
      autoRefreshToken: true,
    ),
  );

  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting('ar');

  await di.setUp();

  timeago.setLocaleMessages('ar', timeago.ArMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());

  /// 🟢 ثم تحكم في النافذة
  const windowOptions = WindowOptions(
    size: Size(1250, 750),
    minimumSize: Size(1250, 750),
    center: true,
    title: 'Dentist Booking Admin',
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
    backgroundColor: Colors.transparent,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar', 'DZ'), Locale('en')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ar', 'DZ'),
      useOnlyLangCode: true,
      assetLoader: const CodegenLoader(),
      child: DentistBookingAdmin(
        appRouter: AppRouter(),
      ),
    ),
  );
}
