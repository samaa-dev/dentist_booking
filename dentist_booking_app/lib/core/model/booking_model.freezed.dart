// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingModel {

 String? get id;@JsonKey(name: "booking_date") DateTime get bookingDate;// @JsonKey(name: 'booking_time') required String bookingTime,
@JsonKey(name: "patient_id") String? get patientId;@JsonKey(name: "patient_name") String? get patientName;@JsonKey(name: "patient_phone") String? get patientPhone;@JsonKey(name: "patient_address") String? get patientAddress;@JsonKey(name: "patient_type") PatientType? get patientType; BookingShift get shift;@JsonKey(name: "booking_status") BookingStatus? get bookingStatus;@JsonKey(name: "created_at") DateTime? get createdAt;@JsonKey(name: "updated_at") DateTime? get updatedAt;@JsonKey(name: "cancelled_at") DateTime? get cancelledAt;@JsonKey(name: "completed_at") DateTime? get completedAt;@JsonKey(name: "cancelled_by") String? get cancelledBy;@JsonKey(name: "cancel_reason") String? get cancelReason;@JsonKey(name: "booking_created_by") String? get bookingCreatedBy;// @JsonKey(name: 'queue_number') String? queueNumber,
@JsonKey(name: 'queue_number', fromJson: queueNumberFromJson, toJson: queueNumberToJson) String? get queueNumber;@JsonKey(name: 'ticket_code') String? get ticketCode;// إضافة حقل جديد
@JsonKey(name: 'people_before') int? get peopleBefore;
/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingModelCopyWith<BookingModel> get copyWith => _$BookingModelCopyWithImpl<BookingModel>(this as BookingModel, _$identity);

  /// Serializes this BookingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingDate, bookingDate) || other.bookingDate == bookingDate)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.patientPhone, patientPhone) || other.patientPhone == patientPhone)&&(identical(other.patientAddress, patientAddress) || other.patientAddress == patientAddress)&&(identical(other.patientType, patientType) || other.patientType == patientType)&&(identical(other.shift, shift) || other.shift == shift)&&(identical(other.bookingStatus, bookingStatus) || other.bookingStatus == bookingStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledBy, cancelledBy) || other.cancelledBy == cancelledBy)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.bookingCreatedBy, bookingCreatedBy) || other.bookingCreatedBy == bookingCreatedBy)&&(identical(other.queueNumber, queueNumber) || other.queueNumber == queueNumber)&&(identical(other.ticketCode, ticketCode) || other.ticketCode == ticketCode)&&(identical(other.peopleBefore, peopleBefore) || other.peopleBefore == peopleBefore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,bookingDate,patientId,patientName,patientPhone,patientAddress,patientType,shift,bookingStatus,createdAt,updatedAt,cancelledAt,completedAt,cancelledBy,cancelReason,bookingCreatedBy,queueNumber,ticketCode,peopleBefore]);

@override
String toString() {
  return 'BookingModel(id: $id, bookingDate: $bookingDate, patientId: $patientId, patientName: $patientName, patientPhone: $patientPhone, patientAddress: $patientAddress, patientType: $patientType, shift: $shift, bookingStatus: $bookingStatus, createdAt: $createdAt, updatedAt: $updatedAt, cancelledAt: $cancelledAt, completedAt: $completedAt, cancelledBy: $cancelledBy, cancelReason: $cancelReason, bookingCreatedBy: $bookingCreatedBy, queueNumber: $queueNumber, ticketCode: $ticketCode, peopleBefore: $peopleBefore)';
}


}

