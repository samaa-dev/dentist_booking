part of 'booking_count_cubit.dart';

@freezed
class BookingCountState with _$BookingCountState {
  const factory BookingCountState.initial() = _Initial;
  const factory BookingCountState.statusCounts(Map<BookingStatus, int> counts) =
      _StatusCounts;
}
