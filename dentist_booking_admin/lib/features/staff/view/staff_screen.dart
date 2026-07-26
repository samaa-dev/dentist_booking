import 'package:dentist_booking_admin/features/staff/widget/error_staff.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_setup.dart';
import '../../../core/util/util.dart';
import '../../../core/widgets/loading_dialog.dart';
import '../blocs/staff/staff_cubit.dart';
import '../widget/empty_staff.dart';
import '../widget/staff_header.dart';
import '../widget/staff_table.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StaffCubit>(
      create: (context) => getIt<StaffCubit>()..fetchStaff(),
      child: BlocConsumer<StaffCubit, StaffState>(
        listenWhen: (previous, current) {
          return current.maybeMap(
            orElse: () => false,
            error: (_) => true,
            errorAddStaff: (_) => true,
            errorDeleteStaff: (_) => true,
            errorUpdateStaff: (_) => true,
            successChangePasswordStaff: (_) => true,
          );
        },
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},

            loadingStaff: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => LoadingDialog(),
              );
            },

            errorAddStaff: (message) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              SnackbarMes.showToastMsg(context, message: message);
            },

            errorDeleteStaff: (message) => SnackbarMes.showToastMsg(
              context,
              message: message,
            ),
            errorUpdateStaff: (message) => SnackbarMes.showToastMsg(
              context,
              message: message,
            ),
            successChangePasswordStaff: (message) => SnackbarMes.showToastMsg(
              context,
              message: message,
            ),

            error: (message) {
              SnackbarMes.showToastMsg(
                context,
                message: message,
              );
            },
          );
        },
        builder: (context, state) {
          return _StaffLayout();
        },
      ),
    );
  }
}

class _StaffLayout extends StatelessWidget {
  const _StaffLayout();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return BlocBuilder<StaffCubit, StaffState>(
      buildWhen: (previous, current) {
        return current.maybeWhen(
          orElse: () => false,
          loading: () => true,
          loaded: (_) => true,
          error: (_) => true,
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => Center(
            child: CircularProgressIndicator(
              color: color.primary,
            ),
          ),

          loaded: (staffList) {
            if (staffList.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocProvider.value(
                    value: context.read<StaffCubit>(),
                    child: StaffHeader(),
                  ),
                  Spacer(),
                  EmptyStaff(),
                  Spacer(),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocProvider.value(
                  value: context.read<StaffCubit>(),
                  child: StaffHeader(),
                ),

                const SizedBox(height: 20),
                Expanded(
                  child: StaffTable(
                    staffList: staffList,
                  ),
                ),
              ],
            );
          },

          error: (message) => ErrorStaff(message: message),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
