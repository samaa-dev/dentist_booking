import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/settings/blocs/settings/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_setup.dart';
import '../../../core/util/util.dart';
import '../../../core/widgets/loading_dialog.dart';
import '../../../generated/locale_keys.g.dart';
import '../../staff/widget/error_staff.dart';
import '../widget/settings_content.dart';
import '../widget/settings_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (context) => getIt<SettingsCubit>()..init(),
      child: BlocConsumer<SettingsCubit, SettingsState>(
        listenWhen: (previous, current) {
          return current.maybeWhen(
            orElse: () => false,
            error: (_) => true,
            errorUpdateSetting: (_) => true,
            successUpdateSetting: (_) => true,
            loadingSetting: () => true,
          );
        },
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            loadingSetting: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => LoadingDialog(),
              );
            },

            successUpdateSetting: (_) {
              if (Navigator.canPop(context)) Navigator.pop(context);

              SnackbarMes.showToastMsg(
                context,
                message: LocaleKeys.settings_success_update.trnsltd,
              );
            },

            errorUpdateSetting: (message) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              SnackbarMes.showToastMsg(context, message: message);
            },

            error: (message) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              SnackbarMes.showToastMsg(context, message: message);
            },
          );
        },

        builder: (context, state) {
          return _SettingsLayout();
        },
      ),
    );
  }
}

class _SettingsLayout extends StatelessWidget {
  const _SettingsLayout();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) {
        return current.maybeWhen(
          orElse: () => false,
          loading: () => true,
          loaded: (_) => true,
          error: (_) => true,
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => Center(
            child: CircularProgressIndicator(
              color: colorScheme.primary,
            ),
          ),

          loaded: (settings) {
            return Column(
              children: [
                SettingsHeader(),
                const SizedBox(height: 20),
                Expanded(
                  child: SettingsContent(
                    settings: settings,
                  ),
                ),
              ],
            );
          },

          error: (message) => ErrorStaff(message: message),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
