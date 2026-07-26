import 'package:freezed_annotation/freezed_annotation.dart';

import 'clinic_settings_model.dart';
import 'working_hours_model.dart';

part 'clinic_config_model.freezed.dart';
part 'clinic_config_model.g.dart';

@freezed
class ClinicConfigModel with _$ClinicConfigModel {
  const factory ClinicConfigModel({
    required ClinicSettingsModel settings,
    @JsonKey(name: "working_hours")
    required List<WorkingHoursModel> workingHours,
  }) = _ClinicConfigModel;

  factory ClinicConfigModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicConfigModelFromJson(json);
}
