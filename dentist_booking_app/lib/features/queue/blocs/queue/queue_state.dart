part of 'queue_cubit.dart';

@freezed
class QueueState with _$QueueState {
  const factory QueueState.initial() = _Initial;
  const factory QueueState.loading() = _Loading;
  const factory QueueState.loaded(TrackingModel? queue) = _Loaded;
  const factory QueueState.error(String message) = _Error;
  const factory QueueState.activeQueueLoaded(List<TrackingModel> queues) = _ActiveQueueLoaded;
}
