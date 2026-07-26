import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/blocs/theme/theme_cubit.dart';
import '../../../core/util/info_snackbar.dart';
import '../../../core/widgets/section_heading.dart';
import '../../../generated/locale_keys.g.dart';

onLanguageTap(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  final supportedLocales = context.supportedLocales;
  final currentLocale = context.locale;

  SnackbarMes.showCustomBottomSheet(
    context: context,
    isExpanded: false,
    child: SizedBox(
      height: context.mediaQuery.height * 0.23,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitleHeading(
            title: LocaleKeys.choose_language.trnsltd,
            description: LocaleKeys.choose_language_subtitle.trnsltd,
          ),
          const SizedBox(height: 12),
          ...supportedLocales.map((Locale locale) {
            final isSelected = locale == currentLocale;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListTile(
                selected: isSelected,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                minTileHeight: 48,
                title: Text(
                  _getLocaleName(locale),
                  style: textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? colorScheme.primary
                        : textTheme.bodyMedium?.color,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: colorScheme.primary,
                      )
                    : null,
                onTap: () async {
                  await EasyLocalization.of(context)!.setLocale(locale);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
              ),
            );
          }),
        ],
      ),
    ),
  );
}

String _getLocaleName(Locale locale) {
  switch (locale.languageCode) {
    case 'ar':
      return 'العربية';
    case 'en':
      return 'English';
    case 'fr':
      return 'Français';
    default:
      return locale.languageCode;
  }
}

void onThemeTap(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final currentTheme = context.read<ThemeCubit>().state.theme;

  SnackbarMes.showCustomBottomSheet(
    context: context,
    isExpanded: false,
    child: SizedBox(
      height: context.mediaQuery.height * 0.18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitleHeading(
            title: LocaleKeys.choose_primary_color.trnsltd,
            description: LocaleKeys.select_preferred_app_color.trnsltd,
          ),
          const SizedBox(height: 20),
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
                        ? Icon(Icons.check, color: colorScheme.onPrimary)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}
