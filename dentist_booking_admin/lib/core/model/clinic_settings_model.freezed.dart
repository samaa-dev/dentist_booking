// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clinic_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ClinicSettingsModel _$ClinicSettingsModelFromJson(Map<String, dynamic> json) {
  return _ClinicSetctingsModel.fromJson(json);
}

/// @nodoc
mixin _$ClinicSettingsModel {
  @JsonKey(name: "morning_count_limit")
  int get morningCountLimit => throw _privateConstructorUsedError;
  @JsonKey(name: "evening_count_limit")
  int get eveningCountLimit => throw _privateConstructorUsedError; // @JsonKey(name: "emergency_limit") required int emergencyLimit,
  @JsonKey(name: "is_booking_enabled")
  bool get isBookingEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: "booking_morning_start_time")
  String get bookingMorningStartTime => throw _privateConstructorUsedError; // @JsonKey(name: "booking_end_time") required String bookingEndTime,
  @JsonKey(name: "allow_before_minutes")
  int get allowBeforeMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: "auto_confirm")
  bool get autoConfirm => throw _privateConstructorUsedError; // @JsonKey(name: "allow_weekend") required bool allowWeekend,
  @JsonKey(name: "updated_at")
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: "stop_reason")
  String? get stopReason => throw _privateConstructorUsedError;
  @JsonKey(name: "clinic_phone")
  String? get clinicPhone => throw _privateConstructorUsedError;
  @JsonKey(name: "ticket_note")
  String? get ticketNote => throw _privateConstructorUsedError;

  /// Serializes this ClinicSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClinicSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClinicSettingsModelCopyWith<ClinicSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClinicSettingsModelCopyWith<$Res> {
  factory $ClinicSettingsModelCopyWith(
    ClinicSettingsModel value,
    $Res Function(ClinicSettingsModel) then,
  ) = _$ClinicSettingsModelCopyWithImpl<$Res, ClinicSettingsModel>;
  @useResult
  $Res call({
    @JsonKey(name: "morning_count_limit") int morningCountLimit,
    @JsonKey(name: "evening_count_limit") int eveningCountLimit,
    @JsonKey(name: "is_booking_enabled") bool isBookingEnabled,
    @JsonKey(name: "booking_morning_start_time") String bookingMorningStartTime,
    @JsonKey(name: "allow_before_minutes") int allowBeforeMinutes,
    @JsonKey(name: "auto_confirm") bool autoConfirm,
    @JsonKey(name: "updated_at") DateTime updatedAt,
    @JsonKey(name: "stop_reason") String? stopReason,
    @JsonKey(name: "clinic_phone") String? clinicPhone,
    @JsonKey(name: "ticket_note") String? ticketNote,
  });
}

/// @nodoc
class _$ClinicSettingsModelCopyWithImpl<$Res, $Val extends ClinicSettingsModel>
    implements $ClinicSettingsModelCopyWith<$Res> {
  _$ClinicSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClinicSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? morningCountLimit = null,
    Object? eveningCountLimit = null,
    Object? isBookingEnabled = null,
    Object? bookingMorningStartTime = null,
    Object? allowBeforeMinutes = null,
    Object? autoConfirm = null,
    Object? updatedAt = null,
    Object? stopReason = freezed,
    Object? clinicPhone = freezed,
    Object? ticketNote = freezed,
  }) {
    return _then(
      _value.copyWith(
            morningCountLimit: null == morningCountLimit
                ? _value.morningCountLimit
                : morningCountLimit // ignore: cast_nullable_to_non_nullable
                      as int,
            eveningCountLimit: null == eveningCountLimit
                ? _value.eveningCountLimit
                : eveningCountLimit // ignore: cast_nullable_to_non_nullable
                      as int,
            isBookingEnabled: null == isBookingEnabled
                ? _value.isBookingEnabled
                : isBookingEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            bookingMorningStartTime: null == bookingMorningStartTime
                ? _value.bookingMorningStartTime
                : bookingMorningStartTime // ignore: cast_nullable_to_non_nullable
                      as String,
            allowBeforeMinutes: null == allowBeforeMinutes
                ? _value.allowBeforeMinutes
                : allowBeforeMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            autoConfirm: null == autoConfirm
                ? _value.autoConfirm
                : autoConfirm // ignore: cast_nullable_to_non_nullable
                      as bool,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            stopReason: freezed == stopReason
                ? _value.stopReason
                : stopReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            clinicPhone: freezed == clinicPhone
                ? _value.clinicPhone
                : clinicPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            ticketNote: freezed == ticketNote
                ? _value.ticketNote
                : ticketNote // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClinicSetctingsModelImplCopyWith<$Res>
    implements $ClinicSettingsModelCopyWith<$Res> {
  factory _$$ClinicSetctingsModelImplCopyWith(
    _$ClinicSetctingsModelImpl value,
    $Res Function(_$ClinicSetctingsModelImpl) then,
  ) = __$$ClinicSetctingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: "morning_count_limit") int morningCountLimit,
    @JsonKey(name: "evening_count_limit") int eveningCountLimit,
    @JsonKey(name: "is_booking_enabled") bool isBookingEnabled,
    @JsonKey(name: "booking_morning_start_time") String bookingMorningStartTime,
    @JsonKey(name: "allow_before_minutes") int allowBeforeMinutes,
    @JsonKey(name: "auto_confirm") bool autoConfirm,
    @JsonKey(name: "updated_at") DateTime updatedAt,
    @JsonKey(name: "stop_reason") String? stopReason,
    @JsonKey(name: "clinic_phone") String? clinicPhone,
    @JsonKey(name: "ticket_note") String? ticketNote,
  });
}

