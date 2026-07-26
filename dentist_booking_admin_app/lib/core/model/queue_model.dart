import 'package:freezed_annotation/freezed_annotation.dart';

import 'booking_model.dart';

part 'queue_model.freezed.dart';
part 'queue_model.g.dart';

@freezed
class QueueModel with _$QueueModel {
  const factory QueueModel({
    bool? success,
    String? code,
    String? message,
    BookingModel? booking,
  }) = _QueueModel;

  factory QueueModel.fromJson(Map<String, dynamic> json) =>
      _$QueueModelFromJson(json);
}
