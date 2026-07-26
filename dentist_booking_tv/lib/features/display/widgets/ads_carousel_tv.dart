import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dentist_booking_tv/core/config/env_config.dart';
import 'package:dentist_booking_tv/core/model/ads_model.dart';
import 'package:dentist_booking_tv/core/utils/algerian_date_format.dart';
import 'package:dentist_booking_tv/core/utils/tv_scale.dart';
import 'package:flutter/material.dart';

class AdsCarouselTv extends StatefulWidget {
  const AdsCarouselTv({super.key, required this.ads});

  final List<AdsModel> ads;

  @override
  State<AdsCarouselTv> createState() => _AdsCarouselTvState();
}

class _AdsCarouselTvState extends State<AdsCarouselTv> {
  int _currentIndex = 0;
  Timer? _timeTimer;

  List<String> get _imageUrls {
    final urls = <String>[];
    for (final ad in widget.ads) {
      if (ad.linkUrl != null && ad.linkUrl!.isNotEmpty) {
        urls.add(ad.linkUrl!);
      }
      if (ad.images != null && ad.images!.isNotEmpty) {
        urls.addAll(ad.images!);
      }
    }
    return urls;
  }

  /// First ad for overlay title/body when carousel has content.
  AdsModel? get _firstAd => widget.ads.isNotEmpty ? widget.ads.first : null;

  @override
  void initState() {
    super.initState();
    _timeTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final urls = _imageUrls;
    final now = DateTime.now();

    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBackground(context, colorScheme, urls),
        /*if (urls.isNotEmpty) _buildGradientAndText(context, colorScheme),*/
        if (urls.isNotEmpty)
          _buildCarouselDots(context, colorScheme, urls.length),
        _buildHeaderOverlay(context, colorScheme, now),
      ],
    );
  }

  Widget _buildBackground(
    BuildContext context,
    ColorScheme colorScheme,
    List<String> urls,
  ) {
    if (urls.isEmpty) {
      return ColoredBox(
        color: colorScheme.primary.withOpacity(0.06),
        child: Center(
          child: Text(
            'لا توجد إعلانات',
            style: TextStyle(
              fontSize: context.s(22),
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return CarouselSlider.builder(
          itemCount: urls.length,
          itemBuilder: (context, index, realIndex) {
            return SizedBox.expand(
              child: CachedNetworkImage(
                imageUrl: urls[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (_, __) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported,
                    size: context.s(48),
                    color: colorScheme.outline,
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: height,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            onPageChanged: (index, _) => setState(() => _currentIndex = index),
          ),
        );
      },
    );
  }

  Widget _buildGradientAndText(BuildContext context, ColorScheme colorScheme) {
    final ad = _firstAd;
    final title = ad?.title ?? 'نعتني بابتسامتكم بأحدث التقنيات';
    final body =
        ad?.body ??
        'احصل على استشارة مجانية اليوم مع نخبة من أطباء الأسنان المتخصصين. عروض تبييض الأسنان لفترة محدودة.';

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          context.s(48),
          context.s(80),
          context.s(48),
          context.s(56),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: context.s(40),
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: context.s(16)),
            Text(
              body,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: context.s(22),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselDots(
    BuildContext context,
    ColorScheme colorScheme,
    int count,
  ) {
    final dotSize = context.s(12);
    return Positioned(
      left: 0,
      right: 0,
      bottom: context.s(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count,
          (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: context.s(6)),
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == index
                  ? colorScheme.primary
                  : Colors.white.withOpacity(0.4),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderOverlay(
    BuildContext context,
    ColorScheme colorScheme,
    DateTime now,
  ) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.all(context.s(32)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: _ClinicBrandingCard(
                clinicName: EnvConfig.clinicDisplayName,
                tagline: EnvConfig.clinicTagline,
                primaryColor: colorScheme.primary,
              ),
            ),
            SizedBox(width: context.s(16)),
            _TimeDateCard(
              time: AlgerianDateFormat.formatTime(now),
              date: AlgerianDateFormat.formatDate(now),
              primaryColor: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ClinicBrandingCard extends StatelessWidget {
  const _ClinicBrandingCard({
    required this.clinicName,
    required this.tagline,
    required this.primaryColor,
  });

  final String clinicName;
  final String tagline;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.s(12)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.s(20),
            vertical: context.s(16),
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(context.s(12)),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(context.s(8)),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(context.s(8)),
                ),
                child: Icon(
                  Icons.medical_services,
                  color: Colors.white,
                  size: context.s(32),
                ),
              ),
              SizedBox(width: context.s(16)),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      clinicName,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: context.s(24),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.s(4)),
                    Text(
                      tagline,
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: context.s(22),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeDateCard extends StatelessWidget {
  const _TimeDateCard({
    required this.time,
    required this.date,
    required this.primaryColor,
  });

  final String time;
  final String date;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.s(12)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.s(20),
          vertical: context.s(16),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(context.s(12)),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: const Color(0xFF1E293B),
                    fontSize: context.s(24),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.s(4)),
                Text(
                  date,
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: context.s(22),
                  ),
                ),
              ],
            ),
            SizedBox(width: context.s(16)),
            Icon(Icons.schedule, color: primaryColor, size: context.s(32)),
          ],
        ),
      ),
    );
  }
}
