import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

import '../../../core/enum/enum.dart';
import '../../../core/model/booking_model.dart';

class BookingStatusSelector extends StatelessWidget {
  final BookingStatus? selectedStatus;
  final Function(BookingStatus?) onStatusChanged;
  final List<BookingModel> allCountsBookings;

  const BookingStatusSelector({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.allCountsBookings,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = BookingStatus.values;

    final counts = <BookingStatus, int>{};
    for (final booking in allCountsBookings) {
      counts[booking.bookingStatus] = (counts[booking.bookingStatus] ?? 0) + 1;
    }

    final int total = counts.values.fold(0, (a, b) => a + b);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: statuses.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 4),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _StatusChip(
              label: LocaleKeys.status_all.trnsltd,
              selected: selectedStatus == null,
              count: total,
              onTap: () => onStatusChanged(null),
            );
          }

          final status = statuses[index - 1];
          final count = counts[status] ?? 0;

          return _StatusChip(
            label: status.name,
            selected: selectedStatus == status,
            count: count,
            onTap: () => onStatusChanged(status),
          );
        },
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool selected;
  final String label;
  final int count;
  final VoidCallback onTap;

  const _StatusChip({
    required this.selected,
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: selected
            ? colorScheme.primary
            : colorScheme.surfaceVariant.withOpacity(0.20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: selected ? colorScheme.onPrimary : colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "$count",
                  style: TextStyle(
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
