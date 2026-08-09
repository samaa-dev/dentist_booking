import 'package:freezed_annotation/freezed_annotation.dart';

part 'working_hours_model.freezed.dart';
part 'working_hours_model.g.dart';

@freezed
class WorkingHoursModel with _$WorkingHoursModel {
  const factory WorkingHoursModel({
    required String id,

    @JsonKey(name: "day_of_week") required int dayOfWeek,
    @JsonKey(name: "is_open") required bool isOpen,

    @JsonKey(name: "morning_start") String? morningStart,
    @JsonKey(name: "morning_end") String? morningEnd,
    @JsonKey(name: "evening_start") String? eveningStart,
    @JsonKey(name: "evening_end") String? eveningEnd,

    @JsonKey(name: "morning_is_open") @Default(true) bool morningIsOpen,
    @JsonKey(name: "evening_is_open") @Default(true) bool eveningIsOpen,

    @JsonKey(name: "created_at") required DateTime createdAt,
    @JsonKey(name: "updated_at") required DateTime updatedAt,
  }) = _WorkingHoursModel;

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) =>
      _$WorkingHoursModelFromJson(json);
}
