part of 'staff_cubit.dart';

@freezed
class StaffState with _$StaffState {
  const factory StaffState.initial() = _Initial;
  const factory StaffState.loading() = Loading;
  const factory StaffState.loaded(List<StaffModel> staffs) = Loaded;
  const factory StaffState.error(String message) = Error;

  //Profile
  const factory StaffState.loadingProfile() = LoadingProfile;
  const factory StaffState.loadedProfile(List<ProfileModel> profile) =
      LoadedProfile;
  const factory StaffState.errorProfile(String message) = ErrorProfile;

  ///Staff error Add, Update, Delete
  const factory StaffState.errorAddStaff(String message) = ErrorAddStaff;
  const factory StaffState.errorUpdateStaff(String message) = ErrorUpdateStaff;
  const factory StaffState.errorDeleteStaff(String message) = ErrorDeleteStaff;
  const factory StaffState.errorChangePasswordStaff(String message) =
      ErrorChangePasswordStaff;

  ///Staff success Add, Update, Delete
  const factory StaffState.successAddStaff(
    StaffModel staff,
  ) = SuccessAddStaff;
  const factory StaffState.successUpdateStaff(
    StaffModel staff,
  ) = SuccessUpdateStaff;
  const factory StaffState.successDeleteStaff(
    StaffModel? staff,
  ) = SuccessDeleteStaff;

  const factory StaffState.successChangePasswordStaff(
    String message,
  ) = SuccessChangePasswordStaff;

  const factory StaffState.loadingStaff() = LoadingStaff;

  ///
}
