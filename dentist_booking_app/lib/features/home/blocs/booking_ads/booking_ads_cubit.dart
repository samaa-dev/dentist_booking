import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/model/ads_model.dart';
import '../../repo/booking_ads_repo.dart';

part 'booking_ads_cubit.freezed.dart';
part 'booking_ads_state.dart';

class BookingAdsCubit extends Cubit<BookingAdsState> {
  final BookingAdsRepo _bookingAdsRepo;

  BookingAdsCubit({
    required BookingAdsRepo bookingAdsRepo,
  }) : _bookingAdsRepo = bookingAdsRepo,
       super(BookingAdsState.initial());

  Future<void> getBookingAds() async {
    emit(BookingAdsState.loading());
    try {
      final ads = await _bookingAdsRepo.getBookinAds();
      emit(BookingAdsState.success(ads));
    } catch (e) {
      emit(BookingAdsState.failure(e.toString()));
    }
  }
}
