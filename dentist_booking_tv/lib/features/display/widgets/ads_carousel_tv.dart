import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dentist_booking_tv/core/config/env_config.dart';
import 'package:dentist_booking_tv/core/model/ads_model.dart';
import 'package:dentist_booking_tv/core/utils/algerian_date_format.dart';
import 'package:dentist_booking_tv/core/utils/media_url_utils.dart';
import 'package:dentist_booking_tv/core/utils/tv_scale.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AdsCarouselTv extends StatefulWidget {
  const AdsCarouselTv({super.key, required this.ads});

  final List<AdsModel> ads;

  @override
  State<AdsCarouselTv> createState() => _AdsCarouselTvState();
}

class _AdsCarouselTvState extends State<AdsCarouselTv> {
  static const _imageAutoPlayInterval = Duration(seconds: 5);

  int _currentIndex = 0;
  bool _isVideoPlaying = false;
  Timer? _timeTimer;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  List<String> get _mediaUrls {
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

  bool _isCurrentVideo(List<String> urls) =>
      urls.isNotEmpty && isVideoUrl(urls[_currentIndex.clamp(0, urls.length - 1)]);

  @override
  void initState() {
    super.initState();
    _timeTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => setState(() {}),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final urls = _mediaUrls;
      if (urls.isNotEmpty && isVideoUrl(urls.first)) {
        setState(() => _isVideoPlaying = true);
      }
    });
  }

  @override
  void dispose() {
    _timeTimer?.cancel();
    super.dispose();
  }

  void _onPageChanged(int index, List<String> urls) {
    final isVideo = index >= 0 && index < urls.length && isVideoUrl(urls[index]);
    setState(() {
      _currentIndex = index;
      _isVideoPlaying = isVideo;
    });
  }

  void _advanceAfterVideo() {
    if (!mounted) return;
    setState(() => _isVideoPlaying = false);
    _carouselController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final urls = _mediaUrls;
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

    final pauseForVideo = _isVideoPlaying || _isCurrentVideo(urls);

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: urls.length,
          itemBuilder: (context, index, realIndex) {
            final url = urls[index];
            final active = index == _currentIndex;
            if (isVideoUrl(url)) {
              return SizedBox.expand(
                child: _TvAdVideoSlide(
                  key: ValueKey('tv-ad-video-$index-$url'),
                  url: url,
                  isActive: active,
                  onFinished: _advanceAfterVideo,
                ),
              );
            }
            return SizedBox.expand(
              child: CachedNetworkImage(
                imageUrl: url,
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
            autoPlay: !pauseForVideo,
            autoPlayInterval: _imageAutoPlayInterval,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            onPageChanged: (index, _) => _onPageChanged(index, urls),
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

/// Muted network video for an ads carousel slide. Plays only while [isActive].
class _TvAdVideoSlide extends StatefulWidget {
  const _TvAdVideoSlide({
    super.key,
    required this.url,
    required this.isActive,
    required this.onFinished,
  });

  final String url;
  final bool isActive;
  final VoidCallback onFinished;

  /// Skip if init fails or stalls.
  static const initTimeout = Duration(seconds: 8);

  /// Cap how long a single video may hold the carousel.
  static const maxDisplayDuration = Duration(seconds: 90);

  @override
  State<_TvAdVideoSlide> createState() => _TvAdVideoSlideState();
}

class _TvAdVideoSlideState extends State<_TvAdVideoSlide> {
  VideoPlayerController? _controller;
  bool _finishedNotified = false;
  bool _hasError = false;
  Timer? _initTimeoutTimer;
  Timer? _maxDisplayTimer;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) {
      _startPlayback();
    }
  }

  @override
  void didUpdateWidget(covariant _TvAdVideoSlide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startPlayback();
    } else if (!widget.isActive && oldWidget.isActive) {
      _tearDown();
    }
  }

  @override
  void dispose() {
    _tearDown();
    super.dispose();
  }

  void _notifyFinished() {
    if (_finishedNotified || !mounted) return;
    _finishedNotified = true;
    _cancelTimers();
    widget.onFinished();
  }

  void _cancelTimers() {
    _initTimeoutTimer?.cancel();
    _initTimeoutTimer = null;
    _maxDisplayTimer?.cancel();
    _maxDisplayTimer = null;
  }

  Future<void> _tearDown() async {
    _cancelTimers();
    final controller = _controller;
    _controller = null;
    if (controller == null) return;
    controller.removeListener(_onControllerUpdate);
    try {
      await controller.pause();
    } catch (_) {}
    await controller.dispose();
    if (mounted) {
      setState(() {
        _hasError = false;
        _finishedNotified = false;
      });
    } else {
      _hasError = false;
      _finishedNotified = false;
    }
  }

  Future<void> _startPlayback() async {
    await _tearDown();
    if (!mounted || !widget.isActive) return;

    _finishedNotified = false;
    _hasError = false;

    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller = controller;
    controller.addListener(_onControllerUpdate);

    _initTimeoutTimer = Timer(_TvAdVideoSlide.initTimeout, () {
      if (!mounted || _finishedNotified) return;
      if (!(_controller?.value.isInitialized ?? false)) {
        debugPrint('TV ad video init timeout: ${widget.url}');
        _notifyFinished();
      }
    });

    _maxDisplayTimer = Timer(_TvAdVideoSlide.maxDisplayDuration, () {
      if (!mounted || _finishedNotified) return;
      debugPrint('TV ad video max display reached: ${widget.url}');
      _notifyFinished();
    });

    try {
      await controller.initialize();
      if (!mounted || _controller != controller || !widget.isActive) {
        await controller.dispose();
        return;
      }
      _initTimeoutTimer?.cancel();
      _initTimeoutTimer = null;
      await controller.setLooping(false);
      await controller.setVolume(0);
      await controller.play();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('TV ad video error: $e');
      if (!mounted) return;
      setState(() => _hasError = true);
      _notifyFinished();
    }
  }

  void _onControllerUpdate() {
    final controller = _controller;
    if (controller == null || _finishedNotified) return;
    final value = controller.value;
    if (value.hasError) {
      debugPrint('TV ad video playback error: ${value.errorDescription}');
      _notifyFinished();
      return;
    }
    if (!value.isInitialized || value.duration <= Duration.zero) return;
    // Treat near-end as completed (some devices never report exact duration).
    if (value.position + const Duration(milliseconds: 350) >= value.duration) {
      _notifyFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final controller = _controller;

    if (_hasError || controller == null || !controller.value.isInitialized) {
      return ColoredBox(
        color: colorScheme.surfaceContainerHighest,
        child: Center(
          child: _hasError
              ? Icon(
                  Icons.videocam_off_outlined,
                  size: context.s(48),
                  color: colorScheme.outline,
                )
              : const CircularProgressIndicator(),
        ),
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: controller.value.size.width,
        height: controller.value.size.height,
        child: VideoPlayer(controller),
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
