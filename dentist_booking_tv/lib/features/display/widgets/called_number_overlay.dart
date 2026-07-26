import 'package:dentist_booking_tv/core/app_setup.dart';
import 'package:dentist_booking_tv/core/config/env_config.dart';
import 'package:dentist_booking_tv/core/constants/tv_display_strings.dart';
import 'package:dentist_booking_tv/core/services/queue_announcement_service.dart';
import 'package:dentist_booking_tv/core/utils/tv_scale.dart';
import 'package:flutter/material.dart';

/// Full-screen overlay when a new queue number is called.
/// Sequence: pop in → attention chime → TTS once (optional) → short hold → shrink out → onDismiss.
class CalledNumberOverlay extends StatefulWidget {
  const CalledNumberOverlay({
    super.key,
    required this.queueNumber,
    required this.onDismiss,
    this.doctorDisplayName,
  });

  final int queueNumber;
  final VoidCallback onDismiss;
  /// Optional; if null, [EnvConfig.clinicDoctorName] is used when non-empty.
  final String? doctorDisplayName;

  @override
  State<CalledNumberOverlay> createState() => _CalledNumberOverlayState();
}

class _CalledNumberOverlayState extends State<CalledNumberOverlay>
    with TickerProviderStateMixin {
  static const Duration _popDuration = Duration(milliseconds: 500);
  static const Duration _shrinkDuration = Duration(milliseconds: 400);

  late AnimationController _enterController;
  late AnimationController _exitController;
  late Animation<double> _enterScale;
  late Animation<double> _enterOpacity;
  late Animation<double> _exitScale;
  late Animation<double> _exitOpacity;

  @override
  void initState() {
    super.initState();
    _enterController = AnimationController(
      vsync: this,
      duration: _popDuration,
    );
    _exitController = AnimationController(
      vsync: this,
      duration: _shrinkDuration,
    );

    _enterScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: Curves.easeOutBack,
      ),
    );
    _enterOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: Curves.easeOut,
      ),
    );
    _exitScale = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: Curves.easeIn,
      ),
    );
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: Curves.easeIn,
      ),
    );

    _exitController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onDismiss();
      }
    });

    _runDismissSequence();
  }

  Future<void> _runDismissSequence() async {
    await _enterController.forward();
    if (!mounted) return;

    final announcement = getIt<QueueAnnouncementService>();
    await announcement.playAttentionChime();
    if (!mounted) return;

    if (EnvConfig.tvAnnouncementEnabled) {
      await announcement.speakTurnOnce(widget.queueNumber);
    }
    if (!mounted) return;

    await Future.delayed(
      EnvConfig.tvAnnouncementEnabled
          ? EnvConfig.tvOverlayHoldAfterSpeech
          : EnvConfig.tvOverlayHoldWhenSilent,
    );
    if (!mounted) return;

    await _exitController.forward();
  }

  @override
  void dispose() {
    getIt<QueueAnnouncementService>().stop();
    _enterController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  String get _doctorName =>
      widget.doctorDisplayName?.trim().isNotEmpty == true
          ? widget.doctorDisplayName!
          : EnvConfig.clinicDoctorName.trim().isNotEmpty
              ? EnvConfig.clinicDoctorName
              : '';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const primaryColor = Color(0xFF1392EC);

    return AnimatedBuilder(
      animation: Listenable.merge([_enterController, _exitController]),
      builder: (context, child) {
        final isExiting = _exitController.isAnimating || _exitController.isCompleted;
        final scale = isExiting ? _exitScale.value : _enterScale.value;
        final opacity = isExiting ? _exitOpacity.value : _enterOpacity.value;
                return IgnorePointer(
          child: Container(
            color: Colors.black.withOpacity(0.4 * opacity),
            alignment: Alignment.center,
            child: Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: context.s(48)),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.s(48),
                      vertical: context.s(40),
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(context.s(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.campaign,
                                color: Colors.white.withOpacity(0.95),
                                size: context.s(36),
                              ),
                              SizedBox(width: context.s(12)),
                              Text(
                                'رقم:',
                                style: textTheme.titleLarge?.copyWith(
                                  color: Colors.white.withOpacity(0.95),
                                  fontWeight: FontWeight.bold,
                                  fontSize: context.s(28),
                                ),
                              ),
                              SizedBox(width: context.s(16)),
                              Text(
                                widget.queueNumber.toString().padLeft(4, '0'),
                                style: textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: context.s(120),
                                  color: Colors.white,
                                  letterSpacing: -2,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: context.s(24)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.s(24),
                            vertical: context.s(12),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            TvDisplayStrings.directionToDoctor,
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: context.s(22),
                            ),
                          ),
                        ),
                        if (_doctorName.isNotEmpty) ...[
                          SizedBox(height: context.s(16)),
                          Text(
                            _doctorName,
                            style: textTheme.titleLarge?.copyWith(
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.bold,
                              fontSize: context.s(26),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
