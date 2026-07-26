import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dentist_booking_admin_app/core/enum/enum.dart';
import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../blocs/booking/booking_cubit.dart';

class BookingFilters extends StatelessWidget {
  const BookingFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.watch<BookingCubit>();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          TextField(
            onChanged: cubit.setSearchQuery,
            decoration: InputDecoration(
              hintText: LocaleKeys.search.trnsltd,
              prefixIcon: const Icon(HugeIcons.strokeRoundedSearch01),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: BookingDateScope.values.map((scope) {
                final selected = cubit.dateScope == scope;
                final label = scope == BookingDateScope.other
                    ? (Localizations.localeOf(context).languageCode == 'ar'
                        ? 'مخصص'
                        : 'Custom')
                    : scope.name;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: selected,
                    onSelected: (_) {
                      if (scope == BookingDateScope.other) {
                        _pickRange(context);
                      } else {
                        cubit.setDateScope(scope);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: Text(LocaleKeys.status_all.trnsltd),
                  selected: cubit.selectedStatus == null,
                  onSelected: (_) => cubit.setStatus(null),
                ),
                const SizedBox(width: 8),
                ...BookingStatus.values.map((status) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: FilterChip(
                      label: Text(status.name),
                      selected: cubit.selectedStatus == status,
                      onSelected: (_) => cubit.setStatus(
                        cubit.selectedStatus == status ? null : status,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              FilterChip(
                label: Text(LocaleKeys.shift_morning.trnsltd),
                selected: cubit.selectedShift == BookingShift.morning,
                onSelected: (_) => cubit.setShift(
                  cubit.selectedShift == BookingShift.morning
                      ? null
                      : BookingShift.morning,
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(LocaleKeys.shift_evening.trnsltd),
                selected: cubit.selectedShift == BookingShift.evening,
                onSelected: (_) => cubit.setShift(
                  cubit.selectedShift == BookingShift.evening
                      ? null
                      : BookingShift.evening,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: cubit.resetFilters,
                child: Text(LocaleKeys.reset.trnsltd),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickRange(BuildContext context) async {
    final cubit = context.read<BookingCubit>();
    final results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
      ),
      dialogSize: const Size(340, 400),
      value: [
        cubit.startDate ?? DateTime.now(),
        cubit.endDate ?? DateTime.now(),
      ],
    );

    if (results != null && results.isNotEmpty) {
      final start = results.first;
      final end = results.length > 1 ? results.last : results.first;
      if (start != null && end != null) {
        cubit.setCustomDateRange(start, end);
      }
    }
  }
}
