import 'package:dentist_booking_admin_app/core/enum/enum.dart';
import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/core/model/booking_model.dart';
import 'package:dentist_booking_admin_app/core/widgets/custom_chip.dart';
import 'package:dentist_booking_admin_app/core/widgets/header_background.dart';
import 'package:dentist_booking_admin_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/app_setup.dart';
import '../../../core/util/util.dart';
import '../blocs/booking/booking_cubit.dart';
import '../widget/booking_filters.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BookingCubit>()..getBookingsWithFilters(),
      child: const _BookingView(),
    );
  }
}

class _BookingView extends StatelessWidget {
  const _BookingView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          const HeaderBackground(height: 140),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedAddToList,
                        color: colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        LocaleKeys.Reservations.trnsltd,
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const BookingFilters(),
                Expanded(
                  child: BlocBuilder<BookingCubit, BookingState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading: () => _LoadingList(),
                        error: (message) => Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(message),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: () => context
                                    .read<BookingCubit>()
                                    .reload(),
                                child: Text(LocaleKeys.retry.trnsltd),
                              ),
                            ],
                          ),
                        ),
                        loaded: (bookings) {
                          if (bookings.isEmpty) {
                            return Center(
                              child: Text(
                                LocaleKeys.no_bookings.trnsltd,
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: () =>
                                context.read<BookingCubit>().reload(),
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              itemCount: bookings.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final booking = bookings[index];
                                return BookingCard(
                                  booking: booking,
                                  onTap: () => _showDetails(context, booking),
                                );
                              },
                            ),
                          );
                        },
                        orElse: () => const SizedBox.shrink(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, BookingModel booking) {
    SnackbarMes.showCustomBottomSheet(
      context: context,
      isExpanded: true,
      child: BookingDetailsSheet(booking: booking),
    );
  }
}

class _LoadingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: colorScheme.surfaceContainerHighest,
          highlightColor: colorScheme.surface,
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }
}

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  final BookingModel booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bookingDate = timeago.format(
      booking.bookingDate,
      locale: context.locale.languageCode,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${booking.queueNumber?.padLeft(4, '0') ?? '----'}',
                  style: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  '$bookingDate  |  ${booking.ticketCode ?? ''}',
                  style: textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface.withOpacity(0.55),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CustomChip(
                  text: booking.bookingStatus.name,
                  bgColor: booking.bookingStatus.tobgColorsBooking(),
                  txtColor: booking.bookingStatus.totxtColorsBooking(),
                ),
                const SizedBox(width: 8),
                CustomChip(
                  text: booking.shift.name,
                  bgColor: booking.shift.tobgColorsShiftBooking(),
                  txtColor: booking.shift.totxtColorsShiftBooking(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              booking.patientName ?? '—',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (booking.patientPhone != null)
              Text(
                booking.patientPhone!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.65),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BookingDetailsSheet extends StatelessWidget {
  const BookingDetailsSheet({super.key, required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.booking_details.trnsltd,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CustomChip(
                text: booking.bookingStatus.name,
                bgColor: booking.bookingStatus.tobgColorsBooking(),
                txtColor: booking.bookingStatus.totxtColorsBooking(),
              ),
              const SizedBox(width: 8),
              CustomChip(
                text: booking.shift.name,
                bgColor: booking.shift.tobgColorsShiftBooking(),
                txtColor: booking.shift.totxtColorsShiftBooking(),
              ),
              const SizedBox(width: 8),
              CustomChip(
                text: booking.patientType.name,
                bgColor: booking.patientType.tobgColorsPatient(),
                txtColor: booking.patientType.totxtColorsPatient(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DetailRow(
            icon: HugeIcons.strokeRoundedUser,
            label: booking.patientName ?? '—',
          ),
          _DetailRow(
            icon: HugeIcons.strokeRoundedCall,
            label: booking.patientPhone ?? '—',
          ),
          _DetailRow(
            icon: HugeIcons.strokeRoundedLocation01,
            label: booking.patientAddress ?? '—',
          ),
          _DetailRow(
            icon: HugeIcons.strokeRoundedTicket01,
            label: booking.ticketCode ?? '—',
          ),
          _DetailRow(
            icon: HugeIcons.strokeRoundedMenu01,
            label: '#${booking.queueNumber?.padLeft(4, '0') ?? '----'}',
          ),
          _DetailRow(
            icon: HugeIcons.strokeRoundedCalendar01,
            label: dateFormat.format(booking.bookingDate.toLocal()),
          ),
          if (booking.cancelReason != null &&
              booking.cancelReason!.trim().isNotEmpty)
            _DetailRow(
              icon: HugeIcons.strokeRoundedInformationCircle,
              label: booking.cancelReason!,
              color: colorScheme.error,
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: color ?? colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
