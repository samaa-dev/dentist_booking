// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardStatsModel _$DashboardStatsModelFromJson(Map<String, dynamic> json) {
  return _DashboardStatsModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardStatsModel {
  @JsonKey(name: 'total_bookings_today')
  int get totalBookingsToday => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirmed_today')
  int get confirmedToday => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_today')
  int get cancelledToday => throw _privateConstructorUsedError;
  @JsonKey(name: 'no_show_today')
  int get noShowToday => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_patients_today')
  int get newPatientsToday => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_staff')
  int get totalStaff => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_announcements')
  int get activeAnnouncements => throw _privateConstructorUsedError;

  /// Serializes this DashboardStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStatsModelCopyWith<DashboardStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatsModelCopyWith<$Res> {
  factory $DashboardStatsModelCopyWith(
    DashboardStatsModel value,
    $Res Function(DashboardStatsModel) then,
  ) = _$DashboardStatsModelCopyWithImpl<$Res, DashboardStatsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_bookings_today') int totalBookingsToday,
    @JsonKey(name: 'confirmed_today') int confirmedToday,
    @JsonKey(name: 'cancelled_today') int cancelledToday,
    @JsonKey(name: 'no_show_today') int noShowToday,
    @JsonKey(name: 'new_patients_today') int newPatientsToday,
    @JsonKey(name: 'total_staff') int totalStaff,
    @JsonKey(name: 'active_announcements') int activeAnnouncements,
  });
}

