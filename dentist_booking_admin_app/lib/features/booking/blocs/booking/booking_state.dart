part of 'booking_cubit.dart';

@freezed
class BookingState with _$BookingState {
  const factory BookingState.initial() = _Initial;
  const factory BookingState.loading() = Loading;
  const factory BookingState.loaded(List<BookingModel> bookings) = Loaded;
  const factory BookingState.error(String message) = Error;
}
