import 'dart:ui';

import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/features/auth/blocs/auth/auth_cubit.dart';
import 'package:dentist_booking_app/features/booking/widgets/cancel_booking_sheet.dart';
import 'package:dentist_booking_app/features/queue/blocs/queue/queue_cubit.dart';
import 'package:dentist_booking_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/enum/enum.dart';
import '../../../core/model/booking_status_model.dart';
import '../../../core/model/tracking_model.dart';
import '../../../core/util/queue_turn_display.dart';
import '../blocs/booking_status/booking_status_cubit.dart';
import 'active_bookings_list.dart';
import 'booking_status_panel_states.dart';

class BookingStatusPanel extends StatelessWidget {
  const BookingStatusPanel({
    super.key,
    required this.onBookTap,
  });

  final VoidCallback onBookTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QueueCubit, QueueState>(
        builder: (context, queueState) {
          // التحقق من وجود حجوزات فعالة
          final activeQueues = queueState.maybeWhen(
            activeQueueLoaded: (queues) => queues as List<dynamic>,
            orElse: () => <dynamic>[],
          );

          if (activeQueues.isNotEmpty) {
            return _ActiveBookingPanel(
              queues: activeQueues.cast(),
              onBookTap: onBookTap,
            );
          }

        // إذا لم يكن هناك حجز فعال، عرض حالة الحجز العادية
        return BlocBuilder<BookingStatusCubit, BookingStatusState>(
          builder: (context, state) {
            return state.when(
              initial: () => BookingStatusLoadingPanel(),
              loading: () => BookingStatusLoadingPanel(),
              loaded: (status) => _BookingStatusPanelLayout(
                status: status,
                onBookTap: onBookTap,
              ),
              error: (error) => BookingStatusErrorPanel(
                message: error,
                onRetry: () => context.read<BookingStatusCubit>().loadStatus(),
              ),
            );
          },
        );
      },
    );
  }
}

class _BookingStatusPanelLayout extends StatelessWidget {
  const _BookingStatusPanelLayout({
    required this.status,
    required this.onBookTap,
  });

  final BookingStatusModel status;
  final VoidCallback onBookTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final locale = context.locale;

    final bool isBookingEnabled = status.isBookingEnabled ?? false;
    final bool hasBookableShift = status.hasAnyBookableShift;
    final bool canBook = isBookingEnabled && hasBookableShift;
    final String? stopReason = status.stopReason?.trim();

    final BookingShift? shift = status.shift;
    final bool isMorningShift = shift == BookingShift.morning;
    final bool morningFull = status.isShiftFull(BookingShift.morning);
    final bool eveningFull = status.isShiftFull(BookingShift.evening);

    final statusColor = canBook
        ? colorScheme.primary
        : colorScheme.error;
    final String statusText;
    if (!isBookingEnabled) {
      statusText = LocaleKeys.booking_status_stopped.trnsltd;
    } else if (!hasBookableShift) {
      statusText = LocaleKeys.booking_status_closed.trnsltd;
    } else {
      statusText = LocaleKeys.booking_status_open.trnsltd;
    }

    final shiftText = shift == null
        ? LocaleKeys.booking_closed_now.trnsltd
        : (isMorningShift
              ? LocaleKeys.booking_morning.trnsltd
              : LocaleKeys.booking_evening.trnsltd);

    final String? capacityNotice;
    if (canBook && morningFull && !eveningFull) {
      capacityNotice = LocaleKeys.morning_full.trnsltd;
    } else if (canBook && eveningFull && !morningFull) {
      capacityNotice = LocaleKeys.evening_full.trnsltd;
    } else {
      capacityNotice = null;
    }

