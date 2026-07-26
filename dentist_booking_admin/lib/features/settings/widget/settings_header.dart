import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/settings/blocs/settings/settings_cubit.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/util/util.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final cubit = context.watch<SettingsCubit>();
    final settings = cubit;

    return Row(
      children: [
        Text(
          LocaleKeys.settings_management.trnsltd,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const Spacer(),
        Row(
          children: [
            Column(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(HugeIcons.strokeRoundedCheckmarkCircle01),
                  label: Text(
                    LocaleKeys.save_settings.trnsltd,
                  ),
                  onPressed: cubit.showResetButton
                      ? () => _onSavePressed(context, settings: settings)
                      : null,
                ),
              ],
            ),
          ],
        ),
        SizedBox(width: 10),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.secondary,
            foregroundColor: colorScheme.onSecondary,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(HugeIcons.strokeRoundedResetPassword),
          label: Text(
            LocaleKeys.reset_settings.trnsltd,
          ),
          onPressed: cubit.showResetButton
              ? () => _onResetPressed(context, settings: settings)
              : null,
        ),
      ],
    );
  }

  _onResetPressed(BuildContext context, {required SettingsCubit settings}) {
    SnackbarMes.showCustomDialog(
      context,
      title: LocaleKeys.reset_settings.trnsltd,
      content: LocaleKeys.reset_settings_confirm.trnsltd,
      buttonCancelText: LocaleKeys.cancel_button.trnsltd,
      buttonConfirmText: LocaleKeys.reset_button.trnsltd,
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () {
        settings.resetSettings();
        Navigator.of(context).pop();
      },
    );
  }

  _onSavePressed(BuildContext context, {required SettingsCubit settings}) {
    SnackbarMes.showCustomDialog(
      context,
      title: LocaleKeys.save_settings_title.trnsltd,
      content: LocaleKeys.save_settings_confirm.trnsltd,
      buttonCancelText: LocaleKeys.cancel_button.trnsltd,
      buttonConfirmText: LocaleKeys.save_button.trnsltd,
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () {
        settings.saveSettings(context);
        Navigator.of(context).pop();
      },
    );
  }
}
