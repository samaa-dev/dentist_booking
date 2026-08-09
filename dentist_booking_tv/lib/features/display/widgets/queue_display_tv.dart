import 'package:dentist_booking_tv/core/config/env_config.dart';
import 'package:dentist_booking_tv/core/constants/tv_display_strings.dart';
import 'package:dentist_booking_tv/core/model/queue_status_model.dart';
import 'package:dentist_booking_tv/core/utils/tv_scale.dart';
import 'package:flutter/material.dart';

class QueueDisplayTv extends StatelessWidget {
  const QueueDisplayTv({super.key, required this.queueStatus});

  final QueueStatusModel queueStatus;

  static const _greyCardColor = Color(0xFFF1F5F9);
  static const _greyBorderColor = Color(0xFFE2E8F0);
  static const _greyLabelColor = Color(0xFF64748B);
  static const _greenAccent = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final current = queueStatus.currentQueueNumber ?? 0;
    final nextQueueNumber = queueStatus.nextBooking?.queueNumber ?? '—';

    // Show cards for NORMAL state, or NO_MORE_BOOKINGS when a current number exists.
    // All other states (CLOSED, PAUSED, OUT_OF_WORKING_HOURS) show a message.
    final showCards = queueStatus.state == 'NORMAL' ||
        (queueStatus.state.startsWith('NO_MORE_BOOKINGS') && current > 0);

    if (!showCards) {
      return _buildMessageSection(
        context,
        message: queueStatus.message ?? _stateMessage(queueStatus.state),
        colorScheme: colorScheme,
      );
    }

    final gap = context.s(16);

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _CurrentCard(
            currentNumber: current,
            isNotStarted: queueStatus.isQueueNotStarted,
            primaryColor: colorScheme.primary,
            textTheme: textTheme,
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          flex: 1,
          child: _NextCard(
            nextNumber: nextQueueNumber,
            greyCardColor: _greyCardColor,
            greyBorderColor: _greyBorderColor,
            greyLabelColor: _greyLabelColor,
            textTheme: textTheme,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageSection(
    BuildContext context, {
    required String message,
    required ColorScheme colorScheme,
  }) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: context.s(24)),
        padding: EdgeInsets.symmetric(
          horizontal: context.s(32),
          vertical: context.s(24),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.s(24)),
          color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: context.s(22),
            color: colorScheme.onSurface.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _stateMessage(String state) {
    switch (state) {
      case 'CLOSED':
        return 'العيادة مغلقة اليوم';
      case 'PAUSED':
        return 'الطابور متوقف مؤقتاً';
      case 'OUT_OF_WORKING_HOURS':
        return 'خارج أوقات العمل';
      case 'NO_MORE_BOOKINGS_MORNING':
        return 'لا مزيد من الحجوزات — الفترة الصباحية';
      case 'NO_MORE_BOOKINGS_EVENING':
        return 'لا مزيد من الحجوزات — الفترة المسائية';
      default:
        return 'لا توجد بيانات طابور';
    }
  }
}

class _CurrentCard extends StatelessWidget {
  const _CurrentCard({
    required this.currentNumber,
    required this.isNotStarted,
    required this.primaryColor,
    required this.textTheme,
  });

  final int currentNumber;
  final bool isNotStarted;
  final Color primaryColor;
  final TextTheme textTheme;

  static const _notStartedMessage = 'الطابور لم يبدأ';

  @override
  Widget build(BuildContext context) {
    final doctorName = EnvConfig.clinicDoctorName.trim();

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: context.s(20),
        horizontal: context.s(24),
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(context.s(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: context.s(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(context.s(12)),
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.campaign,
                          color: Colors.white.withOpacity(0.9),
                          size: context.s(26),
                        ),
                        SizedBox(width: context.s(8)),
                        Flexible(
                          child: Text(
                            'الرقم الحالي',
                            style: textTheme.titleLarge?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.bold,
                              fontSize: context.s(22),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (!isNotStarted) ...[
                      SizedBox(height: context.s(12)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.s(16),
                          vertical: context.s(6),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          TvDisplayStrings.directionToDoctor,
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: context.s(18),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (doctorName.isNotEmpty) ...[
                        SizedBox(height: context.s(8)),
                        Text(
                          doctorName,
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.bold,
                            fontSize: context.s(18),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              SizedBox(width: context.s(16)),
              Expanded(
                flex: 3,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      isNotStarted
                          ? _notStartedMessage
                          : currentNumber.toString().padLeft(4, '0'),
                      textAlign: TextAlign.center,
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: isNotStarted
                            ? context.s(44)
                            : context.s(104),
                        color: Colors.white,
                        letterSpacing: isNotStarted ? 0 : -2,
                        height: 1,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextCard extends StatelessWidget {
  const _NextCard({
    required this.nextNumber,
    required this.greyCardColor,
    required this.greyBorderColor,
    required this.greyLabelColor,
    required this.textTheme,
  });

  final String nextNumber;
  final Color greyCardColor;
  final Color greyBorderColor;
  final Color greyLabelColor;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: context.s(16),
        horizontal: context.s(16),
      ),
      decoration: BoxDecoration(
        color: greyCardColor,
        borderRadius: BorderRadius.circular(context.s(12)),
        border: Border.all(color: greyBorderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التالي',
                  style: textTheme.titleMedium?.copyWith(
                    color: greyLabelColor,
                    fontWeight: FontWeight.bold,
                    fontSize: context.s(20),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.s(8)),
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: context.s(18),
                      color: QueueDisplayTv._greenAccent,
                    ),
                    SizedBox(width: context.s(4)),
                    Text(
                      '+1',
                      style: textTheme.bodyMedium?.copyWith(
                        color: QueueDisplayTv._greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: context.s(14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: context.s(8)),
          Expanded(
            flex: 3,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  nextNumber,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: context.s(72),
                    color: const Color(0xFF1E293B),
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
