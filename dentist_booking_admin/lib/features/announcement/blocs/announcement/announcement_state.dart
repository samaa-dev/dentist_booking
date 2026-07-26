part of 'announcement_cubit.dart';

@freezed
class AnnouncementState with _$AnnouncementState {
  const factory AnnouncementState.initial() = _Initial;

  const factory AnnouncementState.loading() = _Loading;
  const factory AnnouncementState.loaded(
    List<AnnouncementModel> announcements,
  ) = _Loaded;
  const factory AnnouncementState.error(
    String message,
  ) = _Error;

  const factory AnnouncementState.loadingAnnouncement() = LoadingAnnouncement;

  ///Staff error Add, Update, Delete
  const factory AnnouncementState.errorAddAnnouncement(
    String message,
  ) = _ErrorAddAnnouncement;
  const factory AnnouncementState.errorUpdateAnnouncement(
    String message,
  ) = _ErrorUpdateAnnouncement;
  const factory AnnouncementState.errorDeleteAnnouncement(
    String message,
  ) = _ErrorDeleteAnnouncement;

  ///Staff success Add, Update, Delete
  const factory AnnouncementState.successAddAnnouncement(
    AnnouncementModel announcements,
  ) = _SuccessAddStaff;

  const factory AnnouncementState.successUpdateAnnouncement(
    AnnouncementModel announcements,
  ) = _SuccessUpdateStaff;

  const factory AnnouncementState.successDeleteAnnouncement(
    AnnouncementModel? announcements,
  ) = _SuccessDeleteAnnouncement;
}
