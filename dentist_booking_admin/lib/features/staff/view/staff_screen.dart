import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_setup.dart';
import '../blocs/staff/staff_cubit.dart';
import '../widget/empty_staff.dart';
import '../widget/error_staff.dart';
import '../widget/staff_header.dart';
import '../widget/staff_table.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StaffCubit>(
      create: (_) => getIt<StaffCubit>()..load(),
      child: const _StaffLayout(),
    );
  }
}

class _StaffLayout extends StatelessWidget {
  const _StaffLayout();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<StaffCubit, StaffState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StaffHeader(
              activeCount: switch (state) {
                StaffLoaded(:final members) =>
                  members.where((m) => m.isActive).length,
                _ => null,
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: switch (state) {
                StaffLoading() => Center(
                  child: CircularProgressIndicator(color: colorScheme.primary),
                ),
                StaffError(:final message) => ErrorStaff(message: message),
                StaffLoaded(:final members) when members.isEmpty =>
                  const EmptyStaff(),
                StaffLoaded(:final members) => StaffTable(members: members),
              },
            ),
          ],
        );
      },
    );
  }
}
