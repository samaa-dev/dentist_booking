// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardStatsModelImpl _$$DashboardStatsModelImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardStatsModelImpl(
  totalBookingsToday: (json['total_bookings_today'] as num).toInt(),
  confirmedToday: (json['confirmed_today'] as num).toInt(),
  cancelledToday: (json['cancelled_today'] as num).toInt(),
  noShowToday: (json['no_show_today'] as num).toInt(),
  newPatientsToday: (json['new_patients_today'] as num).toInt(),
  totalStaff: (json['total_staff'] as num).toInt(),
  activeAnnouncements: (json['active_announcements'] as num).toInt(),
);

Map<String, dynamic> _$$DashboardStatsModelImplToJson(
  _$DashboardStatsModelImpl instance,
) => <String, dynamic>{
  'total_bookings_today': instance.totalBookingsToday,
  'confirmed_today': instance.confirmedToday,
  'cancelled_today': instance.cancelledToday,
  'no_show_today': instance.noShowToday,
  'new_patients_today': instance.newPatientsToday,
  'total_staff': instance.totalStaff,
  'active_announcements': instance.activeAnnouncements,
};
