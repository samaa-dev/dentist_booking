part of 'queue_cubit.dart';

@freezed
class QueueState with _$QueueState {
  const factory QueueState.initial() = _Initial;

  const factory QueueState.loading() = _Loading;

  const factory QueueState.statusLoaded(
    QueueStatusModel status,
  ) = _StatusLoaded;

  const factory QueueState.nextLoaded(
    QueueModel queue,
  ) = _NextLoaded;

  const factory QueueState.stopped(
    String reason,
  ) = _Stopped;

  const factory QueueState.processing() = _Processing;

  const factory QueueState.error(
    String message,
  ) = _Error;

  const factory QueueState.errorUpdateBooking(
    String message,
  ) = ErrorUpdateBooking;

  const factory QueueState.successUpdateBooking(
    BookingModel booking,
  ) = SuccessUpdateBooking;
}
