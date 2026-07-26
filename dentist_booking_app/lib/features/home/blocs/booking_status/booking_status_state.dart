part of 'booking_status_cubit.dart';

@freezed
class BookingStatusState with _$BookingStatusState {
  const factory BookingStatusState.initial() = _Initial;
  const factory BookingStatusState.loading() = _Loading;
  const factory BookingStatusState.loaded(BookingStatusModel status) = _Loaded;
  const factory BookingStatusState.error({required String message}) = _Error;
}
