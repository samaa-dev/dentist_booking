import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/core/util/info_snackbar.dart';
import 'package:dentist_booking_admin_app/features/queue/blocs/queue/queue_cubit.dart';
import 'package:dentist_booking_admin_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'queue_card_view.dart';
import 'queue_change_status_sheet.dart';

class QueueCardPro extends StatelessWidget {
  const QueueCardPro({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<QueueCubit, QueueState>(
      listenWhen: (p, c) {
        return c.maybeWhen(
          orElse: () => false,
          error: (_) => true,
          errorUpdateBooking: (_) => true,
          statusLoaded: (_) => true,
        );
      },
      buildWhen: (p, c) {
        return c.maybeWhen(
          statusLoaded: (_) => true,
          processing: () => true,
          error: (_) => true,
          orElse: () => false,
        );
      },
      listener: (context, state) {
        state.maybeWhen(
          error: (msg) {
            final message = _mapReasonToMessage(msg);
            if (message.isNotEmpty) {
              SnackbarMes.showToastMsg(context, message: message);
            }
          },
          errorUpdateBooking: (msg) {
            if (msg.isNotEmpty) {
              SnackbarMes.showToastMsg(context, message: msg);
            }
          },
          statusLoaded: (status) {
            final isEmptyQueue = (status.currentQueueNumber ?? 0) == 0;
            if (isEmptyQueue && _isNoMoreBookingsState(status.state)) {
              return;
            }
            // Last patient still visible: NO_MORE is informational, not an error toast.
            if (_isNoMoreBookingsState(status.state) &&
                (status.currentQueueNumber ?? 0) > 0) {
              return;
            }
            if (status.state != 'NORMAL') {
              SnackbarMes.showToastMsg(
                context,
                message: _mapReasonToMessage(status.state),
              );
            }
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final child = state.maybeWhen(
          processing: () => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.3, end: 1),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    builder: (context, value, _) {
                      return Opacity(
                        opacity: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ),
          statusLoaded: (status) {
            final isNotStarted = (status.currentQueueNumber ?? 0) == 0;
            final isPaused = status.state == 'PAUSED';
            final isNoMore = _isNoMoreBookingsState(status.state);
            final hasCurrent =
                status.currentBooking != null && !isNotStarted;
            // NO_MORE with a current patient still allows completing them via Next.
            final blockNext = isPaused ||
                (status.state != 'NORMAL' && !(isNoMore && hasCurrent));
            final canPauseResume = status.state == 'NORMAL' || isPaused;
            final canStartQueue =
                isNotStarted && status.state == 'NORMAL';
            final stoppedLabel = (isNotStarted && !canStartQueue)
                ? _stoppedLabel(status.state)
                : '';
            return QueueCardView(
              key: ValueKey(
                'status_${status.currentQueueNumber}_${status.currentBooking?.queueNumber ?? 0}',
              ),
              patientName: status.currentBooking?.patientName ?? '_',
              ticketCode: status.currentBooking?.ticketCode ?? '_',
              queueNumber: isNotStarted
                  ? '----'
                  : (status.currentBooking?.queueNumber ?? 0)
                      .toString()
                      .padLeft(4, '0'),
              waitingCount: status.waitingCount,
              isNotStarted: isNotStarted,
              canStartQueue: canStartQueue,
              stoppedLabel: stoppedLabel,
              statusCode: status.state,
              onStart: canStartQueue
                  ? () => context.read<QueueCubit>().startQueue()
                  : null,
              onNext: isNotStarted || blockNext
                  ? null
                  : () {
                      final booking = status.currentBooking;
                      if (booking == null) return;
                      QueueChangeStatusSheet.show(
                        context,
                        booking: booking,
                        onConfirm: (update) async {
                          Navigator.of(context).pop();
                          await context
                              .read<QueueCubit>()
                              .updateBookingStatus(update);
                        },
                      );
                    },
              onToggle: isNotStarted || !canPauseResume
                  ? null
                  : () => context.read<QueueCubit>().togglePauseResume(
                        status.shift ?? 'morning',
                        isPaused,
                      ),
              onResume: isPaused
                  ? () => context.read<QueueCubit>().togglePauseResume(
                        status.shift ?? 'morning',
                        true,
                      )
                  : null,
              onRestart: () => _showRestartConfirmation(
                context,
                status.shift ?? 'morning',
              ),
              onRefresh: () => context.read<QueueCubit>().loadStatus(),
              isPaused: isPaused,
            );
          },
          error: (msg) {
            final isNoMore = QueueCubit.isNoMoreBookingsCode(msg);
            return QueueCardView(
              key: ValueKey('error_$msg'),
              patientName: '_',
              ticketCode: '_',
              queueNumber: '----',
              isNotStarted: isNoMore,
              canStartQueue: false,
              stoppedLabel: isNoMore ? _stoppedLabel(msg) : '',
              statusCode: msg,
              onStart: null,
              onNext: null,
              isPaused: false,
              onToggle: null,
              onRestart: () => _showRestartConfirmation(context, 'morning'),
              onRefresh: () => context.read<QueueCubit>().loadStatus(),
            );
          },
          orElse: () => QueueCardView(
            key: const ValueKey('initial'),
            patientName: '_',
            ticketCode: '_',
            queueNumber: '----',
            isNotStarted: false,
            canStartQueue: false,
            stoppedLabel: '',
            statusCode: '',
            onStart: null,
            isPaused: false,
            onNext: null,
            onToggle: null,
            onRestart: () => _showRestartConfirmation(context, 'morning'),
            onRefresh: () => context.read<QueueCubit>().loadStatus(),
          ),
        );

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
          child: child,
        );
      },
    );
  }

  bool _isNoMoreBookingsState(String state) {
    return state == 'NO_MORE_BOOKINGS' ||
        state == 'NO_MORE_BOOKINGS_MORNING' ||
        state == 'NO_MORE_BOOKINGS_EVENING';
  }

  String _stoppedLabel(String state) {
    switch (state) {
      case 'OUT_OF_WORKING_HOURS':
        return LocaleKeys.out_of_working_hours.trnsltd;
      case 'CLINIC_CLOSED':
      case 'CLOSED':
        return LocaleKeys.clinic_closed.trnsltd;
      case 'BEFORE_SHIFT_START':
        return LocaleKeys.before_shift_start.trnsltd;
      case 'SHIFT_FINISHED':
        return LocaleKeys.shift_finished.trnsltd;
      case 'BOOKING_DISABLED':
        return LocaleKeys.booking_disabled.trnsltd;
      case 'NO_MORE_BOOKINGS':
        return LocaleKeys.no_more_bookings.trnsltd;
      case 'NO_MORE_BOOKINGS_MORNING':
        return LocaleKeys.no_more_bookings_morning.trnsltd;
      case 'NO_MORE_BOOKINGS_EVENING':
        return LocaleKeys.no_more_bookings_evening.trnsltd;
      default:
        return LocaleKeys.no_bookings_currently.trnsltd;
    }
  }

  String _mapReasonToMessage(String reason) {
    switch (reason) {
      case 'NEXT_OK':
        return '';
      case 'CLINIC_CLOSED':
      case 'CLOSED':
        return LocaleKeys.clinic_closed.trnsltd;
      case 'OUT_OF_WORKING_HOURS':
        return LocaleKeys.out_of_working_hours.trnsltd;
      case 'BOOKING_DISABLED':
        return LocaleKeys.booking_disabled.trnsltd;
      case 'BEFORE_SHIFT_START':
        return LocaleKeys.before_shift_start.trnsltd;
      case 'SHIFT_FINISHED':
        return LocaleKeys.shift_finished.trnsltd;
      case 'QUEUE_PAUSED':
      case 'PAUSED':
        return LocaleKeys.queue_paused.trnsltd;
      case 'NO_MORE_BOOKINGS':
        return LocaleKeys.no_more_bookings.trnsltd;
      case 'NO_MORE_BOOKINGS_MORNING':
        return LocaleKeys.no_more_bookings_morning.trnsltd;
      case 'NO_MORE_BOOKINGS_EVENING':
        return LocaleKeys.no_more_bookings_evening.trnsltd;
      default:
        return LocaleKeys.unknown_next_queue_error.trnsltd;
    }
  }

  void _showRestartConfirmation(BuildContext context, String shift) {
    SnackbarMes.showCustomDialog(
      context,
      title: LocaleKeys.restart_queue_title.trnsltd,
      content: LocaleKeys.restart_queue_confirmation.trnsltd,
      buttonCancelText: LocaleKeys.cancel_button.trnsltd,
      buttonConfirmText: LocaleKeys.restart_button.trnsltd,
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () {
        Navigator.of(context).pop();
        context.read<QueueCubit>().restartQueue(shift);
      },
    );
  }
}
