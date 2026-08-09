import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'rounded_image.dart';

class CarouselBanner extends StatefulWidget {
  const CarouselBanner({
    super.key,
    required this.imageUrls,
    this.onTap,
  });

  final List<String> imageUrls;
  final void Function(int index)? onTap;

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  int _currentIndex = 0;
  bool _isVideoPlaying = false;
  final CarouselSliderController _carouselController = CarouselSliderController();

  bool _isYoutube(String url) => url.contains('youtube.com') || url.contains('youtu.be');

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: constraints.maxHeight,
                  autoPlay: !_isVideoPlaying,
                  autoPlayInterval: const Duration(seconds: 5),
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                      if (reason == CarouselPageChangedReason.manual) {
                        _isVideoPlaying = false;
                      }
                    });
                  },
                ),
                items: widget.imageUrls.map((url) {
                  return _isYoutube(url)
                      ? _YoutubeVideoWidget(
                          videoUrl: url,
                          onVideoStateChange: (isPlaying) {
                            if (_isVideoPlaying != isPlaying) {
                              setState(() => _isVideoPlaying = isPlaying);
                            }
                          },
                          onVideoEnd: () {
                            setState(() => _isVideoPlaying = false);
                            _carouselController.nextPage(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.fastOutSlowIn,
                            );
                          },
                        )
                      : RoundedImage(
                          onPressed: () {
                            if (widget.onTap != null) {
                              widget.onTap!(widget.imageUrls.indexOf(url));
                            }
                          },
                          borderRadius: 0,
                          height: constraints.maxHeight,
                          width: double.infinity,
                          isNetworkImage: true,
                          imageUrl: url,
                        );
                }).toList(),
              ),
            ),
            _buildIndicators(colorScheme),
          ],
        );
      },
    );
  }

  Widget _buildIndicators(ColorScheme colorScheme) {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.imageUrls.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: _currentIndex == index ? 14 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: _currentIndex == index ? colorScheme.primary : colorScheme.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
    );
  }
}

class _YoutubeVideoWidget extends StatefulWidget {
  final String videoUrl;
  final Function(bool isPlaying) onVideoStateChange;
  final VoidCallback onVideoEnd;

  const _YoutubeVideoWidget({
    required this.videoUrl,
    required this.onVideoStateChange,
    required this.onVideoEnd,
  });

  @override
  State<_YoutubeVideoWidget> createState() => _YoutubeVideoWidgetState();
}

class _YoutubeVideoWidgetState extends State<_YoutubeVideoWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _controller =
        YoutubePlayerController(
          initialVideoId: videoId!,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: true, // تشغيل بدون صوت كما طلبت
            disableDragSeek: true,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: false,
          ),
        )..addListener(() {
          if (_controller.value.isPlaying) {
            widget.onVideoStateChange(true);
          }
          if (_controller.value.playerState == PlayerState.ended) {
            widget.onVideoEnd();
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        bottomActions: [
          const SizedBox.shrink(),
          ProgressBar(isExpanded: true),
        ],
      ),
    );
  }
}
