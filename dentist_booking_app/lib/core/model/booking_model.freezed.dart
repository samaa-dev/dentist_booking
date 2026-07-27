// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) {
  return _BookingModel.fromJson(json);
}

/// @nodoc
mixin _$BookingModel {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: "booking_date")
  DateTime get bookingDate => throw _privateConstructorUsedError; // @JsonKey(name: 'booking_time') required String bookingTime,
  @JsonKey(name: "patient_id")
  String? get patientId => throw _privateConstructorUsedError;
  @JsonKey(name: "patient_name")
  String? get patientName => throw _privateConstructorUsedError;
  @JsonKey(name: "patient_phone")
  String? get patientPhone => throw _privateConstructorUsedError;
  @JsonKey(name: "patient_address")
  String? get patientAddress => throw _privateConstructorUsedError;
  @JsonKey(name: "patient_type")
  PatientType? get patientType => throw _privateConstructorUsedError;
  BookingShift get shift => throw _privateConstructorUsedError;
  @JsonKey(name: "booking_status")
  BookingStatus? get bookingStatus => throw _privateConstructorUsedError;
  @JsonKey(name: "created_at")
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: "updated_at")
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: "cancelled_at")
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  @JsonKey(name: "completed_at")
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: "cancelled_by")
  String? get cancelledBy => throw _privateConstructorUsedError;
  @JsonKey(name: "cancel_reason")
  String? get cancelReason => throw _privateConstructorUsedError;
  @JsonKey(name: "booking_created_by")
  String? get bookingCreatedBy => throw _privateConstructorUsedError; // @JsonKey(name: 'queue_number') String? queueNumber,
  @JsonKey(
    name: 'queue_number',
    fromJson: queueNumberFromJson,
    toJson: queueNumberToJson,
  )
  String? get queueNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticket_code')
  String? get ticketCode => throw _privateConstructorUsedError; // إضافة حقل جديد
  @JsonKey(name: 'people_before')
  int? get peopleBefore => throw _privateConstructorUsedError;

  /// Serializes this BookingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingModelCopyWith<BookingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingModelCopyWith<$Res> {
  factory $BookingModelCopyWith(
    BookingModel value,
    $Res Function(BookingModel) then,
  ) = _$BookingModelCopyWithImpl<$Res, BookingModel>;
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: "booking_date") DateTime bookingDate,
    @JsonKey(name: "patient_id") String? patientId,
    @JsonKey(name: "patient_name") String? patientName,
    @JsonKey(name: "patient_phone") String? patientPhone,
    @JsonKey(name: "patient_address") String? patientAddress,
    @JsonKey(name: "patient_type") PatientType? patientType,
    BookingShift shift,
    @JsonKey(name: "booking_status") BookingStatus? bookingStatus,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
    @JsonKey(name: "cancelled_at") DateTime? cancelledAt,
    @JsonKey(name: "completed_at") DateTime? completedAt,
    @JsonKey(name: "cancelled_by") String? cancelledBy,
    @JsonKey(name: "cancel_reason") String? cancelReason,
    @JsonKey(name: "booking_created_by") String? bookingCreatedBy,
    @JsonKey(
      name: 'queue_number',
      fromJson: queueNumberFromJson,
      toJson: queueNumberToJson,
    )
    String? queueNumber,
    @JsonKey(name: 'ticket_code') String? ticketCode,
    @JsonKey(name: 'people_before') int? peopleBefore,
  });
}

