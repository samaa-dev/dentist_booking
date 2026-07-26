import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/model/dashboard_stats_model.dart';
import '../../../generated/locale_keys.g.dart';

class TodaySummaryCard extends StatelessWidget {
  final DashboardStatsModel stats;

  const TodaySummaryCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(now);
    final timeStr = DateFormat('HH:mm').format(now);

    final double loadRatio = (stats.totalBookingsToday / 20)
        .clamp(0, 1)
        .toDouble();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.outline.withOpacity(.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان + التاريخ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.today_summary_title.trnsltd,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    dateStr,
                    style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // الفترة + الوقت
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryItem(
                icon: Icons.wb_sunny_outlined,
                label: LocaleKeys.today_summary_period.trnsltd,
                value: LocaleKeys.today_summary_period_value.trnsltd,
              ),
              _summaryItem(
                icon: Icons.schedule_outlined,
                label: LocaleKeys.today_summary_time.trnsltd,
                value: timeStr,
              ),
            ],
          ),

          const SizedBox(height: 18),

          LinearProgressIndicator(
            value: loadRatio,
            minHeight: 4,
            backgroundColor: scheme.surfaceVariant.withOpacity(.4),
          ),

          const SizedBox(height: 8),

          Text(
            LocaleKeys.today_summary_insight.trnsltd,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withOpacity(.65),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                // color: Colors.black,
              ),
            ),
            Text(
              value,
              style: const TextStyle().copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
