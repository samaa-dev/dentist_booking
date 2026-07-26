import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/features/settings/blocs/settings/settings_cubit.dart';
import 'package:dentist_booking_admin_app/generated/locale_keys.g.dart';
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
    final enabled = cubit.showResetButton;

    final disabledBg = colorScheme.surfaceContainerHighest;
    final disabledFg = colorScheme.onSurface.withOpacity(0.38);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                disabledBackgroundColor: disabledBg,
                disabledForegroundColor: disabledFg,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: const Icon(HugeIcons.strokeRoundedCheckmarkCircle01),
              label: Text(
                LocaleKeys.save_settings.trnsltd,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: enabled
                  ? () => _onSavePressed(context, settings: cubit)
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
                disabledBackgroundColor: disabledBg,
                disabledForegroundColor: disabledFg,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: const Icon(HugeIcons.strokeRoundedResetPassword),
              label: Text(
                LocaleKeys.reset_settings.trnsltd,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: enabled
                  ? () => _onResetPressed(context, settings: cubit)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  void _onResetPressed(
    BuildContext context, {
    required SettingsCubit settings,
  }) {
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

  void _onSavePressed(
    BuildContext context, {
    required SettingsCubit settings,
  }) {
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
