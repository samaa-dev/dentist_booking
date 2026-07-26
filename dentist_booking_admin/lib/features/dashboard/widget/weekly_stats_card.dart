import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';

class WeeklyStatsCard extends StatelessWidget {
  const WeeklyStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final days = [
      LocaleKeys.week_sat.trnsltd,
      LocaleKeys.week_sun.trnsltd,
      LocaleKeys.week_mon.trnsltd,
      LocaleKeys.week_tue.trnsltd,
      LocaleKeys.week_wed.trnsltd,
      LocaleKeys.week_thu.trnsltd,
      LocaleKeys.week_fri.trnsltd,
    ];

    final values = [4, 6, 3, 8, 5, 2, 7];
    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.outline.withOpacity(.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.weekly_stats_title.trnsltd,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < days.length; i++) ...[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 14,
                              height: (values[i] / maxValue) * 110,
                              decoration: BoxDecoration(
                                color: scheme.primary.withOpacity(.8),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          days[i],
                          style: textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withOpacity(.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i != days.length - 1) const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
