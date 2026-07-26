import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class _StatusVisual {
  const _StatusVisual({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;
}

class QueueCardView extends StatelessWidget {
  final String patientName;
  final String ticketCode;
  final String queueNumber;
  final int? waitingCount;
  final bool isNotStarted;
  final bool canStartQueue;
  final String stoppedLabel;
  final String statusCode;
  final VoidCallback? onStart;
  final VoidCallback? onNext;
  final VoidCallback? onToggle;
  final VoidCallback? onResume;
  final VoidCallback? onRestart;
  final VoidCallback? onRefresh;
  final bool isPaused;

  const QueueCardView({
    super.key,
    required this.patientName,
    required this.ticketCode,
    required this.queueNumber,
    required this.onRestart,
    required this.isPaused,
    this.waitingCount,
    this.isNotStarted = false,
    this.canStartQueue = false,
    this.stoppedLabel = '',
    this.statusCode = '',
    this.onStart,
    this.onNext,
    this.onToggle,
    this.onResume,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.primary.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(.07),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 18,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(.20),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    queueNumber,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        ticketCode,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.outline,
                        ),
                      ),
                      if (waitingCount != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${LocaleKeys.waiting.trnsltd}: $waitingCount',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.65),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  _StatusVisual _statusVisual(ColorScheme colorScheme) {
    switch (statusCode) {
      case 'OUT_OF_WORKING_HOURS':
        return _StatusVisual(
          icon: Icons.schedule_rounded,
          color: colorScheme.tertiary,
        );
      case 'CLINIC_CLOSED':
      case 'CLOSED':
        return _StatusVisual(
          icon: Icons.lock_outline_rounded,
          color: colorScheme.error,
        );
      case 'BEFORE_SHIFT_START':
        return _StatusVisual(
          icon: Icons.hourglass_top_rounded,
          color: colorScheme.tertiary,
        );
      case 'SHIFT_FINISHED':
        return _StatusVisual(
          icon: Icons.event_busy_rounded,
          color: colorScheme.outline,
        );
      case 'BOOKING_DISABLED':
        return _StatusVisual(
          icon: Icons.block_rounded,
          color: colorScheme.error,
        );
      case 'NO_MORE_BOOKINGS':
      case 'NO_MORE_BOOKINGS_MORNING':
      case 'NO_MORE_BOOKINGS_EVENING':
        return _StatusVisual(
          icon: Icons.inbox_outlined,
          color: colorScheme.secondary,
        );
      default:
        return _StatusVisual(
          icon: Icons.event_busy_rounded,
          color: colorScheme.secondary,
        );
    }
  }

  Widget _refreshButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: LocaleKeys.refresh_queue_status.trnsltd,
      child: IconButton.outlined(
        style: IconButton.styleFrom(
          backgroundColor: colorScheme.secondary.withOpacity(.15),
          foregroundColor: colorScheme.secondary,
          side: BorderSide(color: colorScheme.secondary),
        ),
        onPressed: onRefresh,
        icon: const Icon(HugeIcons.strokeRoundedReload),
      ),
    );
  }

  Widget _buildNotStartedButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (canStartQueue) {
      return ElevatedButton.icon(
        icon: const Icon(Icons.play_arrow),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 50),
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        label: Text(
          LocaleKeys.start_queue_button.trnsltd,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onPressed: onStart,
      );
    }

    final visual = _statusVisual(colorScheme);
    final label = stoppedLabel.isNotEmpty
        ? stoppedLabel
        : LocaleKeys.no_bookings_currently.trnsltd;

    return ElevatedButton.icon(
      icon: Icon(visual.icon),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 50),
        elevation: 0,
        backgroundColor: visual.color.withOpacity(0.12),
        foregroundColor: visual.color,
        disabledBackgroundColor: visual.color.withOpacity(0.12),
        disabledForegroundColor: visual.color,
        side: BorderSide(color: visual.color.withOpacity(0.45)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      ),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onPressed: null,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isPaused) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 50),
                elevation: 0,
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              label: Text(
                LocaleKeys.resume_queue_button.trnsltd,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: onResume,
            ),
          ),
          const SizedBox(width: 8),
          _refreshButton(context),
        ],
      );
    }

    if (isNotStarted) {
      return Row(
        children: [
          Expanded(child: _buildNotStartedButton(context)),
          const SizedBox(width: 8),
          _refreshButton(context),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 50),
              elevation: 0,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            label: Text(
              LocaleKeys.next.trnsltd,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: onNext,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton.outlined(
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.error.withOpacity(.15),
                foregroundColor: colorScheme.error,
                side: BorderSide(color: colorScheme.error),
              ),
              onPressed: () => onToggle?.call(),
              icon: Icon(
                isPaused
                    ? HugeIcons.strokeRoundedPlayCircle
                    : HugeIcons.strokeRoundedPauseCircle,
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: LocaleKeys.restart_button.trnsltd,
              child: IconButton.outlined(
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.primary.withOpacity(.15),
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary),
                ),
                onPressed: () => onRestart?.call(),
                icon: const Icon(HugeIcons.strokeRoundedRefresh),
              ),
            ),
            const Spacer(),
            _refreshButton(context),
          ],
        ),
      ],
    );
  }
}
