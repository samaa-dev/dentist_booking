part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.initial() = _Initial;
  const factory SettingsState.loading() = _Loading;
  const factory SettingsState.loaded(ClinicConfigModel settings) = _Loaded;

  const factory SettingsState.loadingSetting() = _LoadingSetting;

  const factory SettingsState.error(String message) = _Error;
  const factory SettingsState.errorUpdateSetting(
    String message,
  ) = _ErrorUpdateSetting;

  const factory SettingsState.successUpdateSetting(
    ClinicConfigModel settings,
  ) = _SuccessUpdateSetting;
}
