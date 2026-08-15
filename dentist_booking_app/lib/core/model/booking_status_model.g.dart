// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$$BookingStatusModelImplImpl _$$$BookingStatusModelImplImplFromJson(
  Map<String, dynamic> json,
) => _$$BookingStatusModelImplImpl(
  isOpen: json['is_open'] as bool?,
  shift: $enumDecodeNullable(_$BookingShiftEnumMap, json['shift']),
  timeLeft: (json['time_left'] as num?)?.toInt(),
  isBookingEnabled: json['is_booking_enabled'] as bool?,
  stopReason: json['stop_reason'] as String?,
  shiftClosed: $enumDecodeNullable(_$BookingShiftEnumMap, json['shift_closed']),
  shiftFull: $enumDecodeNullable(_$BookingShiftEnumMap, json['shift_full']),
  morningFull: json['morning_full'] as bool?,
  eveningFull: json['evening_full'] as bool?,
  morningAvailable: json['morning_available'] as bool?,
  eveningAvailable: json['evening_available'] as bool?,
);

Map<String, dynamic> _$$$BookingStatusModelImplImplToJson(
  _$$BookingStatusModelImplImpl instance,
) => <String, dynamic>{
  'is_open': instance.isOpen,
  'shift': _$BookingShiftEnumMap[instance.shift],
  'time_left': instance.timeLeft,
  'is_booking_enabled': instance.isBookingEnabled,
  'stop_reason': instance.stopReason,
  'shift_closed': _$BookingShiftEnumMap[instance.shiftClosed],
  'shift_full': _$BookingShiftEnumMap[instance.shiftFull],
  'morning_full': instance.morningFull,
  'evening_full': instance.eveningFull,
  'morning_available': instance.morningAvailable,
  'evening_available': instance.eveningAvailable,
};

const _$BookingShiftEnumMap = {
  BookingShift.morning: 'morning',
  BookingShift.evening: 'evening',
};
