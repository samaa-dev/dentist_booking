import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/widgets/custom_text_form_field.dart';

class BookingGuestFields extends StatelessWidget {
  final TextEditingController fullName;
  final TextEditingController address;
  final TextEditingController phone;

  const BookingGuestFields({
    super.key,
    required this.fullName,
    required this.address,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 185,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.surface.withOpacity(0.5),
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          CustomTextFormField(
            controller: fullName,
            hintText: LocaleKeys.patient_full_name.trnsltd,
            prefixIcon: const Icon(HugeIcons.strokeRoundedPen01),
            keyboardType: TextInputType.text,
          ),

          const SizedBox(height: 10),
          CustomTextFormField(
            controller: address,
            hintText: LocaleKeys.booking_address.trnsltd,
            prefixIcon: const Icon(HugeIcons.strokeRoundedCity01),
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            controller: phone,
            keyboardType: TextInputType.phone,
            hintText: LocaleKeys.booking_phone.trnsltd,
            prefixIcon: const Icon(HugeIcons.strokeRoundedSmartPhone01),
          ),
        ],
      ),
    );
  }
}