/// @nodoc
abstract mixin class $BookingModelCopyWith<$Res>  {
  factory $BookingModelCopyWith(BookingModel value, $Res Function(BookingModel) _then) = _$BookingModelCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: "booking_date") DateTime bookingDate,@JsonKey(name: "patient_id") String? patientId,@JsonKey(name: "patient_name") String? patientName,@JsonKey(name: "patient_phone") String? patientPhone,@JsonKey(name: "patient_address") String? patientAddress,@JsonKey(name: "patient_type") PatientType? patientType, BookingShift shift,@JsonKey(name: "booking_status") BookingStatus? bookingStatus,@JsonKey(name: "created_at") DateTime? createdAt,@JsonKey(name: "updated_at") DateTime? updatedAt,@JsonKey(name: "cancelled_at") DateTime? cancelledAt,@JsonKey(name: "completed_at") DateTime? completedAt,@JsonKey(name: "cancelled_by") String? cancelledBy,@JsonKey(name: "cancel_reason") String? cancelReason,@JsonKey(name: "booking_created_by") String? bookingCreatedBy,@JsonKey(name: 'queue_number', fromJson: queueNumberFromJson, toJson: queueNumberToJson) String? queueNumber,@JsonKey(name: 'ticket_code') String? ticketCode,@JsonKey(name: 'people_before') int? peopleBefore
});




}
/// @nodoc
class _$BookingModelCopyWithImpl<$Res>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._self, this._then);

  final BookingModel _self;
  final $Res Function(BookingModel) _then;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? bookingDate = null,Object? patientId = freezed,Object? patientName = freezed,Object? patientPhone = freezed,Object? patientAddress = freezed,Object? patientType = freezed,Object? shift = null,Object? bookingStatus = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? cancelledAt = freezed,Object? completedAt = freezed,Object? cancelledBy = freezed,Object? cancelReason = freezed,Object? bookingCreatedBy = freezed,Object? queueNumber = freezed,Object? ticketCode = freezed,Object? peopleBefore = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,bookingDate: null == bookingDate ? _self.bookingDate : bookingDate // ignore: cast_nullable_to_non_nullable
