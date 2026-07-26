import 'package:dentist_booking_admin/features/booking/blocs/booking/booking_cubit.dart';
import 'package:dentist_booking_admin/features/dashboard/blocs/dashboard/dashboard_cubit.dart';
import 'package:dentist_booking_admin/features/patient/blocs/cubit/patient_cubit.dart';
import 'package:dentist_booking_admin/features/queue/blocs/queue/queue_cubit.dart';
import 'package:dentist_booking_admin/features/settings/blocs/settings/settings_cubit.dart';
import 'package:dentist_booking_admin/features/staff/blocs/staff/staff_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/announcement/blocs/announcement/announcement_cubit.dart';
import '../features/announcement/repo/announcement_repo.dart';
import '../features/auth/blocs/auth/auth_cubit.dart';
import '../features/auth/repo/sign_in_repo.dart';
import '../features/booking/blocs/booking_count/booking_count_cubit.dart';
import '../features/booking/repo/booking_repo.dart';
import '../features/booking/service/ticket_print_service.dart';
import '../features/dashboard/repo/dashboard_repo.dart';
import '../features/patient/repo/patient_repo.dart';
import '../features/queue/repo/queue_repo.dart';
import '../features/settings/repo/settings_repo.dart';
import '../features/staff/repo/staff_repo.dart';
import 'blocs/theme/theme_cubit.dart';

final getIt = GetIt.I;

Future<void> setUp() async {
  final client = Supabase.instance.client;
  getIt.registerLazySingleton<SupabaseClient>(() => client);

  final signInRepo = SignInRepo(supabase: client);
  getIt.registerLazySingleton<SignInRepo>(() => signInRepo);
  getIt.registerFactory(
    () => AuthCubit(
      signInRepo: signInRepo,
      client: client,
    ),
  );

  getIt.registerFactory(() => ThemeCubit());

  final staffRepo = StaffRepo(client: client);
  getIt.registerLazySingleton<StaffRepo>(() => staffRepo);
  getIt.registerFactory(
    () => StaffCubit(
      staffRepo: staffRepo,
    ),
  );

  final patientRepo = PatientRepo(client: client);
  getIt.registerLazySingleton<PatientRepo>(() => patientRepo);
  getIt.registerFactory(
    () => PatientCubit(
      patientRepo: patientRepo,
    ),
  );

  final announcementRepo = AnnouncementRepo(client: client);
  getIt.registerLazySingleton<AnnouncementRepo>(() => announcementRepo);
  getIt.registerFactory(
    () => AnnouncementCubit(
      announcementRepo: announcementRepo,
      client: client,
    ),
  );

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
  getIt.registerFactory(
    () => BookingCountCubit(
      bookingRepo: bookingRepo,
      client: client,
    ),
  );

  getIt.registerLazySingleton<TicketPrintService>(
    () => TicketPrintService(settingsRepo: settingsRepo),
  );

  final dashboardRepo = DashboardRepo(client: client);
  getIt.registerLazySingleton<DashboardRepo>(() => dashboardRepo);
  getIt.registerFactory(
    () => DashboardCubit(
      dashboardRepo: dashboardRepo,
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
