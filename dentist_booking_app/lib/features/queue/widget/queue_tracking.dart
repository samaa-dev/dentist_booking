import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/core/widgets/custom_filled_button.dart';
import 'package:dentist_booking_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/widgets/custom_text_form_field.dart';

class QueueTracking extends StatefulWidget {
  const QueueTracking({
    super.key,
    required this.onTrackPressed,
  });

  final Function(String ticketCode) onTrackPressed;

  @override
  State<QueueTracking> createState() => _QueueTrackingState();
}

class _QueueTrackingState extends State<QueueTracking> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controllerTracking = TextEditingController();
  bool _isValid = false;

  void _validateForm() {
    setState(() {
      _isValid = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOut,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, (1 - value) * 20),
        child: Opacity(opacity: value, child: child),
      ),
      child: Form(
        key: _formKey, // إضافة Form هنا
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.surface,
                colorScheme.surface.withOpacity(0.96),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.10),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    LocaleKeys.queue_title.trnsltd,
                    style: textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                LocaleKeys.queue_subtitle.trnsltd,
                style: textTheme.bodySmall!.copyWith(
                  color: colorScheme.outline,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                keyboardType: TextInputType.number,
                controller: controllerTracking,
                suffixIcon: const Icon(HugeIcons.strokeRoundedQrCode),
                hintText: "5123",
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.please_enter_ticket_number.trnsltd;
                  }

                  final regex = RegExp(r'^TIC-\d{4}$');
                  if (!regex.hasMatch(value)) {
                    if (value.length != 4 ||
                        !RegExp(r'^\d{4}$').hasMatch(value)) {
                      return LocaleKeys.ticket_must_be_4_digits.trnsltd;
                    }
                  }

                  return null;
                },
                onChanged: (value) {
                  _validateForm();

                  if (value.length == 4 && RegExp(r'^\d{4}$').hasMatch(value)) {
                    Future.microtask(() {
                      controllerTracking.text = "TIC-$value";
                      controllerTracking.selection = TextSelection.fromPosition(
                        TextPosition(offset: controllerTracking.text.length),
                      );
                      _validateForm();
                    });
                  }
                },
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: CustomFilledButton(
                  onPressed: _isValid
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            widget.onTrackPressed(
                              controllerTracking.text,
                            );
                          }
                        }
                      : null,
                  icon: const Icon(HugeIcons.strokeRoundedSearch01),
                  text: LocaleKeys.track_now.trnsltd,
                  textColor: _isValid
                      ? colorScheme.onPrimary
                      : colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
