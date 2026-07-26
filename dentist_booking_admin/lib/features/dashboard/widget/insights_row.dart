import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';

class InsightsColumn extends StatelessWidget {
  const InsightsColumn({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      InsightItem(
        icon: Icons.schedule_outlined,
        title: LocaleKeys.insight_peak_time,
        value: "11:00 - 09:00",
      ),
      InsightItem(
        icon: Icons.timer_outlined,
        title: LocaleKeys.insight_avg_waiting,
        value: "12 ${LocaleKeys.minutes_label.trnsltd}",
      ),
      InsightItem(
        icon: Icons.person_outline,
        title: LocaleKeys.insight_most_active_staff,
        value: "أحمد",
      ),
    ];

    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i != 0) const SizedBox(height: 12),
          items[i],
        ],
      ],
    );
  }
}

class InsightItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InsightItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline.withOpacity(.12)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value.trnsltd,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title.trnsltd,
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurface.withOpacity(.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
