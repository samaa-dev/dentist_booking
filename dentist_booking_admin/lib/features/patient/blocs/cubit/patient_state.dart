part of 'patient_cubit.dart';

@freezed
class PatientState with _$PatientState {
  const factory PatientState.initial() = _Initial;
  const factory PatientState.loading() = _Loading;
  const factory PatientState.loaded(List<ProfileModel> patient) = _Loaded;
  const factory PatientState.error(String message) = _Error;

  const factory PatientState.successUpdatePatient(
    ProfileModel staff,
  ) = _SuccessUpdatePatient;
}
