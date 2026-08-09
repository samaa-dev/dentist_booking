import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

import '../../../core/model/working_hours_model.dart';
import 'small_time_button.dart';

class WorkingDayCard extends StatelessWidget {
  final WorkingHoursModel day;
  final Function(bool) onToggleOpen;
  final Function(String) onMorningStart;
  final Function(String) onMorningEnd;
  final Function(String) onEveningStart;
  final Function(String) onEveningEnd;
  final Function(bool) onMorningIsOpen;
  final Function(bool) onEveningIsOpen;

  const WorkingDayCard({
    super.key,
    required this.day,
    required this.onToggleOpen,
    required this.onMorningStart,
    required this.onMorningEnd,
    required this.onEveningStart,
    required this.onEveningEnd,
    required this.onMorningIsOpen,
    required this.onEveningIsOpen,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: colors.surface.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _dayName(day.dayOfWeek),
                style: textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Switch(
                value: day.isOpen,
                onChanged: onToggleOpen,
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (!day.isOpen)
            Text(
              LocaleKeys.Closed.trnsltd,
              style: textTheme.bodyMedium!.copyWith(
                color: colors.onSurface.withOpacity(0.5),
              ),
            ),

          if (day.isOpen) ...[
            if (!day.morningIsOpen && !day.eveningIsOpen) ...[
              Text(
                LocaleKeys.warning_both_shifts_closed.trnsltd,
                style: textTheme.bodySmall!.copyWith(
                  color: colors.error,
                ),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 10),
            _ShiftRow(
              label: LocaleKeys.Morning.trnsltd,
              isOpen: day.morningIsOpen,
              start: day.morningStart ?? '08:00',
              end: day.morningEnd ?? '12:00',
              onToggleOpen: onMorningIsOpen,
              onStart: onMorningStart,
              onEnd: onMorningEnd,
            ),
            const SizedBox(height: 20),
            _ShiftRow(
              label: LocaleKeys.Evening.trnsltd,
              isOpen: day.eveningIsOpen,
              start: day.eveningStart ?? '14:00',
              end: day.eveningEnd ?? '18:00',
              onToggleOpen: onEveningIsOpen,
              onStart: onEveningStart,
              onEnd: onEveningEnd,
            ),
          ],
        ],
      ),
    );
  }

  String _dayName(int d) {
    switch (d) {
      case 1:
        return LocaleKeys.Saturday.trnsltd;
      case 2:
        return LocaleKeys.Sunday.trnsltd;
      case 3:
        return LocaleKeys.Monday.trnsltd;
      case 4:
        return LocaleKeys.Tuesday.trnsltd;
      case 5:
        return LocaleKeys.Wednesday.trnsltd;
      case 6:
        return LocaleKeys.Thursday.trnsltd;
      case 7:
        return LocaleKeys.Friday.trnsltd;
      default:
        return '';
    }
  }
}

class _ShiftRow extends StatelessWidget {
  const _ShiftRow({
    required this.label,
    required this.isOpen,
    required this.start,
    required this.end,
    required this.onToggleOpen,
    required this.onStart,
    required this.onEnd,
  });

  final String label;
  final bool isOpen;
  final String start;
  final String end;
  final ValueChanged<bool> onToggleOpen;
  final ValueChanged<String> onStart;
  final ValueChanged<String> onEnd;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final arrow = isRTL ? '←' : '→';

    return Opacity(
      opacity: isOpen ? 1 : 0.45,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: textTheme.bodyLarge),
          ),
          Switch(
            value: isOpen,
            onChanged: onToggleOpen,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: IgnorePointer(
              ignoring: !isOpen,
              child: Row(
                children: [
                  Expanded(
                    child: SmallTimeButton(
                      value: start,
                      onChanged: onStart,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(arrow, style: textTheme.titleMedium),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SmallTimeButton(
                      value: end,
                      onChanged: onEnd,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isOpen) ...[
            const SizedBox(width: 8),
            Text(
              LocaleKeys.shift_period_closed.trnsltd,
              style: textTheme.labelSmall?.copyWith(color: colors.error),
            ),
          ],
        ],
      ),
    );
  }
}
