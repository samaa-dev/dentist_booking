import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/features/settings/blocs/settings/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/app_setup.dart';
import '../../../core/util/util.dart';
import '../../../core/widgets/header_background.dart';
import '../../../core/widgets/loading_dialog.dart';
import '../../../generated/locale_keys.g.dart';
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
                builder: (_) => const LoadingDialog(),
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
          return const _SettingsLayout();
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          const HeaderBackground(height: 140),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedSettings01,
                        color: colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        LocaleKeys.Settings.trnsltd,
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<SettingsCubit, SettingsState>(
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
                              const SettingsHeader(),
                              const SizedBox(height: 8),
                              Expanded(
                                child: SettingsContent(settings: settings),
                              ),
                            ],
                          );
                        },
                        error: (message) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(message, textAlign: TextAlign.center),
                                const SizedBox(height: 12),
                                FilledButton(
                                  onPressed: () =>
                                      context.read<SettingsCubit>().init(),
                                  child: Text(LocaleKeys.retry.trnsltd),
                                ),
                              ],
                            ),
                          ),
                        ),
                        orElse: () => const SizedBox.shrink(),
                      );
                    },
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