as DateTime,patientId: freezed == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String?,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,patientPhone: freezed == patientPhone ? _self.patientPhone : patientPhone // ignore: cast_nullable_to_non_nullable
as String?,patientAddress: freezed == patientAddress ? _self.patientAddress : patientAddress // ignore: cast_nullable_to_non_nullable
as String?,patientType: freezed == patientType ? _self.patientType : patientType // ignore: cast_nullable_to_non_nullable
as PatientType?,shift: null == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as BookingShift,bookingStatus: freezed == bookingStatus ? _self.bookingStatus : bookingStatus // ignore: cast_nullable_to_non_nullable
as BookingStatus?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledBy: freezed == cancelledBy ? _self.cancelledBy : cancelledBy // ignore: cast_nullable_to_non_nullable
as String?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,bookingCreatedBy: freezed == bookingCreatedBy ? _self.bookingCreatedBy : bookingCreatedBy // ignore: cast_nullable_to_non_nullable
as String?,queueNumber: freezed == queueNumber ? _self.queueNumber : queueNumber // ignore: cast_nullable_to_non_nullable
as String?,ticketCode: freezed == ticketCode ? _self.ticketCode : ticketCode // ignore: cast_nullable_to_non_nullable
as String?,peopleBefore: freezed == peopleBefore ? _self.peopleBefore : peopleBefore // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingModel].
extension BookingModelPatterns on BookingModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingModel value)  $default,){
final _that = this;
switch (_that) {
case _BookingModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: "booking_date")  DateTime bookingDate, @JsonKey(name: "patient_id")  String? patientId, @JsonKey(name: "patient_name")  String? patientName, @JsonKey(name: "patient_phone")  String? patientPhone, @JsonKey(name: "patient_address")  String? patientAddress, @JsonKey(name: "patient_type")  PatientType? patientType,  BookingShift shift, @JsonKey(name: "booking_status")  BookingStatus? bookingStatus, @JsonKey(name: "created_at")  DateTime? createdAt, @JsonKey(name: "updated_at")  DateTime? updatedAt, @JsonKey(name: "cancelled_at")  DateTime? cancelledAt, @JsonKey(name: "completed_at")  DateTime? completedAt, @JsonKey(name: "cancelled_by")  String? cancelledBy, @JsonKey(name: "cancel_reason")  String? cancelReason, @JsonKey(name: "booking_created_by")  String? bookingCreatedBy, @JsonKey(name: 'queue_number', fromJson: queueNumberFromJson, toJson: queueNumberToJson)  String? queueNumber, @JsonKey(name: 'ticket_code')  String? ticketCode, @JsonKey(name: 'people_before')  int? peopleBefore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
return $default(_that.id,_that.bookingDate,_that.patientId,_that.patientName,_that.patientPhone,_that.patientAddress,_that.patientType,_that.shift,_that.bookingStatus,_that.createdAt,_that.updatedAt,_that.cancelledAt,_that.completedAt,_that.cancelledBy,_that.cancelReason,_that.bookingCreatedBy,_that.queueNumber,_that.ticketCode,_that.peopleBefore);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: "booking_date")  DateTime bookingDate, @JsonKey(name: "patient_id")  String? patientId, @JsonKey(name: "patient_name")  String? patientName, @JsonKey(name: "patient_phone")  String? patientPhone, @JsonKey(name: "patient_address")  String? patientAddress, @JsonKey(name: "patient_type")  PatientType? patientType,  BookingShift shift, @JsonKey(name: "booking_status")  BookingStatus? bookingStatus, @JsonKey(name: "created_at")  DateTime? createdAt, @JsonKey(name: "updated_at")  DateTime? updatedAt, @JsonKey(name: "cancelled_at")  DateTime? cancelledAt, @JsonKey(name: "completed_at")  DateTime? completedAt, @JsonKey(name: "cancelled_by")  String? cancelledBy, @JsonKey(name: "cancel_reason")  String? cancelReason, @JsonKey(name: "booking_created_by")  String? bookingCreatedBy, @JsonKey(name: 'queue_number', fromJson: queueNumberFromJson, toJson: queueNumberToJson)  String? queueNumber, @JsonKey(name: 'ticket_code')  String? ticketCode, @JsonKey(name: 'people_before')  int? peopleBefore)  $default,) {final _that = this;
switch (_that) {
case _BookingModel():
return $default(_that.id,_that.bookingDate,_that.patientId,_that.patientName,_that.patientPhone,_that.patientAddress,_that.patientType,_that.shift,_that.bookingStatus,_that.createdAt,_that.updatedAt,_that.cancelledAt,_that.completedAt,_that.cancelledBy,_that.cancelReason,_that.bookingCreatedBy,_that.queueNumber,_that.ticketCode,_that.peopleBefore);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: "booking_date")  DateTime bookingDate, @JsonKey(name: "patient_id")  String? patientId, @JsonKey(name: "patient_name")  String? patientName, @JsonKey(name: "patient_phone")  String? patientPhone, @JsonKey(name: "patient_address")  String? patientAddress, @JsonKey(name: "patient_type")  PatientType? patientType,  BookingShift shift, @JsonKey(name: "booking_status")  BookingStatus? bookingStatus, @JsonKey(name: "created_at")  DateTime? createdAt, @JsonKey(name: "updated_at")  DateTime? updatedAt, @JsonKey(name: "cancelled_at")  DateTime? cancelledAt, @JsonKey(name: "completed_at")  DateTime? completedAt, @JsonKey(name: "cancelled_by")  String? cancelledBy, @JsonKey(name: "cancel_reason")  String? cancelReason, @JsonKey(name: "booking_created_by")  String? bookingCreatedBy, @JsonKey(name: 'queue_number', fromJson: queueNumberFromJson, toJson: queueNumberToJson)  String? queueNumber, @JsonKey(name: 'ticket_code')  String? ticketCode, @JsonKey(name: 'people_before')  int? peopleBefore)?  $default,) {final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
return $default(_that.id,_that.bookingDate,_that.patientId,_that.patientName,_that.patientPhone,_that.patientAddress,_that.patientType,_that.shift,_that.bookingStatus,_that.createdAt,_that.updatedAt,_that.cancelledAt,_that.completedAt,_that.cancelledBy,_that.cancelReason,_that.bookingCreatedBy,_that.queueNumber,_that.ticketCode,_that.peopleBefore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingModel implements BookingModel {
  const _BookingModel({this.id, @JsonKey(name: "booking_date") required this.bookingDate, @JsonKey(name: "patient_id") this.patientId, @JsonKey(name: "patient_name") this.patientName, @JsonKey(name: "patient_phone") this.patientPhone, @JsonKey(name: "patient_address") this.patientAddress, @JsonKey(name: "patient_type") this.patientType, required this.shift, @JsonKey(name: "booking_status") this.bookingStatus, @JsonKey(name: "created_at") this.createdAt, @JsonKey(name: "updated_at") this.updatedAt, @JsonKey(name: "cancelled_at") this.cancelledAt, @JsonKey(name: "completed_at") this.completedAt, @JsonKey(name: "cancelled_by") this.cancelledBy, @JsonKey(name: "cancel_reason") this.cancelReason, @JsonKey(name: "booking_created_by") this.bookingCreatedBy, @JsonKey(name: 'queue_number', fromJson: queueNumberFromJson, toJson: queueNumberToJson) this.queueNumber, @JsonKey(name: 'ticket_code') this.ticketCode, @JsonKey(name: 'people_before') this.peopleBefore});
  factory _BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);

@override final  String? id;
@override@JsonKey(name: "booking_date") final  DateTime bookingDate;
// @JsonKey(name: 'booking_time') required String bookingTime,
@override@JsonKey(name: "patient_id") final  String? patientId;
@override@JsonKey(name: "patient_name") final  String? patientName;
@override@JsonKey(name: "patient_phone") final  String? patientPhone;
@override@JsonKey(name: "patient_address") final  String? patientAddress;
@override@JsonKey(name: "patient_type") final  PatientType? patientType;
@override final  BookingShift shift;
@override@JsonKey(name: "booking_status") final  BookingStatus? bookingStatus;
@override@JsonKey(name: "created_at") final  DateTime? createdAt;
@override@JsonKey(name: "updated_at") final  DateTime? updatedAt;
@override@JsonKey(name: "cancelled_at") final  DateTime? cancelledAt;
@override@JsonKey(name: "completed_at") final  DateTime? completedAt;
@override@JsonKey(name: "cancelled_by") final  String? cancelledBy;
@override@JsonKey(name: "cancel_reason") final  String? cancelReason;
@override@JsonKey(name: "booking_created_by") final  String? bookingCreatedBy;
// @JsonKey(name: 'queue_number') String? queueNumber,
@override@JsonKey(name: 'queue_number', fromJson: queueNumberFromJson, toJson: queueNumberToJson) final  String? queueNumber;
@override@JsonKey(name: 'ticket_code') final  String? ticketCode;
// إضافة حقل جديد
@override@JsonKey(name: 'people_before') final  int? peopleBefore;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingModelCopyWith<_BookingModel> get copyWith => __$BookingModelCopyWithImpl<_BookingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingDate, bookingDate) || other.bookingDate == bookingDate)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.patientPhone, patientPhone) || other.patientPhone == patientPhone)&&(identical(other.patientAddress, patientAddress) || other.patientAddress == patientAddress)&&(identical(other.patientType, patientType) || other.patientType == patientType)&&(identical(other.shift, shift) || other.shift == shift)&&(identical(other.bookingStatus, bookingStatus) || other.bookingStatus == bookingStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledBy, cancelledBy) || other.cancelledBy == cancelledBy)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.bookingCreatedBy, bookingCreatedBy) || other.bookingCreatedBy == bookingCreatedBy)&&(identical(other.queueNumber, queueNumber) || other.queueNumber == queueNumber)&&(identical(other.ticketCode, ticketCode) || other.ticketCode == ticketCode)&&(identical(other.peopleBefore, peopleBefore) || other.peopleBefore == peopleBefore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,bookingDate,patientId,patientName,patientPhone,patientAddress,patientType,shift,bookingStatus,createdAt,updatedAt,cancelledAt,completedAt,cancelledBy,cancelReason,bookingCreatedBy,queueNumber,ticketCode,peopleBefore]);

