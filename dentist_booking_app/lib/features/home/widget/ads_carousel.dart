import 'package:dentist_booking_app/features/home/blocs/booking_ads/booking_ads_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/app_setup.dart';
import '../../../core/util/util.dart';
import '../../../core/widgets/carousel_banner.dart';

class AdsCarousel extends StatelessWidget {
  const AdsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingAdsCubit>(
      create: (context) => getIt<BookingAdsCubit>()..getBookingAds(),
      child: BlocListener<BookingAdsCubit, BookingAdsState>(
        listener: (context, state) {
          state.maybeMap(
            orElse: () => {},
            failure: (failure) => SnackbarMes.showToastMsg(context, message: failure.message),
          );
        },
        child: _AdsCarouselLayout(),
      ),
    );
  }
}

class _AdsCarouselLayout extends StatelessWidget {
  const _AdsCarouselLayout();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingAdsCubit, BookingAdsState>(
      builder: (context, state) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 700),
          curve: Curves.fastOutSlowIn,
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 40 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: SizedBox(
            height: 215,
            child: state.maybeMap(
              loading: (_) => CarouselBanner(imageUrls: ['', '', '']),
              orElse: () => CarouselBanner(imageUrls: ['', '', '']),
              success: (data) {
                final List<String> allMedia = [];

                for (var ad in data.ads) {
                  if (ad.linkUrl != null && ad.linkUrl!.isNotEmpty) {
                    allMedia.add(ad.linkUrl!);
                  }
                  if (ad.images != null && ad.images!.isNotEmpty) {
                    allMedia.addAll(ad.images!);
                  }
                }

                if (allMedia.isEmpty) {
                  return CarouselBanner(imageUrls: ['', '', '']);
                }

                return CarouselBanner(imageUrls: allMedia);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerAdsCarouselSliver(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      alignment: Alignment.center,
      children: [
        Shimmer.fromColors(
          baseColor: colorScheme.primaryContainer.withOpacity(0.5),
          highlightColor: colorScheme.primary.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 215, // تم ضبط الارتفاع ليتناسب مع الكاروسيل
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        Icon(
          HugeIcons.strokeRoundedMonocle01,
          size: 20,
          color: colorScheme.primary.withOpacity(0.8),
        ),
      ],
    );
  }
}
