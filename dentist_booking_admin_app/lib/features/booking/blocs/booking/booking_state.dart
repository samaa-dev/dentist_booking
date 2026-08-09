part of 'booking_cubit.dart';

@freezed
class BookingState with _$BookingState {
  const factory BookingState.initial() = _Initial;
  const factory BookingState.loading() = Loading;
  const factory BookingState.loaded(List<BookingModel> bookings) = Loaded;
  const factory BookingState.error(String message) = Error;

  const factory BookingState.loadingbooking() = _LoadingBooking;

  const factory BookingState.errorAddBooking(String message) = ErrorAddBooking;
  const factory BookingState.errorUpdateBooking(String message) =
      ErrorUpdateBooking;

  const factory BookingState.successAddBooking(BookingModel booking) =
      SuccessAddBooking;
  const factory BookingState.successUpdateBooking(BookingModel booking) =
      SuccessUpdateBooking;

  const factory BookingState.loadingPatients() = _LoadingPatients;
  const factory BookingState.loadedPatients(List<ProfileModel> patients) =
      LoadedPatients;
  const factory BookingState.errorPatients(String message) = ErrorPatients;
}
