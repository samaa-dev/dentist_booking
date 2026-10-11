import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/app_setup.dart';
import '../../../core/extensions/os_extensions.dart';
import '../../../generated/locale_keys.g.dart';
import '../blocs/statistics_cubit.dart';
import '../model/clinic_statistics.dart';
import '../widget/stat_card.dart';
import '../widget/statistics_charts.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StatisticsCubit>()..load(),
      child: const _StatisticsLayout(),
    );
  }
}

class _StatisticsLayout extends StatelessWidget {
  const _StatisticsLayout();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        final data = state.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(state: state),
            const SizedBox(height: 16),
            if (state.loading && data == null)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (state.failed && data == null)
              Expanded(child: _ErrorView(onRetry: context.read<StatisticsCubit>().load))
            else if (data != null)
              Expanded(
                child: Stack(
                  children: [
                    _Body(data: data),
                    if (state.loading)
                      const Align(
                        alignment: Alignment.topCenter,
                        child: LinearProgressIndicator(minHeight: 2),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.state});

  final StatisticsState state;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<StatisticsCubit>();

    String label(StatisticsPeriod p) => switch (p) {
      StatisticsPeriod.today => LocaleKeys.stats_period_today.trnsltd,
      StatisticsPeriod.last7Days => LocaleKeys.stats_period_7_days.trnsltd,
      StatisticsPeriod.last30Days => LocaleKeys.stats_period_30_days.trnsltd,
      StatisticsPeriod.thisMonth => LocaleKeys.stats_period_this_month.trnsltd,
      StatisticsPeriod.lastMonth => LocaleKeys.stats_period_last_month.trnsltd,
      StatisticsPeriod.custom => LocaleKeys.stats_period_custom.trnsltd,
    };

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 12,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.Statistics.trnsltd,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${_fmt(state.from)}  —  ${_fmt(state.to)}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(.6),
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final p in StatisticsPeriod.values)
              ChoiceChip(
                label: Text(label(p)),
                selected: state.period == p,
                onSelected: (_) async {
                  if (p == StatisticsPeriod.custom) {
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2025),
                      lastDate: DateTime.now(),
                      initialDateRange: DateTimeRange(start: state.from, end: state.to),
                    );
                    if (range != null) {
                      await cubit.selectCustomRange(range.start, range.end);
                    }
                  } else {
                    await cubit.selectPeriod(p);
                  }
                },
              ),
            IconButton(
              tooltip: LocaleKeys.refresh.trnsltd,
              onPressed: state.loading ? null : cubit.load,
              icon: Icon(HugeIcons.strokeRoundedRefresh, color: colorScheme.primary),
            ),
          ],
        ),
      ],
    );
  }

  static String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

class _Body extends StatelessWidget {
  const _Body({required this.data});

  final ClinicStatistics data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 1100;
        final kpiColumns = constraints.maxWidth >= 900 ? 4 : 2;

        Widget pair(Widget a, Widget b, {int flexA = 2, int flexB = 1}) => wide
            ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: flexA, child: a),
                    const SizedBox(width: 16),
                    Expanded(flex: flexB, child: b),
                  ],
                ),
              )
            : Column(children: [a, const SizedBox(height: 16), b]);

        final kpis = [
          StatCard(
            icon: HugeIcons.strokeRoundedCalendar03,
            color: colorScheme.primary,
            label: LocaleKeys.stats_total_bookings.trnsltd,
            value: data.total,
            previous: data.previous.total,
          ),
          StatCard(
            icon: HugeIcons.strokeRoundedCheckmarkCircle02,
            color: StatusColors.completed,
            label: LocaleKeys.stats_completed.trnsltd,
            value: data.status.completed,
            share: data.rate(data.status.completed),
            previous: data.previous.completed,
          ),
          StatCard(
            icon: HugeIcons.strokeRoundedUserRemove01,
            color: StatusColors.noShow,
            label: LocaleKeys.stats_no_show.trnsltd,
            value: data.status.noShow,
            share: data.rate(data.status.noShow),
            previous: data.previous.noShow,
            higherIsBetter: false,
          ),
          StatCard(
            icon: HugeIcons.strokeRoundedCancelCircle,
            color: StatusColors.cancelledByPatient,
            label: LocaleKeys.stats_cancelled.trnsltd,
            value: data.cancelled,
            share: data.rate(data.cancelled),
            previous: data.previous.cancelled,
            higherIsBetter: false,
          ),
        ];

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Grid(columns: kpiColumns, children: kpis),
              const SizedBox(height: 16),
              _TodayStrip(today: data.today),
              const SizedBox(height: 16),
              pair(
                StatPanel(
                  title: LocaleKeys.stats_daily_bookings.trnsltd,
                  child: DailyBookingsChart(points: data.daily),
                ),
                StatPanel(
                  title: LocaleKeys.stats_status_breakdown.trnsltd,
                  child: StatusDonut(data: data),
                ),
              ),
              const SizedBox(height: 16),
              pair(
                StatPanel(
                  title: LocaleKeys.stats_weekday_average.trnsltd,
                  child: WeekdayChart(points: data.weekday),
                ),
                _Breakdowns(data: data),
                flexA: 1,
                flexB: 1,
              ),
              const SizedBox(height: 16),
              _PatientsRow(data: data, columns: kpiColumns),
            ],
          ),
        );
      },
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.columns, required this.children});

  final int columns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 16.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [for (final c in children) SizedBox(width: width, child: c)],
        );
      },
    );
  }
}