    final String stoppedSubtitle;
    if (!isBookingEnabled) {
      stoppedSubtitle = (stopReason != null && stopReason.isNotEmpty)
          ? stopReason
          : LocaleKeys.booking_disabled.trnsltd;
    } else if (status.shiftClosed == BookingShift.morning &&
        !status.isShiftAvailable(BookingShift.evening)) {
      stoppedSubtitle = LocaleKeys.morning_shift_closed_today.trnsltd;
    } else if (status.shiftClosed == BookingShift.evening &&
        !status.isShiftAvailable(BookingShift.morning)) {
      stoppedSubtitle = LocaleKeys.evening_shift_closed_today.trnsltd;
    } else if (morningFull && eveningFull) {
      stoppedSubtitle = LocaleKeys.evening_full.trnsltd;
    } else if (morningFull && !hasBookableShift) {
      stoppedSubtitle = LocaleKeys.morning_full.trnsltd;
    } else if (eveningFull && !hasBookableShift) {
      stoppedSubtitle = LocaleKeys.evening_full.trnsltd;
    } else {
      stoppedSubtitle = LocaleKeys.booking_closed_now.trnsltd;
    }

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 20 * (1 - value)),
        child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.10),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: colorScheme.primary.withOpacity(.12)),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(.20),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: statusText,
                                style: textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                              if (canBook) ...[
                                TextSpan(
                                  text: '  ·  ',
                                  style: textTheme.bodySmall!.copyWith(
                                    color: colorScheme.onSurface
                                        .withOpacity(.45),
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Icon(
                                    HugeIcons.strokeRoundedDentalCare,
                                    size: 16,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                TextSpan(
                                  text: ' $shiftText',
                                  style: textTheme.bodySmall!.copyWith(
                                    color: colorScheme.onSurface
                                        .withOpacity(.8),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _BookingPanelRefreshButton(
                        onRefresh: () => context
                            .read<BookingStatusCubit>()
                            .loadStatus(showLoading: false),
                      ),
                    ],
                  ),
                  if (!canBook) ...[
                    const SizedBox(height: 10),
                    Text(
                      stoppedSubtitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall!.copyWith(
                        color: colorScheme.onSurface.withOpacity(.7),
                      ),
                    ),
                  ] else if (capacityNotice != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      capacityNotice,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall!.copyWith(
                        color: colorScheme.onSurface.withOpacity(.7),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: canBook ? () => onBookTap() : null,
                      icon: Icon(
                        locale.languageCode == 'ar'
                            ? HugeIcons.strokeRoundedArrowLeft01
                            : HugeIcons.strokeRoundedArrowRight01,
                        size: 20,
                      ),
                      label: Text(
                        LocaleKeys.book_now.trnsltd,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BookingPanelRefreshButton extends StatefulWidget {
  const _BookingPanelRefreshButton({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  State<_BookingPanelRefreshButton> createState() =>
      _BookingPanelRefreshButtonState();
}

class _BookingPanelRefreshButtonState extends State<_BookingPanelRefreshButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinController;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_refreshing) return;
    setState(() => _refreshing = true);
    _spinController.repeat();
    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        _spinController.stop();
        _spinController.reset();
        setState(() => _refreshing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tooltip =
        MaterialLocalizations.of(context).refreshIndicatorSemanticLabel;

    return IconButton(
      onPressed: _refreshing ? null : _handleTap,
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: RotationTransition(
          turns: _spinController,
          child: Icon(
            Icons.refresh_rounded,
            color: colorScheme.onPrimary,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _ActiveBookingPanel extends StatelessWidget {
  const _ActiveBookingPanel({
    required this.queues,
    required this.onBookTap,
  });

  final List<dynamic> queues;
  final VoidCallback onBookTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final typedQueues = queues.cast<TrackingModel>();
    final hasActive = typedQueues.any(
      (q) =>
          q.booking.bookingStatus == BookingStatus.pending ||
          q.booking.bookingStatus == BookingStatus.confirmed,
    );
    final panelTitle = hasActive
        ? LocaleKeys.you_have_active_booking.trnsltd
        : LocaleKeys.you_already_called.trnsltd;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 20 * (1 - value)),
        child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.10),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: colorScheme.primary.withOpacity(.12)),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(.20),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: hasActive
                              ? colorScheme.primary
                              : colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          panelTitle,
                          style: textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: hasActive
                                ? colorScheme.primary
                                : colorScheme.secondary,
                          ),
                        ),
                      ),
                      _BookingPanelRefreshButton(
                        onRefresh: () => context
                            .read<QueueCubit>()
                            .loadActiveBookingQueue(force: true),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (typedQueues.length == 1)
                    // إذا كان حجز واحد فقط، عرضه مباشرة
                    _buildSingleBooking(context, typedQueues[0])
                  else
                    // إذا كان أكثر من حجز، عرض القائمة القابلة للتوسع
                    ActiveBookingsList(
                      queues: typedQueues,
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => onBookTap(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        LocaleKeys.book_new_appointment.trnsltd,
                        style: textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSingleBooking(BuildContext context, TrackingModel queue) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final turnKind = QueueTurnDisplay.resolve(
      stats: queue.queueStats,
      patientQueueNumber: queue.booking.queueNumber,
      bookingStatus: queue.booking.bookingStatus,
    );
    final isHighlight = QueueTurnDisplay.isHighlightTurn(turnKind);
    final isCalled = turnKind == QueueTurnKind.passed;
    final canCancel = queue.booking.bookingStatus == BookingStatus.pending ||
        queue.booking.bookingStatus == BookingStatus.confirmed;

    return Column(
      children: [
        // عرض اسم الشخص المحجوز
        Builder(
          builder: (context) {
            String displayName;
            // إذا كان الحجز لشخص آخر، عرض اسمه
            if (queue.booking.patientName != null &&
                queue.booking.patientName!.isNotEmpty) {
              displayName = queue.booking.patientName!;
            } else {
              // إذا كان الحجز للمستخدم نفسه، عرض اسم المستخدم الحالي
              displayName = context
                  .read<AuthCubit>()
                  .state
                  .mapOrNull(
                    status: (value) =>
                        value.data['raw_user_meta_data']['full_name'] as String?,
                  ) ??
                  LocaleKeys.user_default_name.trnsltd;
            }
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: (isCalled ? colorScheme.secondary : colorScheme.primary)
                    .withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCalled ? Icons.check_circle_rounded : Icons.person_rounded,
                    size: 16,
                    color: isCalled
                        ? colorScheme.secondary
                        : colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    displayName,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCalled
                          ? colorScheme.secondary
                          : colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
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
              icon: isCalled
                  ? Icons.check_circle_rounded
                  : Icons.people_rounded,
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
        if (canCancel && queue.booking.id != null) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                showCancelBookingReasonSheet(
                  context,
                  bookingId: queue.booking.id!,
                  onSuccess: () =>
                      context.read<QueueCubit>().loadActiveBookingQueue(),
                );
              },
              icon: const Icon(Icons.cancel_outlined, size: 20),
              label: Text(LocaleKeys.booking_cancel_action.trnsltd),
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
