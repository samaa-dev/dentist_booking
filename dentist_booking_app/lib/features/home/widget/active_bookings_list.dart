import 'dart:ui';

import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/features/auth/blocs/auth/auth_cubit.dart';
import 'package:dentist_booking_app/features/booking/widgets/cancel_booking_sheet.dart';
import 'package:dentist_booking_app/features/queue/blocs/queue/queue_cubit.dart';
import 'package:dentist_booking_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/model/tracking_model.dart';
import '../../../core/util/queue_turn_display.dart';

class ActiveBookingsList extends StatefulWidget {
  const ActiveBookingsList({
    super.key,
    required this.queues,
  });

  final List<TrackingModel> queues;

  @override
  State<ActiveBookingsList> createState() => _ActiveBookingsListState();
}

class _ActiveBookingsListState extends State<ActiveBookingsList> {
  final Set<int> _expandedIndices = {};

  void _toggleExpansion(int index) {
    setState(() {
      if (_expandedIndices.contains(index)) {
        _expandedIndices.remove(index);
      } else {
        _expandedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.queues.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final queue = widget.queues[index];
            final isExpanded = _expandedIndices.contains(index);
            final turnKind = QueueTurnDisplay.resolve(
              stats: queue.queueStats,
              patientQueueNumber: queue.booking.queueNumber,
            );
            final isHighlight = QueueTurnDisplay.isHighlightTurn(turnKind);

            return TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) => Transform.scale(
                scale: 0.95 + (value * 0.05),
                child: Opacity(opacity: value, child: child),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(.15),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(.10),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => _toggleExpansion(index),
                        borderRadius: BorderRadius.circular(18),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.confirmation_number_rounded,
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        // إذا كان الحجز لشخص آخر، عرض اسمه
                                        if (queue.booking.patientName != null &&
                                            queue.booking.patientName!.isNotEmpty) {
                                          return Text(
                                            queue.booking.patientName!,
                                            style: textTheme.bodyMedium?.copyWith(
                                              color: colorScheme.onSurface,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }
                                        // إذا كان الحجز للمستخدم نفسه، عرض اسم المستخدم الحالي
                                        final fullName = context
                                            .read<AuthCubit>()
                                            .state
                                            .mapOrNull(
                                              status: (value) => value.data[
                                                      'raw_user_meta_data']
                                                  ['full_name'] as String?,
                                            ) ??
                                            LocaleKeys.user_default_name.trnsltd;
                                        return Text(
                                          fullName,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 4),
                                    if (queue.booking.queueNumber != null)
                                      Row(
                                        children: [
                                          Text(
                                            '${LocaleKeys.queue_number.trnsltd}: ',
                                            style: textTheme.bodySmall?.copyWith(
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                          Text(
                                            queue.booking.queueNumber!.padLeft(4, '0'),
                                            style: textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isExpanded)
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 250),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, value, child) => Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 10 * (1 - value)),
                              child: child,
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              children: [
                                const Divider(height: 20),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final stackVertically =
                                        constraints.maxWidth < 340;
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
                                      color: isHighlight
                                          ? Colors.green
                                          : colorScheme.secondary,
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
                                if (queue.booking.id != null) ...[
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        showCancelBookingReasonSheet(
                                          context,
                                          bookingId: queue.booking.id!,
                                          onSuccess: () => context
                                              .read<QueueCubit>()
                                              .loadActiveBookingQueue(),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.cancel_outlined,
                                        size: 20,
                                      ),
                                      label: Text(
                                        LocaleKeys.booking_cancel_action.trnsltd,
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: colorScheme.error,
                                        side: BorderSide(
                                          color: colorScheme.error.withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
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
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleSmall?.copyWith(
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
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

}