/// @nodoc
class _$BookingModelCopyWithImpl<$Res, $Val extends BookingModel>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? bookingDate = null,
    Object? patientId = freezed,
    Object? patientName = freezed,
    Object? patientPhone = freezed,
    Object? patientAddress = freezed,
    Object? patientType = freezed,
    Object? shift = null,
    Object? bookingStatus = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? cancelledAt = freezed,
    Object? completedAt = freezed,
    Object? cancelledBy = freezed,
    Object? cancelReason = freezed,
    Object? bookingCreatedBy = freezed,
    Object? queueNumber = freezed,
    Object? ticketCode = freezed,
    Object? peopleBefore = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            bookingDate: null == bookingDate
                ? _value.bookingDate
                : bookingDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            patientId: freezed == patientId
                ? _value.patientId
                : patientId // ignore: cast_nullable_to_non_nullable
                      as String?,
            patientName: freezed == patientName
                ? _value.patientName
                : patientName // ignore: cast_nullable_to_non_nullable
                      as String?,
            patientPhone: freezed == patientPhone
                ? _value.patientPhone
                : patientPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            patientAddress: freezed == patientAddress
                ? _value.patientAddress
                : patientAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            patientType: freezed == patientType
                ? _value.patientType
                : patientType // ignore: cast_nullable_to_non_nullable
                      as PatientType?,
            shift: null == shift
                ? _value.shift
                : shift // ignore: cast_nullable_to_non_nullable
                      as BookingShift,
            bookingStatus: freezed == bookingStatus
                ? _value.bookingStatus
                : bookingStatus // ignore: cast_nullable_to_non_nullable
                      as BookingStatus?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            cancelledAt: freezed == cancelledAt
                ? _value.cancelledAt
                : cancelledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            cancelledBy: freezed == cancelledBy
                ? _value.cancelledBy
                : cancelledBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            cancelReason: freezed == cancelReason
                ? _value.cancelReason
                : cancelReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            bookingCreatedBy: freezed == bookingCreatedBy
                ? _value.bookingCreatedBy
                : bookingCreatedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            queueNumber: freezed == queueNumber
                ? _value.queueNumber
                : queueNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            ticketCode: freezed == ticketCode
                ? _value.ticketCode
                : ticketCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            peopleBefore: freezed == peopleBefore
                ? _value.peopleBefore
                : peopleBefore // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingModelImplCopyWith<$Res>
    implements $BookingModelCopyWith<$Res> {
  factory _$$BookingModelImplCopyWith(
    _$BookingModelImpl value,
    $Res Function(_$BookingModelImpl) then,
  ) = __$$BookingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    @JsonKey(name: "booking_date") DateTime bookingDate,
    @JsonKey(name: "patient_id") String? patientId,
    @JsonKey(name: "patient_name") String? patientName,
    @JsonKey(name: "patient_phone") String? patientPhone,
    @JsonKey(name: "patient_address") String? patientAddress,
    @JsonKey(name: "patient_type") PatientType? patientType,
    BookingShift shift,
    @JsonKey(name: "booking_status") BookingStatus? bookingStatus,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
    @JsonKey(name: "cancelled_at") DateTime? cancelledAt,
    @JsonKey(name: "completed_at") DateTime? completedAt,
    @JsonKey(name: "cancelled_by") String? cancelledBy,
    @JsonKey(name: "cancel_reason") String? cancelReason,
    @JsonKey(name: "booking_created_by") String? bookingCreatedBy,
    @JsonKey(
      name: 'queue_number',
      fromJson: queueNumberFromJson,
      toJson: queueNumberToJson,
    )
    String? queueNumber,
    @JsonKey(name: 'ticket_code') String? ticketCode,
    @JsonKey(name: 'people_before') int? peopleBefore,
  });
}

