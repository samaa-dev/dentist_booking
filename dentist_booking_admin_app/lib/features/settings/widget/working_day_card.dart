import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

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
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: day.isOpen
              ? colors.primary.withOpacity(0.25)
              : colors.outline.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _dayName(day.dayOfWeek),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: day.isOpen
                      ? Colors.green.withOpacity(0.15)
                      : colors.error.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  day.isOpen
                      ? LocaleKeys.status_activeing.trnsltd
                      : LocaleKeys.Closed.trnsltd,
                  style: textTheme.labelMedium?.copyWith(
                    color: day.isOpen ? Colors.green : colors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Switch.adaptive(
                value: day.isOpen,
                onChanged: onToggleOpen,
              ),
            ],
          ),
          if (!day.isOpen) ...[
            const SizedBox(height: 8),
            Text(
              LocaleKeys.Closed.trnsltd,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withOpacity(0.55),
              ),
            ),
          ],
          if (day.isOpen) ...[
            if (!day.morningIsOpen && !day.eveningIsOpen) ...[
              const SizedBox(height: 8),
              Text(
                LocaleKeys.warning_both_shifts_closed.trnsltd,
                style: textTheme.bodySmall?.copyWith(color: colors.error),
              ),
            ],
            const SizedBox(height: 14),
            _ShiftBlock(
              title: LocaleKeys.Morning.trnsltd,
              icon: HugeIcons.strokeRoundedSun03,
              isOpen: day.morningIsOpen,
              start: day.morningStart ?? '08:00',
              end: day.morningEnd ?? '12:00',
              onToggleOpen: onMorningIsOpen,
              onStart: onMorningStart,
              onEnd: onMorningEnd,
              isRtl: isRtl,
            ),
            const SizedBox(height: 12),
            _ShiftBlock(
              title: LocaleKeys.Evening.trnsltd,
              icon: HugeIcons.strokeRoundedMoon01,
              isOpen: day.eveningIsOpen,
              start: day.eveningStart ?? '14:00',
              end: day.eveningEnd ?? '18:00',
              onToggleOpen: onEveningIsOpen,
              onStart: onEveningStart,
              onEnd: onEveningEnd,
              isRtl: isRtl,
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

class _ShiftBlock extends StatelessWidget {
  const _ShiftBlock({
    required this.title,
    required this.icon,
    required this.isOpen,
    required this.start,
    required this.end,
    required this.onToggleOpen,
    required this.onStart,
    required this.onEnd,
    required this.isRtl,
  });

  final String title;
  final IconData icon;
  final bool isOpen;
  final String start;
  final String end;
  final ValueChanged<bool> onToggleOpen;
  final ValueChanged<String> onStart;
  final ValueChanged<String> onEnd;
  final bool isRtl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Opacity(
      opacity: isOpen ? 1 : 0.5,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: colors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ),
                Text(
                  isOpen
                      ? LocaleKeys.shift_period_open.trnsltd
                      : LocaleKeys.shift_period_closed.trnsltd,
                  style: textTheme.labelSmall?.copyWith(
                    color: isOpen ? colors.primary : colors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Switch.adaptive(
                  value: isOpen,
                  onChanged: onToggleOpen,
                ),
              ],
            ),
            const SizedBox(height: 10),
            IgnorePointer(
              ignoring: !isOpen,
              child: Row(
                children: [
                  Expanded(
                    child: SmallTimeButton(
                      value: start,
                      onChanged: onStart,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      isRtl
                          ? HugeIcons.strokeRoundedArrowLeft01
                          : HugeIcons.strokeRoundedArrowRight01,
                      size: 18,
                      color: colors.onSurface.withOpacity(0.55),
                    ),
                  ),
                  Expanded(
                    child: SmallTimeButton(
                      value: end,
                      onChanged: onEnd,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
