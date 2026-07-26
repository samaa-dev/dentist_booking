import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/model/profile_model.dart';
import '../../../generated/locale_keys.g.dart';
import '../blocs/booking/booking_cubit.dart';
import 'select_patient_dialog.dart';

class BookingRegisteredFields extends StatelessWidget {
  const BookingRegisteredFields({
    super.key,
    required this.onSelectedPatient,
  });

  final Function(ProfileModel patient) onSelectedPatient;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // final locale = Locale.of(context).languageCode;

    final locale = context.locale;

    return InkWell(
      onTap: () => _onTap(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: colorScheme.surface.withOpacity(0.5),
          border: Border.all(
            color: colorScheme.onSurface.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              minimumSize: Size(150, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon: locale.languageCode == 'ar'
                ? Icon(
                    HugeIcons.strokeRoundedArrowLeft01,
                  )
                : Icon(
                    HugeIcons.strokeRoundedArrowRight01,
                  ),
            label: Text(
              LocaleKeys.choose_patient_name.trnsltd,
              style: textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
            onPressed: () => _onTap(context),
          ),
        ),
      ),
    );
  }

  _onTap(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<BookingCubit>(),
        child: const SelectPatientDialog(),
      ),
    );

    if (result != null && result is ProfileModel) {
      onSelectedPatient(result);
    }
  }
}
