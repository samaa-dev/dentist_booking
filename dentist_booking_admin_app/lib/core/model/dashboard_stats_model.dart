import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats_model.freezed.dart';
part 'dashboard_stats_model.g.dart';

@freezed
class DashboardStatsModel with _$DashboardStatsModel {
  const factory DashboardStatsModel({
    @JsonKey(name: 'total_bookings_today') required int totalBookingsToday,
    @JsonKey(name: 'confirmed_today') required int confirmedToday,
    @JsonKey(name: 'cancelled_today') required int cancelledToday,
    @JsonKey(name: 'no_show_today') required int noShowToday,
    @JsonKey(name: 'new_patients_today') required int newPatientsToday,
    @JsonKey(name: 'total_staff') required int totalStaff,
    @JsonKey(name: 'active_announcements') required int activeAnnouncements,
  }) = _DashboardStatsModel;

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsModelFromJson(json);
}
