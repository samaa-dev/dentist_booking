import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/core/widgets/dialog_title_header.dart'
    show DialogTitleHeader;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../generated/locale_keys.g.dart';
import '../blocs/theme/theme_cubit.dart';

class ChooseThemesDialog extends StatelessWidget {
  const ChooseThemesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.read<ThemeCubit>().state.theme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogTitleHeader(
              title: LocaleKeys.booking_theme_title.trnsltd,
              subtitle: LocaleKeys.booking_theme_subtitle.trnsltd,
            ),

            const SizedBox(height: 12),

            Center(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: AppTheme.values.map((theme) {
                  final isSelected = theme == currentTheme;

                  return GestureDetector(
                    onTap: () {
                      context.read<ThemeCubit>().setTheme(theme);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.seedColor,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3,
                              )
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
