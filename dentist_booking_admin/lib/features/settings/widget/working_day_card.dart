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

  const WorkingDayCard({
    super.key,
    required this.day,
    required this.onToggleOpen,
    required this.onMorningStart,
    required this.onMorningEnd,
    required this.onEveningStart,
    required this.onEveningEnd,
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
          // ---------------- Day Header ----------------
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

          // If day is closed → hide the times
          if (!day.isOpen)
            Text(
              LocaleKeys.Closed.trnsltd,
              style: textTheme.bodyMedium!.copyWith(
                color: colors.onSurface.withOpacity(0.5),
              ),
            ),

          if (day.isOpen) ...[
            const SizedBox(height: 10),

            // ---------------- Morning Row ----------------
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    LocaleKeys.Morning.trnsltd,
                    style: textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: SmallTimeButton(
                          value: day.morningStart ?? "08:00",
                          onChanged: onMorningStart,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Builder(
                        builder: (context) {
                          final isRTL =
                              Directionality.of(context) == TextDirection.rtl;
                          final arrow = isRTL ? "←" : "→";

                          return Text(
                            arrow,
                            style: textTheme.titleMedium,
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SmallTimeButton(
                          value: day.morningEnd ?? "12:00",
                          onChanged: onMorningEnd,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ---------------- Evening Row ----------------
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    LocaleKeys.Evening.trnsltd,
                    style: textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: SmallTimeButton(
                          value: day.eveningStart ?? "14:00",
                          onChanged: onEveningStart,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text("→", style: textTheme.titleMedium),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SmallTimeButton(
                          value: day.eveningEnd ?? "18:00",
                          onChanged: onEveningEnd,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
        return "";
    }
  }
}