/// @nodoc
class __$$BookingModelImplCopyWithImpl<$Res>
    extends _$BookingModelCopyWithImpl<$Res, _$BookingModelImpl>
    implements _$$BookingModelImplCopyWith<$Res> {
  __$$BookingModelImplCopyWithImpl(
    _$BookingModelImpl _value,
    $Res Function(_$BookingModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? bookingDate = null,
    Object? patientId = freezed,
    Object? patientName = freezed,
    Object? patientPhone = freezed,
    Object? patientAddress = freezed,
    Object? patientType = freezed,
    Object? shift = null,
    Object? bookingStatus = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? cancelledAt = freezed,
    Object? completedAt = freezed,
    Object? cancelledBy = freezed,
    Object? cancelReason = freezed,
    Object? bookingCreatedBy = freezed,
    Object? queueNumber = freezed,
    Object? ticketCode = freezed,
    Object? peopleBefore = freezed,
  }) {
    return _then(
      _$BookingModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        bookingDate: null == bookingDate
            ? _value.bookingDate
            : bookingDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        patientId: freezed == patientId
            ? _value.patientId
            : patientId // ignore: cast_nullable_to_non_nullable
                  as String?,
        patientName: freezed == patientName
            ? _value.patientName
            : patientName // ignore: cast_nullable_to_non_nullable
                  as String?,
        patientPhone: freezed == patientPhone
            ? _value.patientPhone
            : patientPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        patientAddress: freezed == patientAddress
            ? _value.patientAddress
            : patientAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        patientType: freezed == patientType
            ? _value.patientType
            : patientType // ignore: cast_nullable_to_non_nullable
                  as PatientType?,
        shift: null == shift
            ? _value.shift
            : shift // ignore: cast_nullable_to_non_nullable
                  as BookingShift,
        bookingStatus: freezed == bookingStatus
            ? _value.bookingStatus
            : bookingStatus // ignore: cast_nullable_to_non_nullable
                  as BookingStatus?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        cancelledAt: freezed == cancelledAt
            ? _value.cancelledAt
            : cancelledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        cancelledBy: freezed == cancelledBy
            ? _value.cancelledBy
            : cancelledBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        cancelReason: freezed == cancelReason
            ? _value.cancelReason
            : cancelReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        bookingCreatedBy: freezed == bookingCreatedBy
            ? _value.bookingCreatedBy
            : bookingCreatedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        queueNumber: freezed == queueNumber
            ? _value.queueNumber
            : queueNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        ticketCode: freezed == ticketCode
            ? _value.ticketCode
            : ticketCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        peopleBefore: freezed == peopleBefore
            ? _value.peopleBefore
            : peopleBefore // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingModelImpl implements _BookingModel {
  const _$BookingModelImpl({
    this.id,
    @JsonKey(name: "booking_date") required this.bookingDate,
    @JsonKey(name: "patient_id") this.patientId,
    @JsonKey(name: "patient_name") this.patientName,
    @JsonKey(name: "patient_phone") this.patientPhone,
    @JsonKey(name: "patient_address") this.patientAddress,
    @JsonKey(name: "patient_type") this.patientType,
    required this.shift,
    @JsonKey(name: "booking_status") this.bookingStatus,
    @JsonKey(name: "created_at") this.createdAt,
    @JsonKey(name: "updated_at") this.updatedAt,
    @JsonKey(name: "cancelled_at") this.cancelledAt,
    @JsonKey(name: "completed_at") this.completedAt,
    @JsonKey(name: "cancelled_by") this.cancelledBy,
    @JsonKey(name: "cancel_reason") this.cancelReason,
    @JsonKey(name: "booking_created_by") this.bookingCreatedBy,
    @JsonKey(
      name: 'queue_number',
      fromJson: queueNumberFromJson,
      toJson: queueNumberToJson,
    )
    this.queueNumber,
    @JsonKey(name: 'ticket_code') this.ticketCode,
    @JsonKey(name: 'people_before') this.peopleBefore,
  });

  factory _$BookingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingModelImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: "booking_date")
  final DateTime bookingDate;
  // @JsonKey(name: 'booking_time') required String bookingTime,
  @override
  @JsonKey(name: "patient_id")
  final String? patientId;
  @override
  @JsonKey(name: "patient_name")
  final String? patientName;
  @override
  @JsonKey(name: "patient_phone")
  final String? patientPhone;
  @override
  @JsonKey(name: "patient_address")
  final String? patientAddress;
  @override
  @JsonKey(name: "patient_type")
  final PatientType? patientType;
  @override
  final BookingShift shift;
  @override
  @JsonKey(name: "booking_status")
  final BookingStatus? bookingStatus;
  @override
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @override
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;
  @override
  @JsonKey(name: "cancelled_at")
  final DateTime? cancelledAt;
  @override
  @JsonKey(name: "completed_at")
  final DateTime? completedAt;
  @override
  @JsonKey(name: "cancelled_by")
  final String? cancelledBy;
  @override
  @JsonKey(name: "cancel_reason")
  final String? cancelReason;
  @override
  @JsonKey(name: "booking_created_by")
  final String? bookingCreatedBy;
  // @JsonKey(name: 'queue_number') String? queueNumber,
  @override
  @JsonKey(
    name: 'queue_number',
    fromJson: queueNumberFromJson,
    toJson: queueNumberToJson,
  )
  final String? queueNumber;
  @override
  @JsonKey(name: 'ticket_code')
  final String? ticketCode;
  // إضافة حقل جديد
  @override
  @JsonKey(name: 'people_before')
  final int? peopleBefore;

  @override
  String toString() {
    return 'BookingModel(id: $id, bookingDate: $bookingDate, patientId: $patientId, patientName: $patientName, patientPhone: $patientPhone, patientAddress: $patientAddress, patientType: $patientType, shift: $shift, bookingStatus: $bookingStatus, createdAt: $createdAt, updatedAt: $updatedAt, cancelledAt: $cancelledAt, completedAt: $completedAt, cancelledBy: $cancelledBy, cancelReason: $cancelReason, bookingCreatedBy: $bookingCreatedBy, queueNumber: $queueNumber, ticketCode: $ticketCode, peopleBefore: $peopleBefore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.patientName, patientName) ||
                other.patientName == patientName) &&
            (identical(other.patientPhone, patientPhone) ||
                other.patientPhone == patientPhone) &&
            (identical(other.patientAddress, patientAddress) ||
                other.patientAddress == patientAddress) &&
            (identical(other.patientType, patientType) ||
                other.patientType == patientType) &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.bookingStatus, bookingStatus) ||
                other.bookingStatus == bookingStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.cancelledBy, cancelledBy) ||
                other.cancelledBy == cancelledBy) &&
            (identical(other.cancelReason, cancelReason) ||
                other.cancelReason == cancelReason) &&
            (identical(other.bookingCreatedBy, bookingCreatedBy) ||
                other.bookingCreatedBy == bookingCreatedBy) &&
            (identical(other.queueNumber, queueNumber) ||
                other.queueNumber == queueNumber) &&
            (identical(other.ticketCode, ticketCode) ||
                other.ticketCode == ticketCode) &&
            (identical(other.peopleBefore, peopleBefore) ||
                other.peopleBefore == peopleBefore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    bookingDate,
    patientId,
    patientName,
    patientPhone,
    patientAddress,
    patientType,
    shift,
    bookingStatus,
    createdAt,
    updatedAt,
    cancelledAt,
    completedAt,
    cancelledBy,
    cancelReason,
    bookingCreatedBy,
    queueNumber,
    ticketCode,
    peopleBefore,
  ]);

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      __$$BookingModelImplCopyWithImpl<_$BookingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingModelImplToJson(this);
  }
}

