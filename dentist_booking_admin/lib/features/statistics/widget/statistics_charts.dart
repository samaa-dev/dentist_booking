import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/extensions/os_extensions.dart';
import '../../../generated/locale_keys.g.dart';
import '../model/clinic_statistics.dart';
import 'stat_card.dart';

/// Status colours shared by the donut and its legend.
class StatusColors {
  static const completed = Color(0xFF16A34A);
  static const waiting = Color(0xFF2563EB);
  static const noShow = Color(0xFFF59E0B);
  static const cancelledByPatient = Color(0xFFEF4444);
  static const cancelledByStaff = Color(0xFF9F1239);
}

/// Bookings per day: total vs completed.
class DailyBookingsChart extends StatelessWidget {
  const DailyBookingsChart({super.key, required this.points});

  final List<DailyPoint> points;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final muted = colorScheme.onSurface.withOpacity(.5);

    if (points.isEmpty) return const SizedBox(height: 240);

    final maxY = points.map((p) => p.total).fold<int>(0, math.max);
    final top = maxY == 0 ? 5.0 : (maxY * 1.2).ceilToDouble();
    final labelEvery = math.max(1, (points.length / 7).ceil());

    LineChartBarData line(List<int> values, Color color, {bool fill = false}) {
      return LineChartBarData(
        spots: [
          for (var i = 0; i < values.length; i++)
            FlSpot(i.toDouble(), values[i].toDouble()),
        ],
        isCurved: true,
        preventCurveOverShooting: true,
        color: color,
        barWidth: 3,
        dotData: FlDotData(show: points.length <= 14),
        belowBarData: BarAreaData(
          show: fill,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withOpacity(.25), color.withOpacity(0)],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          children: [
            _LegendDot(color: colorScheme.primary, label: LocaleKeys.stats_total_bookings.trnsltd),
            _LegendDot(color: StatusColors.completed, label: LocaleKeys.stats_completed.trnsltd),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          // Time runs left-to-right even in Arabic.
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: top,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: math.max(1, top / 4),
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: colorScheme.outline.withOpacity(.12),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: math.max(1, top / 4),
                      getTitlesWidget: (v, _) => Text(
                        v.toInt().toString(),
                        style: TextStyle(fontSize: 11, color: muted),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 26,
                      getTitlesWidget: (v, _) {
                        final i = v.toInt();
                        if (i < 0 || i >= points.length || i % labelEvery != 0) {
                          return const SizedBox.shrink();
                        }
                        final d = points[i].date;
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            '${d.day}/${d.month}',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => colorScheme.inverseSurface,
                    getTooltipItems: (spots) => [
                      for (final s in spots)
                        LineTooltipItem(
                          s.barIndex == 0
                              ? '${_date(points[s.x.toInt()].date)}\n${LocaleKeys.stats_total_bookings.trnsltd}: ${s.y.toInt()}'
                              : '${LocaleKeys.stats_completed.trnsltd}: ${s.y.toInt()}',
                          TextStyle(
                            color: colorScheme.onInverseSurface,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                lineBarsData: [
                  line(points.map((p) => p.total).toList(), colorScheme.primary, fill: true),
                  line(points.map((p) => p.completed).toList(), StatusColors.completed),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static String _date(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

/// Donut of booking outcomes with a legend.
class StatusDonut extends StatelessWidget {
  const StatusDonut({super.key, required this.data});

  final ClinicStatistics data;

  @override
  Widget build(BuildContext context) {
    final s = data.status;
    final slices = <(String, int, Color)>[
      (LocaleKeys.stats_completed.trnsltd, s.completed, StatusColors.completed),
      (LocaleKeys.stats_waiting.trnsltd, s.pending + s.confirmed, StatusColors.waiting),
      (LocaleKeys.stats_no_show.trnsltd, s.noShow, StatusColors.noShow),
      (LocaleKeys.stats_cancelled_by_patient.trnsltd, s.cancelledByPatient, StatusColors.cancelledByPatient),
      (LocaleKeys.stats_cancelled_by_staff.trnsltd, s.cancelledByStaff, StatusColors.cancelledByStaff),
    ];
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 58,
                  sections: data.total == 0
                      ? [
                          PieChartSectionData(
                            value: 1,
                            color: Theme.of(context).colorScheme.outline.withOpacity(.2),
                            showTitle: false,
                            radius: 22,
                          ),
                        ]
                      : [
                          for (final (_, value, color) in slices)
                            if (value > 0)
                              PieChartSectionData(
                                value: value.toDouble(),
                                color: color,
                                showTitle: false,
                                radius: 22,
                              ),
                        ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${data.total}',
                    style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  Text(LocaleKeys.stats_bookings.trnsltd, style: textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        for (final (label, value, color) in slices)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                _LegendDot(color: color, label: label),
                const Spacer(),
                Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 52,
                  child: Text(
                    formatPercent(data.rate(value)),
                    textAlign: TextAlign.end,
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Average bookings per weekday (Saturday first, like the clinic week).
class WeekdayChart extends StatelessWidget {
  const WeekdayChart({super.key, required this.points});

  final List<WeekdayPoint> points;

  static const _keys = [
    LocaleKeys.day_sat_short,
    LocaleKeys.day_sun_short,
    LocaleKeys.day_mon_short,
    LocaleKeys.day_tue_short,
    LocaleKeys.day_wed_short,
    LocaleKeys.day_thu_short,
    LocaleKeys.day_fri_short,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final muted = colorScheme.onSurface.withOpacity(.55);
    final byDay = {for (final p in points) p.dayOfWeek: p.average};
    final maxAvg = byDay.values.fold<double>(0, math.max);

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: maxAvg == 0 ? 1 : maxAvg * 1.25,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                getTitlesWidget: (v, _) => Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _keys[v.toInt() - 1].trnsltd,
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                ),
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => colorScheme.inverseSurface,
              getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                rod.toY.toStringAsFixed(1),
                TextStyle(color: colorScheme.onInverseSurface, fontSize: 12),
              ),
            ),
          ),
          barGroups: [
            for (var day = 1; day <= 7; day++)
              BarChartGroupData(
                x: day,
                barRods: [
                  BarChartRodData(
                    toY: byDay[day] ?? 0,
                    width: 18,
                    color: (byDay[day] ?? 0) == maxAvg && maxAvg > 0
                        ? colorScheme.primary
                        : colorScheme.primary.withOpacity(.45),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Two-part horizontal bar (e.g. morning vs evening).
class SplitBar extends StatelessWidget {
  const SplitBar({
    super.key,
    required this.leftLabel,
    required this.leftValue,
    required this.leftColor,
    required this.rightLabel,
    required this.rightValue,
    required this.rightColor,
  });

  final String leftLabel;
  final int leftValue;
  final Color leftColor;
  final String rightLabel;
  final int rightValue;
  final Color rightColor;

  @override
  Widget build(BuildContext context) {
    final total = leftValue + rightValue;
    final leftShare = total == 0 ? 0.5 : leftValue / total;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _LegendDot(color: leftColor, label: '$leftLabel  $leftValue'),
            const Spacer(),
            _LegendDot(color: rightColor, label: '$rightLabel  $rightValue'),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 12,
            child: Row(
              children: [
                Expanded(
                  flex: math.max(1, (leftShare * 1000).round()),
                  child: Container(color: total == 0 ? leftColor.withOpacity(.2) : leftColor),
                ),
                Expanded(
                  flex: math.max(1, ((1 - leftShare) * 1000).round()),
                  child: Container(color: total == 0 ? rightColor.withOpacity(.2) : rightColor),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(formatPercent(total == 0 ? 0 : leftShare), style: textTheme.bodySmall),
            const Spacer(),
            Text(formatPercent(total == 0 ? 0 : 1 - leftShare), style: textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
