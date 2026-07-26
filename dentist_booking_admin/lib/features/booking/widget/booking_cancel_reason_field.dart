import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/widgets/custom_text_form_field.dart';
import '../../../generated/locale_keys.g.dart';

class BookingCancelReasonField extends StatelessWidget {
  final TextEditingController controller;

  const BookingCancelReasonField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(0.3),
          width: 0.5,
        ),

        borderRadius: BorderRadius.circular(22),
      ),
      child: CustomTextFormField(
        controller: controller,
        maxLines: 2,
        hintText: LocaleKeys.booking_cancel_reason.trnsltd,
        prefixIcon: const Icon(HugeIcons.strokeRoundedMessageCancel02),
        keyboardType: TextInputType.text,
      ),
    );
  }
}
