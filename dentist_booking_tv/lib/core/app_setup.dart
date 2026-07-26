import 'package:dentist_booking_tv/core/services/queue_announcement_service.dart';
import 'package:dentist_booking_tv/features/display/blocs/tv_display_cubit.dart';
import 'package:dentist_booking_tv/features/display/repo/ads_repo.dart';
import 'package:dentist_booking_tv/features/display/repo/queue_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.I;

Future<void> setUp() async {
  final client = Supabase.instance.client;
  getIt.registerLazySingleton<SupabaseClient>(() => client);

  final queueRepo = QueueRepo(client: client);
  getIt.registerLazySingleton<QueueRepo>(() => queueRepo);

  final adsRepo = AdsRepo(client: client);
  getIt.registerLazySingleton<AdsRepo>(() => adsRepo);

  final announcementService = QueueAnnouncementService();
  getIt.registerLazySingleton<QueueAnnouncementService>(() => announcementService);
  await announcementService.init();

  getIt.registerFactory<TvDisplayCubit>(
    () => TvDisplayCubit(
      queueRepo: queueRepo,
      adsRepo: adsRepo,
      announcementService: announcementService,
    ),
  );
}
