import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/model/dashboard_stats_model.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../repo/dashboard_repo.dart';

part 'dashboard_cubit.freezed.dart';
part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepo _dashboardRepo;

  DashboardCubit({
    required DashboardRepo dashboardRepo,
  }) : _dashboardRepo = dashboardRepo,
       super(DashboardState.initial());

  Future<void> loadDashboardStats() async {
    emit(DashboardState.loading());

    try {
      final stats = await _dashboardRepo.getDashboardStats();
      emit(DashboardState.loaded(stats));
    } catch (e) {
      debugPrint(e.toString());
      emit(DashboardState.error(LocaleKeys.profile_error_load.trnsltd));
    }
  }
}
