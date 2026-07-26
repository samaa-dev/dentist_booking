part of 'booking_create_cubit.dart';

@freezed
class BookingCreateState with _$BookingCreateState {
  const factory BookingCreateState.initial() = _Initial;
  const factory BookingCreateState.loading() = _Loading;

  const factory BookingCreateState.successBookingCreate(
    BookingModel booking,
  ) = _SuccessBookingCreate;

  const factory BookingCreateState.errorBookingCreate(
    String message,
  ) = _ErrorBookingCreate;
}