/// @nodoc
class __$$ClinicSetctingsModelImplCopyWithImpl<$Res>
    extends _$ClinicSettingsModelCopyWithImpl<$Res, _$ClinicSetctingsModelImpl>
    implements _$$ClinicSetctingsModelImplCopyWith<$Res> {
  __$$ClinicSetctingsModelImplCopyWithImpl(
    _$ClinicSetctingsModelImpl _value,
    $Res Function(_$ClinicSetctingsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClinicSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? morningCountLimit = null,
    Object? eveningCountLimit = null,
    Object? isBookingEnabled = null,
    Object? bookingMorningStartTime = null,
    Object? allowBeforeMinutes = null,
    Object? autoConfirm = null,
    Object? updatedAt = null,
    Object? stopReason = freezed,
    Object? clinicPhone = freezed,
    Object? ticketNote = freezed,
  }) {
    return _then(
      _$ClinicSetctingsModelImpl(
        morningCountLimit: null == morningCountLimit
            ? _value.morningCountLimit
            : morningCountLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        eveningCountLimit: null == eveningCountLimit
            ? _value.eveningCountLimit
            : eveningCountLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        isBookingEnabled: null == isBookingEnabled
            ? _value.isBookingEnabled
            : isBookingEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        bookingMorningStartTime: null == bookingMorningStartTime
            ? _value.bookingMorningStartTime
            : bookingMorningStartTime // ignore: cast_nullable_to_non_nullable
                  as String,
        allowBeforeMinutes: null == allowBeforeMinutes
            ? _value.allowBeforeMinutes
            : allowBeforeMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        autoConfirm: null == autoConfirm
            ? _value.autoConfirm
            : autoConfirm // ignore: cast_nullable_to_non_nullable
                  as bool,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        stopReason: freezed == stopReason
            ? _value.stopReason
            : stopReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        clinicPhone: freezed == clinicPhone
            ? _value.clinicPhone
            : clinicPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        ticketNote: freezed == ticketNote
            ? _value.ticketNote
            : ticketNote // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClinicSetctingsModelImpl implements _ClinicSetctingsModel {
  const _$ClinicSetctingsModelImpl({
    @JsonKey(name: "morning_count_limit") required this.morningCountLimit,
    @JsonKey(name: "evening_count_limit") required this.eveningCountLimit,
    @JsonKey(name: "is_booking_enabled") required this.isBookingEnabled,
    @JsonKey(name: "booking_morning_start_time")
    required this.bookingMorningStartTime,
    @JsonKey(name: "allow_before_minutes") required this.allowBeforeMinutes,
    @JsonKey(name: "auto_confirm") required this.autoConfirm,
    @JsonKey(name: "updated_at") required this.updatedAt,
    @JsonKey(name: "stop_reason") this.stopReason,
    @JsonKey(name: "clinic_phone") this.clinicPhone,
    @JsonKey(name: "ticket_note") this.ticketNote,
  });

  factory _$ClinicSetctingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClinicSetctingsModelImplFromJson(json);

  @override
  @JsonKey(name: "morning_count_limit")
  final int morningCountLimit;
  @override
  @JsonKey(name: "evening_count_limit")
  final int eveningCountLimit;
  // @JsonKey(name: "emergency_limit") required int emergencyLimit,
  @override
  @JsonKey(name: "is_booking_enabled")
  final bool isBookingEnabled;
  @override
  @JsonKey(name: "booking_morning_start_time")
  final String bookingMorningStartTime;
  // @JsonKey(name: "booking_end_time") required String bookingEndTime,
  @override
  @JsonKey(name: "allow_before_minutes")
  final int allowBeforeMinutes;
  @override
  @JsonKey(name: "auto_confirm")
  final bool autoConfirm;
  // @JsonKey(name: "allow_weekend") required bool allowWeekend,
  @override
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;
  @override
  @JsonKey(name: "stop_reason")
  final String? stopReason;
  @override
  @JsonKey(name: "clinic_phone")
  final String? clinicPhone;
  @override
  @JsonKey(name: "ticket_note")
  final String? ticketNote;

  @override
  String toString() {
    return 'ClinicSettingsModel(morningCountLimit: $morningCountLimit, eveningCountLimit: $eveningCountLimit, isBookingEnabled: $isBookingEnabled, bookingMorningStartTime: $bookingMorningStartTime, allowBeforeMinutes: $allowBeforeMinutes, autoConfirm: $autoConfirm, updatedAt: $updatedAt, stopReason: $stopReason, clinicPhone: $clinicPhone, ticketNote: $ticketNote)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClinicSetctingsModelImpl &&
            (identical(other.morningCountLimit, morningCountLimit) ||
                other.morningCountLimit == morningCountLimit) &&
            (identical(other.eveningCountLimit, eveningCountLimit) ||
                other.eveningCountLimit == eveningCountLimit) &&
            (identical(other.isBookingEnabled, isBookingEnabled) ||
                other.isBookingEnabled == isBookingEnabled) &&
            (identical(
                  other.bookingMorningStartTime,
                  bookingMorningStartTime,
                ) ||
                other.bookingMorningStartTime == bookingMorningStartTime) &&
            (identical(other.allowBeforeMinutes, allowBeforeMinutes) ||
                other.allowBeforeMinutes == allowBeforeMinutes) &&
            (identical(other.autoConfirm, autoConfirm) ||
                other.autoConfirm == autoConfirm) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.stopReason, stopReason) ||
                other.stopReason == stopReason) &&
            (identical(other.clinicPhone, clinicPhone) ||
                other.clinicPhone == clinicPhone) &&
            (identical(other.ticketNote, ticketNote) ||
                other.ticketNote == ticketNote));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    morningCountLimit,
    eveningCountLimit,
    isBookingEnabled,
    bookingMorningStartTime,
    allowBeforeMinutes,
    autoConfirm,
    updatedAt,
    stopReason,
    clinicPhone,
    ticketNote,
  );

  /// Create a copy of ClinicSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClinicSetctingsModelImplCopyWith<_$ClinicSetctingsModelImpl>
  get copyWith =>
      __$$ClinicSetctingsModelImplCopyWithImpl<_$ClinicSetctingsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ClinicSetctingsModelImplToJson(this);
  }
}

