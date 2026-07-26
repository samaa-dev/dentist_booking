import 'package:dentist_booking_tv/core/model/ads_model.dart';
import 'package:dentist_booking_tv/core/model/queue_status_model.dart';

sealed class TvDisplayState {
  const TvDisplayState();
}

class TvDisplayInitial extends TvDisplayState {
  const TvDisplayInitial();
}

class TvDisplayLoading extends TvDisplayState {
  const TvDisplayLoading();
}

class TvDisplayLoaded extends TvDisplayState {
  const TvDisplayLoaded({
    required this.queueStatus,
    required this.ads,
    this.justCalledNumber,
    this.doctorDisplayName,
  });

  final QueueStatusModel queueStatus;
  final List<AdsModel> ads;
  /// Set when a new number was just called (current_queue_number changed). Cleared after overlay dismisses.
  final int? justCalledNumber;
  /// Optional doctor name/last name for the call overlay (from env or future API).
  final String? doctorDisplayName;

  TvDisplayLoaded copyWith({
    QueueStatusModel? queueStatus,
    List<AdsModel>? ads,
    int? justCalledNumber,
    String? doctorDisplayName,
  }) {
    return TvDisplayLoaded(
      queueStatus: queueStatus ?? this.queueStatus,
      ads: ads ?? this.ads,
      justCalledNumber: justCalledNumber ?? this.justCalledNumber,
      doctorDisplayName: doctorDisplayName ?? this.doctorDisplayName,
    );
  }

  /// Copy with justCalledNumber set to null (used when overlay is dismissed).
  TvDisplayLoaded copyWithClearJustCalled() {
    return TvDisplayLoaded(
      queueStatus: queueStatus,
      ads: ads,
      justCalledNumber: null,
      doctorDisplayName: doctorDisplayName,
    );
  }
}

class TvDisplayError extends TvDisplayState {
  const TvDisplayError(this.message);
  final String message;
}
