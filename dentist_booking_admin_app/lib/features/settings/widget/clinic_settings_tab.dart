import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/core/widgets/custom_text_form_field.dart';
import 'package:dentist_booking_admin_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../blocs/settings/settings_cubit.dart' show SettingsCubit;
import 'custom_switch.dart';
import 'number_stepper_field.dart';
import 'row_input.dart';
import 'settings_card_pro.dart';
import 'small_time_button.dart';

class ClinicSettingsTab extends StatelessWidget {
  const ClinicSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SettingsCardPro(
            title: LocaleKeys.BookingLimits.trnsltd,
            icon: HugeIcons.strokeRoundedListView,
            child: Column(
              children: [
                RowInput(
                  label: LocaleKeys.morningLimit.trnsltd,
                  icon: HugeIcons.strokeRoundedSun03,
                  input: NumberStepperField(
                    key: ValueKey(cubit.morningLimitTMP),
                    value: cubit.morningLimitTMP,
                    onChanged: cubit.updateMorningLimit,
                  ),
                ),

                RowInput(
                  label: LocaleKeys.eveningLimit.trnsltd,
                  icon: HugeIcons.strokeRoundedMoon01,
                  input: NumberStepperField(
                    key: ValueKey(cubit.eveningLimitTMP),
                    value: cubit.eveningLimitTMP,
                    onChanged: cubit.updateEveningLimit,
                  ),
                ),
              ],
            ),
          ),

          // -------- Booking Control --------
          SettingsCardPro(
            title: LocaleKeys.bookingControl.trnsltd,
            icon: HugeIcons.strokeRoundedSettings05,
            child: Column(
              children: [
                RowInput(
                  label: LocaleKeys.bookingEnabled.trnsltd,
                  icon: HugeIcons.strokeRoundedToggleOn,
                  input: CustomSwitch(
                    label: "",
                    value: cubit.bookingEnabledTMP,
                    onChanged: cubit.updateBookingEnabled,
                  ),
                ),

                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOut,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, -0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: cubit.bookingEnabledTMP
                      ? SizedBox.shrink(key: ValueKey("hidden"))
                      : Container(
                          key: ValueKey("stop_reason_box"),
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title Row
                              Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.amber[800],
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    LocaleKeys.stopReason_title.trnsltd,
                                    style: TextStyle(
                                      color: Colors.amber[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10),

                              CustomTextFormField(
                                keyboardType: TextInputType.text,
                                hintText: LocaleKeys.stopReason.trnsltd,
                                controller: cubit.stopReasonController,
                                onChanged: cubit.updateStopReason,
                              ),
                            ],
                          ),
                        ),
                ),

                RowInput(
                  label: LocaleKeys.autoConfirm.trnsltd,
                  icon: HugeIcons.strokeRoundedCheckmarkCircle04,
                  input: CustomSwitch(
                    label: "",
                    value: cubit.autoConfirmTMP,
                    onChanged: cubit.updateAutoConfirm,
                  ),
                ),

                RowInput(
                  label: LocaleKeys.bookingStartTime.trnsltd,
                  icon: Icons.access_time,
                  input: SmallTimeButton(
                    value: cubit.bookingStartTMP,
                    onChanged: cubit.updateBookingStart,
                  ),
                ),

                RowInput(
                  label: LocaleKeys.allowBeforeMinutes.trnsltd,
                  icon: HugeIcons.strokeRoundedTimer01,
                  input: NumberStepperField(
                    key: ValueKey(cubit.allowBeforeTMP),
                    value: cubit.allowBeforeTMP,
                    onChanged: cubit.updateAllowBefore,
                  ),
                ),

                RowInput(
                  label: LocaleKeys.clinic_phone.trnsltd,
                  icon: HugeIcons.strokeRoundedCall02,
                  input: CustomTextFormField(
                    keyboardType: TextInputType.phone,
                    hintText: LocaleKeys.clinic_phone.trnsltd,
                    controller: cubit.clinicPhoneController,
                    onChanged: cubit.updateClinicPhone,
                  ),
                ),
              ],
            ),
          ),

          SettingsCardPro(
            title: LocaleKeys.min_version_section_title.trnsltd,
            icon: Icons.system_update_alt_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.min_version_section_hint.trnsltd,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(
                      0.65,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                RowInput(
                  label: LocaleKeys.min_version_patient.trnsltd,
                  icon: Icons.person_outline_rounded,
                  input: CustomTextFormField(
                    keyboardType: TextInputType.text,
                    hintText: LocaleKeys.min_version_hint.trnsltd,
                    controller: cubit.minVersionPatientController,
                    onChanged: cubit.updateMinVersionPatient,
                  ),
                ),
                RowInput(
                  label: LocaleKeys.min_version_admin.trnsltd,
                  icon: Icons.smartphone_rounded,
                  input: CustomTextFormField(
                    keyboardType: TextInputType.text,
                    hintText: LocaleKeys.min_version_hint.trnsltd,
                    controller: cubit.minVersionAdminController,
                    onChanged: cubit.updateMinVersionAdmin,
                  ),
                ),
                RowInput(
                  label: LocaleKeys.min_version_desktop.trnsltd,
                  icon: Icons.computer_rounded,
                  input: CustomTextFormField(
                    keyboardType: TextInputType.text,
                    hintText: LocaleKeys.min_version_hint.trnsltd,
                    controller: cubit.minVersionDesktopController,
                    onChanged: cubit.updateMinVersionDesktop,
                  ),
                ),
                RowInput(
                  label: LocaleKeys.min_version_tv.trnsltd,
                  icon: Icons.tv_rounded,
                  input: CustomTextFormField(
                    keyboardType: TextInputType.text,
                    hintText: LocaleKeys.min_version_hint.trnsltd,
                    controller: cubit.minVersionTvController,
                    onChanged: cubit.updateMinVersionTv,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
