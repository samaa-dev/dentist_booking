import 'package:dentist_booking_app/features/home/repo/booking_status_repo.dart';
import 'package:dentist_booking_app/features/queue/blocs/queue/queue_cubit.dart';
import 'package:dentist_booking_app/features/queue/repo/queue_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/blocs/auth/auth_cubit.dart';
import '../features/auth/repo/sign_in_repo.dart';
import '../features/booking/blocs/booking/booking_cubit.dart';
import '../features/booking/repo/booking_repo.dart';
import '../features/home/blocs/booking_ads/booking_ads_cubit.dart';
import '../features/home/blocs/booking_create/booking_create_cubit.dart';
import '../features/home/blocs/booking_status/booking_status_cubit.dart';
import '../features/home/repo/booking_ads_repo.dart';
import '../features/home/repo/booking_create_repo.dart';
import '../features/home/repo/clinic_settings_repo.dart';
import 'blocs/pages/pages_cubit.dart';
import 'blocs/theme/theme_cubit.dart';

final getIt = GetIt.I;

Future<void> setUp() async {
  final client = Supabase.instance.client;

  getIt.registerLazySingleton<SupabaseClient>(() => client);
  getIt.registerFactory(() => ThemeCubit());

  final signInRepo = SignInRepo(supabase: client);
  getIt.registerLazySingleton<SignInRepo>(() => signInRepo);
  getIt.registerFactory(
    () => AuthCubit(
      signInRepo: signInRepo,
      client: client,
    ),
  );

  getIt.registerFactory(
    () => PagesCubit(),
  );

  final bookingRepo = BookingRepo(client: client);
  getIt.registerLazySingleton<BookingRepo>(() => bookingRepo);
  getIt.registerFactory(
    () => BookingCubit(
      bookingRepo: bookingRepo,
      client: client,
    ),
  );

  final bookingStatusRepo = BookingStatusRepo(client: client);
  getIt.registerLazySingleton<BookingStatusRepo>(() => bookingStatusRepo);
  getIt.registerFactory(
    () => BookingStatusCubit(
      bookingStatusRepo: bookingStatusRepo,
      client: client,
    ),
  );

  final queryRepo = QueueRepo(
    client: client,
    bookingRepo: bookingRepo,
  );
  getIt.registerLazySingleton<QueueRepo>(() => queryRepo);
  getIt.registerFactory(
    () => QueueCubit(
      queueRepo: queryRepo,
    ),
  );

  final bookingCreateRepo = BookingCreateRepo(client: client);
  getIt.registerLazySingleton<BookingCreateRepo>(() => bookingCreateRepo);
  getIt.registerFactory(
    () => BookingCreateCubit(
      bookingCreateRepo: bookingCreateRepo,
      queueRepo: queryRepo,
      client: client,
    ),
  );

  final adsRepo = BookingAdsRepo(client: client);
  getIt.registerLazySingleton<BookingAdsRepo>(() => adsRepo);
  getIt.registerFactory(
    () => BookingAdsCubit(
      bookingAdsRepo: adsRepo,
    ),
  );

  final clinicSettingsRepo = ClinicSettingsRepo(client: client);
  getIt.registerLazySingleton<ClinicSettingsRepo>(() => clinicSettingsRepo);
}