/// @nodoc
class _$DashboardStatsModelCopyWithImpl<$Res, $Val extends DashboardStatsModel>
    implements $DashboardStatsModelCopyWith<$Res> {
  _$DashboardStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalBookingsToday = null,
    Object? confirmedToday = null,
    Object? cancelledToday = null,
    Object? noShowToday = null,
    Object? newPatientsToday = null,
    Object? totalStaff = null,
    Object? activeAnnouncements = null,
  }) {
    return _then(
      _value.copyWith(
            totalBookingsToday: null == totalBookingsToday
                ? _value.totalBookingsToday
                : totalBookingsToday // ignore: cast_nullable_to_non_nullable
                      as int,
            confirmedToday: null == confirmedToday
                ? _value.confirmedToday
                : confirmedToday // ignore: cast_nullable_to_non_nullable
                      as int,
            cancelledToday: null == cancelledToday
                ? _value.cancelledToday
                : cancelledToday // ignore: cast_nullable_to_non_nullable
                      as int,
            noShowToday: null == noShowToday
                ? _value.noShowToday
                : noShowToday // ignore: cast_nullable_to_non_nullable
                      as int,
            newPatientsToday: null == newPatientsToday
                ? _value.newPatientsToday
                : newPatientsToday // ignore: cast_nullable_to_non_nullable
                      as int,
            totalStaff: null == totalStaff
                ? _value.totalStaff
                : totalStaff // ignore: cast_nullable_to_non_nullable
                      as int,
            activeAnnouncements: null == activeAnnouncements
                ? _value.activeAnnouncements
                : activeAnnouncements // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardStatsModelImplCopyWith<$Res>
    implements $DashboardStatsModelCopyWith<$Res> {
  factory _$$DashboardStatsModelImplCopyWith(
    _$DashboardStatsModelImpl value,
    $Res Function(_$DashboardStatsModelImpl) then,
  ) = __$$DashboardStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_bookings_today') int totalBookingsToday,
    @JsonKey(name: 'confirmed_today') int confirmedToday,
    @JsonKey(name: 'cancelled_today') int cancelledToday,
    @JsonKey(name: 'no_show_today') int noShowToday,
    @JsonKey(name: 'new_patients_today') int newPatientsToday,
    @JsonKey(name: 'total_staff') int totalStaff,
    @JsonKey(name: 'active_announcements') int activeAnnouncements,
  });
}

/// @nodoc
class __$$DashboardStatsModelImplCopyWithImpl<$Res>
    extends _$DashboardStatsModelCopyWithImpl<$Res, _$DashboardStatsModelImpl>
    implements _$$DashboardStatsModelImplCopyWith<$Res> {
  __$$DashboardStatsModelImplCopyWithImpl(
    _$DashboardStatsModelImpl _value,
    $Res Function(_$DashboardStatsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalBookingsToday = null,
    Object? confirmedToday = null,
    Object? cancelledToday = null,
    Object? noShowToday = null,
    Object? newPatientsToday = null,
    Object? totalStaff = null,
    Object? activeAnnouncements = null,
  }) {
    return _then(
      _$DashboardStatsModelImpl(
        totalBookingsToday: null == totalBookingsToday
            ? _value.totalBookingsToday
            : totalBookingsToday // ignore: cast_nullable_to_non_nullable
                  as int,
        confirmedToday: null == confirmedToday
            ? _value.confirmedToday
            : confirmedToday // ignore: cast_nullable_to_non_nullable
                  as int,
        cancelledToday: null == cancelledToday
            ? _value.cancelledToday
            : cancelledToday // ignore: cast_nullable_to_non_nullable
                  as int,
        noShowToday: null == noShowToday
            ? _value.noShowToday
            : noShowToday // ignore: cast_nullable_to_non_nullable
                  as int,
        newPatientsToday: null == newPatientsToday
            ? _value.newPatientsToday
            : newPatientsToday // ignore: cast_nullable_to_non_nullable
                  as int,
        totalStaff: null == totalStaff
            ? _value.totalStaff
            : totalStaff // ignore: cast_nullable_to_non_nullable
                  as int,
        activeAnnouncements: null == activeAnnouncements
            ? _value.activeAnnouncements
            : activeAnnouncements // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardStatsModelImpl implements _DashboardStatsModel {
  const _$DashboardStatsModelImpl({
    @JsonKey(name: 'total_bookings_today') required this.totalBookingsToday,
    @JsonKey(name: 'confirmed_today') required this.confirmedToday,
    @JsonKey(name: 'cancelled_today') required this.cancelledToday,
    @JsonKey(name: 'no_show_today') required this.noShowToday,
    @JsonKey(name: 'new_patients_today') required this.newPatientsToday,
    @JsonKey(name: 'total_staff') required this.totalStaff,
    @JsonKey(name: 'active_announcements') required this.activeAnnouncements,
  });

  factory _$DashboardStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardStatsModelImplFromJson(json);

  @override
  @JsonKey(name: 'total_bookings_today')
  final int totalBookingsToday;
  @override
  @JsonKey(name: 'confirmed_today')
  final int confirmedToday;
  @override
  @JsonKey(name: 'cancelled_today')
  final int cancelledToday;
  @override
  @JsonKey(name: 'no_show_today')
  final int noShowToday;
  @override
  @JsonKey(name: 'new_patients_today')
  final int newPatientsToday;
  @override
  @JsonKey(name: 'total_staff')
  final int totalStaff;
  @override
  @JsonKey(name: 'active_announcements')
  final int activeAnnouncements;

  @override
  String toString() {
    return 'DashboardStatsModel(totalBookingsToday: $totalBookingsToday, confirmedToday: $confirmedToday, cancelledToday: $cancelledToday, noShowToday: $noShowToday, newPatientsToday: $newPatientsToday, totalStaff: $totalStaff, activeAnnouncements: $activeAnnouncements)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsModelImpl &&
            (identical(other.totalBookingsToday, totalBookingsToday) ||
                other.totalBookingsToday == totalBookingsToday) &&
            (identical(other.confirmedToday, confirmedToday) ||
                other.confirmedToday == confirmedToday) &&
            (identical(other.cancelledToday, cancelledToday) ||
                other.cancelledToday == cancelledToday) &&
            (identical(other.noShowToday, noShowToday) ||
                other.noShowToday == noShowToday) &&
            (identical(other.newPatientsToday, newPatientsToday) ||
                other.newPatientsToday == newPatientsToday) &&
            (identical(other.totalStaff, totalStaff) ||
                other.totalStaff == totalStaff) &&
            (identical(other.activeAnnouncements, activeAnnouncements) ||
                other.activeAnnouncements == activeAnnouncements));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalBookingsToday,
    confirmedToday,
    cancelledToday,
    noShowToday,
    newPatientsToday,
    totalStaff,
    activeAnnouncements,
  );

  /// Create a copy of DashboardStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatsModelImplCopyWith<_$DashboardStatsModelImpl> get copyWith =>
      __$$DashboardStatsModelImplCopyWithImpl<_$DashboardStatsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardStatsModelImplToJson(this);
  }
}

abstract class _DashboardStatsModel implements DashboardStatsModel {
  const factory _DashboardStatsModel({
    @JsonKey(name: 'total_bookings_today')
    required final int totalBookingsToday,
    @JsonKey(name: 'confirmed_today') required final int confirmedToday,
    @JsonKey(name: 'cancelled_today') required final int cancelledToday,
    @JsonKey(name: 'no_show_today') required final int noShowToday,
    @JsonKey(name: 'new_patients_today') required final int newPatientsToday,
    @JsonKey(name: 'total_staff') required final int totalStaff,
    @JsonKey(name: 'active_announcements')
    required final int activeAnnouncements,
  }) = _$DashboardStatsModelImpl;

  factory _DashboardStatsModel.fromJson(Map<String, dynamic> json) =
      _$DashboardStatsModelImpl.fromJson;

  @override
  @JsonKey(name: 'total_bookings_today')
  int get totalBookingsToday;
  @override
  @JsonKey(name: 'confirmed_today')
  int get confirmedToday;
  @override
  @JsonKey(name: 'cancelled_today')
  int get cancelledToday;
  @override
  @JsonKey(name: 'no_show_today')
  int get noShowToday;
  @override
  @JsonKey(name: 'new_patients_today')
  int get newPatientsToday;
  @override
  @JsonKey(name: 'total_staff')
  int get totalStaff;
  @override
  @JsonKey(name: 'active_announcements')
  int get activeAnnouncements;

  /// Create a copy of DashboardStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStatsModelImplCopyWith<_$DashboardStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
