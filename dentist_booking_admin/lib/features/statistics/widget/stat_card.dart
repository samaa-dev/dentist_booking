import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/extensions/os_extensions.dart';
import '../../../generated/locale_keys.g.dart';

/// Rounded surface used by every block on the statistics screen.
class StatPanel extends StatelessWidget {
  const StatPanel({super.key, required this.child, this.title, this.trailing});

  final Widget child;
  final String? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(.15)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }
}

/// KPI card: big number, optional share of total, change vs previous period.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    this.share,
    this.previous,
    this.higherIsBetter = true,
  });

  final IconData icon;
  final Color color;
  final String label;
  final int value;

  /// Fraction of all bookings (0..1), shown as a percentage.
  final double? share;

  /// Same metric in the previous period of equal length.
  final int? previous;
  final bool higherIsBetter;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return StatPanel(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(.65),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$value',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (share != null) ...[
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          formatPercent(share!),
                          style: textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (previous != null) ...[
                  const SizedBox(height: 4),
                  TrendText(
                    current: value,
                    previous: previous!,
                    higherIsBetter: higherIsBetter,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrendText extends StatelessWidget {
  const TrendText({
    super.key,
    required this.current,
    required this.previous,
    required this.higherIsBetter,
  });

  final int current;
  final int previous;
  final bool higherIsBetter;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final muted = Theme.of(context).colorScheme.onSurface.withOpacity(.55);

    if (previous == 0) {
      return Text(
        LocaleKeys.stats_no_previous.trnsltd,
        style: textTheme.bodySmall?.copyWith(color: muted),
      );
    }

    final change = (current - previous) / previous;
    final up = change > 0;
    final flat = change.abs() < 0.005;
    final good = flat ? null : (up == higherIsBetter);
    final color = good == null
        ? muted
        : (good ? Colors.green.shade600 : Colors.red.shade400);

    return Row(
      children: [
        Icon(
          flat
              ? HugeIcons.strokeRoundedMinusSign
              : (up
                    ? HugeIcons.strokeRoundedArrowUpRight01
                    : HugeIcons.strokeRoundedArrowDownRight01),
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '${formatPercent(change.abs())} ${LocaleKeys.stats_vs_previous.trnsltd}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

String formatPercent(double fraction) {
  final pct = fraction * 100;
  return pct >= 10 || pct == 0
      ? '${pct.round()}%'
      : '${pct.toStringAsFixed(1)}%';
}
