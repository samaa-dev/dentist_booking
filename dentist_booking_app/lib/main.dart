import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'app/app.dart';
import 'core/app_setup.dart' as di;
import 'core/bloc_observer.dart';
import 'core/config/config.dart';
import 'core/routes/app_route.dart';
import 'core/services/push_notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting('ar');

  Bloc.observer = AppBlocObserver();

  await EnvConfig.init();

  await Supabase.initialize(
    url: EnvConfig.urlSupabase,
    anonKey: EnvConfig.supabaseKey,
  );

  // Firebase must be ready before PushNotificationService touches messaging.
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } catch (e, st) {
      debugPrint('Firebase init skipped: $e\n$st');
    }
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );

  await di.setUp();

  try {
    await di.getIt<PushNotificationService>().initialize();
  } catch (e, st) {
    debugPrint('Push init skipped: $e\n$st');
  }

  timeago.setLocaleMessages('ar', timeago.ArMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      ignorePluralRules: false,
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      startLocale: const Locale('ar'),
      child: DentistBookingApp(
        appRouter: AppRouter(),
      ),
    ),
  );
}
