part of 'queue_cubit.dart';

@freezed
class QueueState with _$QueueState {
  const factory QueueState.initial() = _Initial;

  /// يتم استدعاؤها أثناء الاتصال بـ Supabase
  const factory QueueState.loading() = _Loading;

  /// حالة الشاشة — تعرض حالة النظام + الحجز القادم (إن وجد)
  const factory QueueState.statusLoaded(
    QueueStatusModel status,
  ) = _StatusLoaded;

  /// عند تنفيذ nextQueue بنجاح
  const factory QueueState.nextLoaded(
    QueueModel queue,
  ) = _NextLoaded;

  /// عند توقف أو انتهاء الطابور
  const factory QueueState.stopped(
    String reason,
  ) = _Stopped;

  const factory QueueState.processing() = _Processing;

  /// أي خطأ
  const factory QueueState.error(
    String message,
  ) = _Error;

  const factory QueueState.errorUpdateBooking(
    String message,
  ) = ErrorUpdateBooking;

  const factory QueueState.successUpdateBooking(
    BookingModel booking,
  ) = SuccessUpdateBooking;

  // const factory QueueState.paused() = _Paused;
}
