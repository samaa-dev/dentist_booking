import 'package:dentist_booking_admin/features/patient/blocs/cubit/patient_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_setup.dart';
import '../../../core/util/util.dart';
import '../widget/empty_patient.dart';
import '../widget/error_patient.dart';
import '../widget/patient_header.dart';
import '../widget/patient_table.dart';

class PatientScreen extends StatelessWidget {
  const PatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientCubit>(
      create: (context) => getIt<PatientCubit>()..getAllPatient(),
      child: BlocConsumer<PatientCubit, PatientState>(
        listenWhen: (previous, current) {
          return current.maybeWhen(
            orElse: () => false,
            error: (_) => true,
            // successUpdatePatient: (staff) {},
          );
        },
        listener: (context, state) {
          state.maybeWhen(
            orElse: () => {},
            error: (message) =>
                SnackbarMes.showToastMsg(context, message: message),
          );
        },
        builder: (context, state) {
          return _PatientLayout();
        },
      ),
    );
  }
}

class _PatientLayout extends StatelessWidget {
  const _PatientLayout();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<PatientCubit, PatientState>(
      buildWhen: (previous, current) {
        return current.maybeWhen(
          orElse: () => false,
          loaded: (_) => true,
          loading: () => true,
          error: (_) => true,
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => Center(
            child: CircularProgressIndicator(
              color: colorScheme.primary,
            ),
          ),

          loaded: (patientList) {
            if (patientList.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PatientHeader(),
                  Spacer(),
                  EmptyPatient(),
                  Spacer(),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PatientHeader(),
                const SizedBox(height: 20),
                Expanded(
                  child: PatientTable(
                    patientList: patientList,
                  ),
                ),
              ],
            );
          },
          error: (message) => ErrorPatient(message: message),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
