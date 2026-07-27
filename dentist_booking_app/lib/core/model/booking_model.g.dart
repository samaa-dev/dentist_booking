// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingModelImpl _$$BookingModelImplFromJson(Map<String, dynamic> json) =>
    _$BookingModelImpl(
      id: json['id'] as String?,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      patientId: json['patient_id'] as String?,
      patientName: json['patient_name'] as String?,
      patientPhone: json['patient_phone'] as String?,
      patientAddress: json['patient_address'] as String?,
      patientType: $enumDecodeNullable(
        _$PatientTypeEnumMap,
        json['patient_type'],
      ),
      shift: $enumDecode(_$BookingShiftEnumMap, json['shift']),
      bookingStatus: $enumDecodeNullable(
        _$BookingStatusEnumMap,
        json['booking_status'],
      ),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      cancelledAt: json['cancelled_at'] == null
          ? null
          : DateTime.parse(json['cancelled_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      cancelledBy: json['cancelled_by'] as String?,
      cancelReason: json['cancel_reason'] as String?,
      bookingCreatedBy: json['booking_created_by'] as String?,
      queueNumber: queueNumberFromJson(json['queue_number']),
      ticketCode: json['ticket_code'] as String?,
      peopleBefore: (json['people_before'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$BookingModelImplToJson(_$BookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_date': instance.bookingDate.toIso8601String(),
      'patient_id': instance.patientId,
      'patient_name': instance.patientName,
      'patient_phone': instance.patientPhone,
      'patient_address': instance.patientAddress,
      'patient_type': _$PatientTypeEnumMap[instance.patientType],
      'shift': _$BookingShiftEnumMap[instance.shift]!,
      'booking_status': _$BookingStatusEnumMap[instance.bookingStatus],
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'cancelled_at': instance.cancelledAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'cancelled_by': instance.cancelledBy,
      'cancel_reason': instance.cancelReason,
      'booking_created_by': instance.bookingCreatedBy,
      'queue_number': queueNumberToJson(instance.queueNumber),
      'ticket_code': instance.ticketCode,
      'people_before': instance.peopleBefore,
    };

const _$PatientTypeEnumMap = {
  PatientType.registered: 'registered',
  PatientType.guest: 'guest',
};

const _$BookingShiftEnumMap = {
  BookingShift.morning: 'morning',
  BookingShift.evening: 'evening',
};

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelledByPatient: 'cancelledByPatient',
  BookingStatus.cancelledByStaff: 'cancelledByStaff',
  BookingStatus.noShow: 'noShow',
};
