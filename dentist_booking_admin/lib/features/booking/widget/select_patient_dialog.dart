import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/booking/blocs/booking/booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/dialog_title_header.dart';
import '../../../generated/locale_keys.g.dart';
import 'select_patient_content.dart';

class SelectPatientDialog extends StatefulWidget {
  const SelectPatientDialog({super.key});

  @override
  State<SelectPatientDialog> createState() => _SelectPatientDialogState();
}

class _SelectPatientDialogState extends State<SelectPatientDialog> {
  late BookingCubit _bookingCubit;

  @override
  void initState() {
    super.initState();
    _bookingCubit = BlocProvider.of<BookingCubit>(context);
    _getPatient();
  }

  _getPatient() => _bookingCubit.getAllPatients();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogTitleHeader(
              title: LocaleKeys.select_patient_form_title.trnsltd,
              subtitle: LocaleKeys.select_patient_form_subtitle.trnsltd,
            ),

            SizedBox(
              height: 250,
              child: BlocBuilder<BookingCubit, BookingState>(
                buildWhen: (previous, current) {
                  return current.maybeWhen(
                    orElse: () => false,
                    loadingPatients: () => true,
                    loadedPatients: (_) => true,
                    errorPatients: (_) => true,
                  );
                },
                builder: (context, state) {
                  return state.maybeWhen(
                    loadingPatients: () => const Center(
                      child: CircularProgressIndicator(),
                    ),

                    loadedPatients: (listPatients) {
                      if (listPatients.isEmpty) {
                        return Center(
                          child: Text(
                            LocaleKeys.no_patients_found.trnsltd,
                            style: textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }

                      return SelectPatientContent(
                        listPatients: listPatients,
                      );
                    },

                    error: (message) {
                      return Center(
                        child: Text(
                          message,
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    orElse: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 30),
            _buildPatientDialog(context),
          ],
        ),
      ),
    );
  }

  _buildPatientDialog(BuildContext context) {
    return Flexible(
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context, null),
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          LocaleKeys.cancel_button.trnsltd,
          style: TextStyle().copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
