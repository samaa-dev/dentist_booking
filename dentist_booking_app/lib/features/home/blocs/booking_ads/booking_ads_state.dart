part of 'booking_ads_cubit.dart';

@freezed
class BookingAdsState with _$BookingAdsState {
  const factory BookingAdsState.initial() = _Initial;
  const factory BookingAdsState.loading() = _Loading;
  const factory BookingAdsState.success(List<AdsModel> ads) = _Success;
  const factory BookingAdsState.failure(String message) = _Failure;
}