abstract class _ClinicSetctingsModel implements ClinicSettingsModel {
  const factory _ClinicSetctingsModel({
    @JsonKey(name: "morning_count_limit") required final int morningCountLimit,
    @JsonKey(name: "evening_count_limit") required final int eveningCountLimit,
    @JsonKey(name: "is_booking_enabled") required final bool isBookingEnabled,
    @JsonKey(name: "booking_morning_start_time")
    required final String bookingMorningStartTime,
    @JsonKey(name: "allow_before_minutes")
    required final int allowBeforeMinutes,
    @JsonKey(name: "auto_confirm") required final bool autoConfirm,
    @JsonKey(name: "updated_at") required final DateTime updatedAt,
    @JsonKey(name: "stop_reason") final String? stopReason,
    @JsonKey(name: "clinic_phone") final String? clinicPhone,
    @JsonKey(name: "ticket_note") final String? ticketNote,
  }) = _$ClinicSetctingsModelImpl;

  factory _ClinicSetctingsModel.fromJson(Map<String, dynamic> json) =
      _$ClinicSetctingsModelImpl.fromJson;

  @override
  @JsonKey(name: "morning_count_limit")
  int get morningCountLimit;
  @override
  @JsonKey(name: "evening_count_limit")
  int get eveningCountLimit; // @JsonKey(name: "emergency_limit") required int emergencyLimit,
  @override
  @JsonKey(name: "is_booking_enabled")
  bool get isBookingEnabled;
  @override
  @JsonKey(name: "booking_morning_start_time")
  String get bookingMorningStartTime; // @JsonKey(name: "booking_end_time") required String bookingEndTime,
  @override
  @JsonKey(name: "allow_before_minutes")
  int get allowBeforeMinutes;
  @override
  @JsonKey(name: "auto_confirm")
  bool get autoConfirm; // @JsonKey(name: "allow_weekend") required bool allowWeekend,
  @override
  @JsonKey(name: "updated_at")
  DateTime get updatedAt;
  @override
  @JsonKey(name: "stop_reason")
  String? get stopReason;
  @override
  @JsonKey(name: "clinic_phone")
  String? get clinicPhone;
  @override
  @JsonKey(name: "ticket_note")
  String? get ticketNote;

  /// Create a copy of ClinicSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClinicSetctingsModelImplCopyWith<_$ClinicSetctingsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