abstract class _BookingModel implements BookingModel {
  const factory _BookingModel({
    final String? id,
    @JsonKey(name: "booking_date") required final DateTime bookingDate,
    @JsonKey(name: "patient_id") final String? patientId,
    @JsonKey(name: "patient_name") final String? patientName,
    @JsonKey(name: "patient_phone") final String? patientPhone,
    @JsonKey(name: "patient_address") final String? patientAddress,
    @JsonKey(name: "patient_type") final PatientType? patientType,
    required final BookingShift shift,
    @JsonKey(name: "booking_status") final BookingStatus? bookingStatus,
    @JsonKey(name: "created_at") final DateTime? createdAt,
    @JsonKey(name: "updated_at") final DateTime? updatedAt,
    @JsonKey(name: "cancelled_at") final DateTime? cancelledAt,
    @JsonKey(name: "completed_at") final DateTime? completedAt,
    @JsonKey(name: "cancelled_by") final String? cancelledBy,
    @JsonKey(name: "cancel_reason") final String? cancelReason,
    @JsonKey(name: "booking_created_by") final String? bookingCreatedBy,
    @JsonKey(
      name: 'queue_number',
      fromJson: queueNumberFromJson,
      toJson: queueNumberToJson,
    )
    final String? queueNumber,
    @JsonKey(name: 'ticket_code') final String? ticketCode,
    @JsonKey(name: 'people_before') final int? peopleBefore,
  }) = _$BookingModelImpl;

  factory _BookingModel.fromJson(Map<String, dynamic> json) =
      _$BookingModelImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: "booking_date")
  DateTime get bookingDate; // @JsonKey(name: 'booking_time') required String bookingTime,
  @override
  @JsonKey(name: "patient_id")
  String? get patientId;
  @override
  @JsonKey(name: "patient_name")
  String? get patientName;
  @override
  @JsonKey(name: "patient_phone")
  String? get patientPhone;
  @override
  @JsonKey(name: "patient_address")
  String? get patientAddress;
  @override
  @JsonKey(name: "patient_type")
  PatientType? get patientType;
  @override
  BookingShift get shift;
  @override
  @JsonKey(name: "booking_status")
  BookingStatus? get bookingStatus;
  @override
  @JsonKey(name: "created_at")
  DateTime? get createdAt;
  @override
  @JsonKey(name: "updated_at")
  DateTime? get updatedAt;
  @override
  @JsonKey(name: "cancelled_at")
  DateTime? get cancelledAt;
  @override
  @JsonKey(name: "completed_at")
  DateTime? get completedAt;
  @override
  @JsonKey(name: "cancelled_by")
  String? get cancelledBy;
  @override
  @JsonKey(name: "cancel_reason")
  String? get cancelReason;
  @override
  @JsonKey(name: "booking_created_by")
  String? get bookingCreatedBy; // @JsonKey(name: 'queue_number') String? queueNumber,
  @override
  @JsonKey(
    name: 'queue_number',
    fromJson: queueNumberFromJson,
    toJson: queueNumberToJson,
  )
  String? get queueNumber;
  @override
  @JsonKey(name: 'ticket_code')
  String? get ticketCode; // إضافة حقل جديد
  @override
  @JsonKey(name: 'people_before')
  int? get peopleBefore;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
