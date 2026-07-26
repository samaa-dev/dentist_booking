import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/booking/widget/booking_date_time_picker.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

import '../../../core/enum/enum.dart';
import '../../../core/widgets/custom_dropdown.dart';

class BookingLeftColumn extends StatelessWidget {
  final DateTime? selectedDateTime;
  final String? patientType;
  final String? shift;
  final String? status;

  final ValueChanged<DateTime> onDateChangedTime;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onShiftChanged;
  final ValueChanged<String> onStatusChanged;

  const BookingLeftColumn({
    super.key,
    required this.selectedDateTime,
    required this.patientType,
    required this.shift,
    required this.status,
    required this.onDateChangedTime,
    required this.onTypeChanged,
    required this.onShiftChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(
        //   width: double.infinity,
        //   child: BookingTimePicker(
        //     selectedTime: selectedTime,
        //     // onChanged: onTimeChanged,
        //   ),
        // ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: BookingDateTimePicker(
            selectedDateTime: selectedDateTime,
            onDateTimeChanged: onDateChangedTime,
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: CustomDropdown(
            value: patientType,
            enableSearch: false,
            hintText: LocaleKeys.booking_type.trnsltd,
            items: PatientType.values
                .map(
                  (e) => DropdownMenuItem(value: e.name, child: Text(e.name)),
                )
                .toList(),
            onChanged: (value) => onTypeChanged(value!),
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: CustomDropdown(
            value: shift,
            enableSearch: false,
            hintText: LocaleKeys.booking_shift.trnsltd,
            items: BookingShift.values
                .map(
                  (e) => DropdownMenuItem(value: e.name, child: Text(e.name)),
                )
                .toList(),
            onChanged: (value) => onShiftChanged(value!),
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: CustomDropdown(
            value: status,
            enableSearch: false,
            hintText: LocaleKeys.booking_status.trnsltd,
            items: BookingStatus.values
                .map(
                  (e) => DropdownMenuItem(value: e.name, child: Text(e.name)),
                )
                .toList(),
            onChanged: (value) => onStatusChanged(value!),
          ),
        ),
      ],
    );
  }
}
