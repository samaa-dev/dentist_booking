import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/booking/widget/booking_guest_fields.dart'
    show BookingGuestFields;
import 'package:dentist_booking_admin/features/booking/widget/booking_registered_fields.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/model/profile_model.dart';
import 'booking_cancel_reason_field.dart';

class BookingRightColumn extends StatelessWidget {
  final bool isGuest;
  final String? status;
  final ProfileModel? selectedPatient;
  final TextEditingController fullNameCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController cancelReasonCtrl;

  final Function(ProfileModel) onSelectPatient;
  final VoidCallback onResetPatient;

  final bool isEditable;

  const BookingRightColumn({
    super.key,
    required this.isGuest,
    required this.status,
    required this.fullNameCtrl,
    required this.addressCtrl,
    required this.phoneCtrl,
    required this.cancelReasonCtrl,
    required this.selectedPatient,
    required this.onSelectPatient,
    required this.onResetPatient,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Column(
        key: ValueKey(isGuest.toString() + status.toString()),
        children: [
          isGuest
              ? BookingGuestFields(
                  fullName: fullNameCtrl,
                  address: addressCtrl,
                  phone: phoneCtrl,
                )
              : selectedPatient == null
              ? BookingRegisteredFields(
                  onSelectedPatient: onSelectPatient,
                )
              : SelectedPatientCard(
                  isEditable: isEditable,
                  patient: selectedPatient!,
                  onReset: onResetPatient,
                ),

          if (status == LocaleKeys.status_cancelledByPatient.trnsltd ||
              status == LocaleKeys.status_cancelledByStaff.trnsltd)
            const SizedBox(height: 10),

          if (status == LocaleKeys.status_cancelledByPatient.trnsltd ||
              status == LocaleKeys.status_cancelledByStaff.trnsltd)
            BookingCancelReasonField(controller: cancelReasonCtrl),
        ],
      ),
    );
  }
}

class SelectedPatientCard extends StatelessWidget {
  final ProfileModel patient;
  final VoidCallback onReset;
  final bool isEditable;

  const SelectedPatientCard({
    super.key,
    required this.patient,
    required this.onReset,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final meta = patient.meta["raw_user_meta_data"] ?? {};

    final fullName =
        meta['full_name'] ?? meta['name'] ?? LocaleKeys.unknown_name.trnsltd;

    final phone = (meta['phone'] == null || meta['phone'].toString().isEmpty)
        ? LocaleKeys.unknown_phone.trnsltd
        : meta['phone'];

    final address =
        (meta['address'] == null || meta['address'].toString().isEmpty)
        ? "-"
        : meta["address"];

    return Container(
      key: const ValueKey("selected_patient"),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.surface.withOpacity(0.5),
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(0.3),
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: colorScheme.primary.withOpacity(0.2),
                child: Icon(
                  HugeIcons.strokeRoundedUser02,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      phone,
                      style: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    if (address.isNotEmpty)
                      Text(
                        address,
                        style: textTheme.bodySmall!.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                minimumSize: Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                disabledBackgroundColor: colorScheme.primary.withOpacity(0.5),
                disabledForegroundColor: colorScheme.onPrimary.withOpacity(0.5),
              ),
              icon: const Icon(HugeIcons.strokeRoundedRefresh),
              label: Text(
                LocaleKeys.change_patient.trnsltd,
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),

              onPressed: !isEditable ? null : onReset,
            ),
          ),
        ],
      ),
    );
  }
}
