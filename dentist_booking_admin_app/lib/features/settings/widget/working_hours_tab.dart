import 'package:dentist_booking_admin_app/features/settings/blocs/settings/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'working_day_card.dart';

class WorkingHoursTab extends StatelessWidget {
  const WorkingHoursTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();
    final hours = cubit.workingHoursTMP;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: [
          for (var day in hours)
            WorkingDayCard(
              day: day,

              onToggleOpen: (val) => cubit.updateDayOpen(day.id, val),

              onMorningStart: (val) => cubit.updateMorningStart(day.id, val),

              onMorningEnd: (val) => cubit.updateMorningEnd(day.id, val),

              onEveningStart: (val) => cubit.updateEveningStart(day.id, val),

              onEveningEnd: (val) => cubit.updateEveningEnd(day.id, val),

              onMorningIsOpen: (val) => cubit.updateMorningIsOpen(day.id, val),

              onEveningIsOpen: (val) => cubit.updateEveningIsOpen(day.id, val),
            ),
        ],
      ),
    );
  }
}
