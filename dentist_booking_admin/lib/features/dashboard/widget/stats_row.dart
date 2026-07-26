import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/model/dashboard_stats_model.dart';

class StatsRow extends StatelessWidget {
  final DashboardStatsModel stats;

  const StatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[
      StatCard(
        titleKey: LocaleKeys.stats_today_bookings,
        value: stats.totalBookingsToday,
        icon: HugeIcons.strokeRoundedCalendar04,
        accent: Colors.blueAccent,
      ),
      StatCard(
        titleKey: LocaleKeys.stats_confirmed_bookings,
        value: stats.confirmedToday,
        icon: HugeIcons.strokeRoundedCheckmarkCircle02,
        accent: Colors.greenAccent,
      ),
      StatCard(
        titleKey: LocaleKeys.stats_cancelled,
        value: stats.cancelledToday,
        icon: HugeIcons.strokeRoundedCancelCircle,
        accent: Colors.redAccent,
      ),
      StatCard(
        titleKey: LocaleKeys.stats_no_show,
        value: stats.noShowToday,
        icon: HugeIcons.strokeRoundedAlertCircle,
        accent: Colors.orangeAccent,
      ),
      StatCard(
        titleKey: LocaleKeys.stats_new_patients,
        value: stats.newPatientsToday,
        icon: HugeIcons.strokeRoundedAddCircle,
        accent: Colors.purpleAccent,
      ),
    ];

    return Row(
      children: [
        for (int i = 0; i < cards.length; i++) ...[
          if (i != 0) const SizedBox(width: 16),
          Expanded(child: cards[i]),
        ],
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String titleKey;
  final int value;
  final IconData icon;
  final Color accent;

  const StatCard({
    super.key,
    required this.titleKey,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 130,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withOpacity(.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accent.withOpacity(.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 20, color: accent),
            ),
          ),

          const Spacer(),

          Text(
            value.twoDigits(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            titleKey.trnsltd,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(.7),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
