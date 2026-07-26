import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'app/app.dart';
import 'core/app_setup.dart' as di;
import 'core/bloc_observer.dart';
import 'core/config/config.dart';
import 'core/routes/app_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  await EnvConfig.init();

  await Supabase.initialize(
    url: EnvConfig.urlSupabase,
    anonKey: EnvConfig.supabaseKey,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );

  await Future.wait(
    [
      di.setUp(),
    ],
  );

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
