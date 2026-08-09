import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

import '../../../core/model/tracking_model.dart';
import '../../../core/util/queue_turn_display.dart';

class ActiveQueueCard extends StatelessWidget {
  const ActiveQueueCard({
    super.key,
    required this.queue,
  });

  final TrackingModel queue;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final turnKind = QueueTurnDisplay.resolve(
      stats: queue.queueStats,
      patientQueueNumber: queue.booking.queueNumber,
      bookingStatus: queue.booking.bookingStatus,
    );
    final isHighlight = QueueTurnDisplay.isHighlightTurn(turnKind);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOut,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, (1 - value) * 20),
        child: Opacity(opacity: value, child: child),
      ),
      child: _card(
        context,
        margin: const EdgeInsets.only(left: 18, right: 18, top: 18),
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final stackVertically = constraints.maxWidth < 340;
                final currentBlock = _statBlock(
                  context,
                  icon: Icons.play_arrow_rounded,
                  value: QueueTurnDisplay.currentQueueValue(
                    queue.queueStats,
                    shift: queue.booking.shift,
                  ),
                  label: LocaleKeys.current_number.trnsltd,
                  color: colorScheme.primary,
                );
                final beforeBlock = _statBlock(
                  context,
                  icon: Icons.people_rounded,
                  value: QueueTurnDisplay.beforeYouValue(
                    kind: turnKind,
                    stats: queue.queueStats,
                  ),
                  label: QueueTurnDisplay.beforeYouLabel(
                    kind: turnKind,
                    stats: queue.queueStats,
                  ),
                  color: isHighlight ? Colors.green : colorScheme.secondary,
                );

                if (stackVertically) {
                  return Column(
                    children: [
                      currentBlock,
                      const SizedBox(height: 16),
                      beforeBlock,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: currentBlock),
                    Expanded(child: beforeBlock),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context, {
    required Widget child,
    required EdgeInsets margin,
    required EdgeInsets padding,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.surface,
            colorScheme.surface.withOpacity(0.96),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _statBlock(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
