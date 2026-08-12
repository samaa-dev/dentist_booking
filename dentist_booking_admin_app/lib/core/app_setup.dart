import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/blocs/auth/auth_cubit.dart';
import '../features/auth/repo/credentials_store.dart';
import '../features/auth/repo/sign_in_repo.dart';
import '../features/booking/blocs/booking/booking_cubit.dart';
import '../features/booking/repo/booking_repo.dart';
import '../features/queue/blocs/queue/queue_cubit.dart';
import '../features/queue/repo/queue_repo.dart';
import '../features/settings/blocs/settings/settings_cubit.dart';
import '../features/settings/repo/settings_repo.dart';
import 'blocs/pages/pages_cubit.dart';
import 'blocs/theme/theme_cubit.dart';

final getIt = GetIt.I;

Future<void> setUp() async {
  final client = Supabase.instance.client;
  getIt.registerLazySingleton<SupabaseClient>(() => client);

  final signInRepo = SignInRepo(supabase: client);
  getIt.registerLazySingleton<SignInRepo>(() => signInRepo);

  final credentialsStore = CredentialsStore();
  getIt.registerLazySingleton<CredentialsStore>(() => credentialsStore);

  getIt.registerFactory(
    () => AuthCubit(
      signInRepo: signInRepo,
      client: client,
      credentialsStore: credentialsStore,
    ),
  );

  getIt.registerFactory(() => ThemeCubit());
  getIt.registerFactory(() => PagesCubit());

  final settingsRepo = SettingsRepo(client: client);
  getIt.registerLazySingleton<SettingsRepo>(() => settingsRepo);
  getIt.registerFactory(
    () => SettingsCubit(
      settingsRepo: settingsRepo,
    ),
  );

  final bookingRepo = BookingRepo(client: client);
  getIt.registerLazySingleton<BookingRepo>(() => bookingRepo);
  getIt.registerFactory(
    () => BookingCubit(
      bookingRepo: bookingRepo,
      client: client,
    ),
  );

  final queueRepo = QueueRepo(client: client);
  getIt.registerLazySingleton<QueueRepo>(() => queueRepo);
  getIt.registerFactory(
    () => QueueCubit(
      queueRepo: queueRepo,
      client: client,
    ),
  );
}