@override
String toString() {
  return 'BookingModel(id: $id, bookingDate: $bookingDate, patientId: $patientId, patientName: $patientName, patientPhone: $patientPhone, patientAddress: $patientAddress, patientType: $patientType, shift: $shift, bookingStatus: $bookingStatus, createdAt: $createdAt, updatedAt: $updatedAt, cancelledAt: $cancelledAt, completedAt: $completedAt, cancelledBy: $cancelledBy, cancelReason: $cancelReason, bookingCreatedBy: $bookingCreatedBy, queueNumber: $queueNumber, ticketCode: $ticketCode, peopleBefore: $peopleBefore)';
}


}

/// @nodoc
abstract mixin class _$BookingModelCopyWith<$Res> implements $BookingModelCopyWith<$Res> {
  factory _$BookingModelCopyWith(_BookingModel value, $Res Function(_BookingModel) _then) = __$BookingModelCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: "booking_date") DateTime bookingDate,@JsonKey(name: "patient_id") String? patientId,@JsonKey(name: "patient_name") String? patientName,@JsonKey(name: "patient_phone") String? patientPhone,@JsonKey(name: "patient_address") String? patientAddress,@JsonKey(name: "patient_type") PatientType? patientType, BookingShift shift,@JsonKey(name: "booking_status") BookingStatus? bookingStatus,@JsonKey(name: "created_at") DateTime? createdAt,@JsonKey(name: "updated_at") DateTime? updatedAt,@JsonKey(name: "cancelled_at") DateTime? cancelledAt,@JsonKey(name: "completed_at") DateTime? completedAt,@JsonKey(name: "cancelled_by") String? cancelledBy,@JsonKey(name: "cancel_reason") String? cancelReason,@JsonKey(name: "booking_created_by") String? bookingCreatedBy,@JsonKey(name: 'queue_number', fromJson: queueNumberFromJson, toJson: queueNumberToJson) String? queueNumber,@JsonKey(name: 'ticket_code') String? ticketCode,@JsonKey(name: 'people_before') int? peopleBefore
});




}
/// @nodoc
class __$BookingModelCopyWithImpl<$Res>
    implements _$BookingModelCopyWith<$Res> {
  __$BookingModelCopyWithImpl(this._self, this._then);

  final _BookingModel _self;
  final $Res Function(_BookingModel) _then;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? bookingDate = null,Object? patientId = freezed,Object? patientName = freezed,Object? patientPhone = freezed,Object? patientAddress = freezed,Object? patientType = freezed,Object? shift = null,Object? bookingStatus = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? cancelledAt = freezed,Object? completedAt = freezed,Object? cancelledBy = freezed,Object? cancelReason = freezed,Object? bookingCreatedBy = freezed,Object? queueNumber = freezed,Object? ticketCode = freezed,Object? peopleBefore = freezed,}) {
  return _then(_BookingModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,bookingDate: null == bookingDate ? _self.bookingDate : bookingDate // ignore: cast_nullable_to_non_nullable
as DateTime,patientId: freezed == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String?,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,patientPhone: freezed == patientPhone ? _self.patientPhone : patientPhone // ignore: cast_nullable_to_non_nullable
as String?,patientAddress: freezed == patientAddress ? _self.patientAddress : patientAddress // ignore: cast_nullable_to_non_nullable
as String?,patientType: freezed == patientType ? _self.patientType : patientType // ignore: cast_nullable_to_non_nullable
as PatientType?,shift: null == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as BookingShift,bookingStatus: freezed == bookingStatus ? _self.bookingStatus : bookingStatus // ignore: cast_nullable_to_non_nullable
as BookingStatus?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledBy: freezed == cancelledBy ? _self.cancelledBy : cancelledBy // ignore: cast_nullable_to_non_nullable
as String?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,bookingCreatedBy: freezed == bookingCreatedBy ? _self.bookingCreatedBy : bookingCreatedBy // ignore: cast_nullable_to_non_nullable
as String?,queueNumber: freezed == queueNumber ? _self.queueNumber : queueNumber // ignore: cast_nullable_to_non_nullable
as String?,ticketCode: freezed == ticketCode ? _self.ticketCode : ticketCode // ignore: cast_nullable_to_non_nullable
as String?,peopleBefore: freezed == peopleBefore ? _self.peopleBefore : peopleBefore // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