class _TodayStrip extends StatelessWidget {
  const _TodayStrip({required this.today});

  final TodaySnapshot today;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Widget item(String label, int value, Color color) => Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: textTheme.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );

    return StatPanel(
      title: LocaleKeys.stats_today.trnsltd,
      trailing: Icon(HugeIcons.strokeRoundedSun03, color: colorScheme.primary, size: 18),
      child: Row(
        children: [
          item(LocaleKeys.stats_total_bookings.trnsltd, today.total, colorScheme.primary),
          item(LocaleKeys.stats_waiting.trnsltd, today.waiting, StatusColors.waiting),
          item(LocaleKeys.stats_completed.trnsltd, today.completed, StatusColors.completed),
          item(LocaleKeys.stats_no_show.trnsltd, today.noShow, StatusColors.noShow),
          item(LocaleKeys.stats_cancelled.trnsltd, today.cancelled, StatusColors.cancelledByPatient),
          item(LocaleKeys.booking_morning.trnsltd, today.morning, colorScheme.secondary),
          item(LocaleKeys.booking_evening.trnsltd, today.evening, colorScheme.tertiary),
        ],
      ),
    );
  }
}

class _Breakdowns extends StatelessWidget {
  const _Breakdowns({required this.data});

  final ClinicStatistics data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final busiest = data.busiestDay;

    Widget fact(IconData icon, String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: textTheme.bodyMedium)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );

    return StatPanel(
      title: LocaleKeys.stats_breakdowns.trnsltd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SplitBar(
            leftLabel: LocaleKeys.booking_morning.trnsltd,
            leftValue: data.morning,
            leftColor: colorScheme.secondary,
            rightLabel: LocaleKeys.booking_evening.trnsltd,
            rightValue: data.evening,
            rightColor: colorScheme.tertiary,
          ),
          const SizedBox(height: 16),
          SplitBar(
            leftLabel: LocaleKeys.stats_source_patient_app.trnsltd,
            leftValue: data.fromPatientApp,
            leftColor: colorScheme.primary,
            rightLabel: LocaleKeys.stats_source_clinic.trnsltd,
            rightValue: data.fromClinic,
            rightColor: Colors.blueGrey,
          ),
          const SizedBox(height: 12),
          fact(
            HugeIcons.strokeRoundedChartAverage,
            LocaleKeys.stats_avg_per_day.trnsltd,
            data.averagePerWorkingDay.toStringAsFixed(1),
          ),
          fact(
            HugeIcons.strokeRoundedFire,
            LocaleKeys.stats_busiest_day.trnsltd,
            busiest == null
                ? '-'
                : '${busiest.day}/${busiest.month}  (${data.busiestDayTotal})',
          ),
          fact(
            HugeIcons.strokeRoundedUserArrowLeftRight,
            LocaleKeys.stats_for_others.trnsltd,
            '${data.forOthers}',
          ),
        ],
      ),
    );
  }
}

class _PatientsRow extends StatelessWidget {
  const _PatientsRow({required this.data, required this.columns});

  final ClinicStatistics data;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _Grid(
      columns: columns >= 4 ? 3 : 1,
      children: [
        StatCard(
          icon: HugeIcons.strokeRoundedUserGroup,
          color: colorScheme.primary,
          label: LocaleKeys.stats_patients_registered.trnsltd,
          value: data.patientsRegistered,
        ),
        StatCard(
          icon: HugeIcons.strokeRoundedUserAdd01,
          color: StatusColors.completed,
          label: LocaleKeys.stats_patients_new.trnsltd,
          value: data.patientsNew,
        ),
        StatCard(
          icon: HugeIcons.strokeRoundedUserCheck01,
          color: StatusColors.waiting,
          label: LocaleKeys.stats_patients_active.trnsltd,
          value: data.patientsActive,
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(HugeIcons.strokeRoundedChartBreakoutCircle, size: 64, color: colorScheme.error),
          const SizedBox(height: 12),
          Text(LocaleKeys.stats_error.trnsltd),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(HugeIcons.strokeRoundedRefresh),
            label: Text(LocaleKeys.retry.tr()),
          ),
        ],
      ),
    );
  }
}
