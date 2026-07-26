import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/core/l10n/algerian_months.dart';
import 'package:dentist_booking_admin/core/l10n/latin_digits.dart';
import 'package:dentist_booking_admin/core/widgets/choose_theme_dialog.dart';
import 'package:dentist_booking_admin/features/queue/blocs/queue/queue_cubit.dart';
import 'package:dentist_booking_admin/features/queue/queue.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../app_setup.dart';
import '../blocs/theme/theme_cubit.dart';
import 'app_version_text.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final now = DateTime.now();
    final locale = Localizations.localeOf(context);
    final String dateText;
    if (locale.languageCode == 'ar') {
      const weekdays = [
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد',
      ];
      dateText = toLatinDigits(
        '${weekdays[now.weekday - 1]}، ${now.day} ${AlgerianMonths.nameOf(now.month)} ${now.year}',
      );
    } else {
      dateText = toLatinDigits(
        DateFormat.yMMMMEEEEd(locale.toString()).format(now),
      );
    }

    final size = MediaQuery.of(context).size;

    // Responsive height
    double bannerHeight = size.height * 0.18;
    if (bannerHeight < 110) bannerHeight = 110;
    if (bannerHeight > 160) bannerHeight = 160;

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 5),
      child: Container(
        height: bannerHeight,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withOpacity(.15),
              colorScheme.primary.withOpacity(0.3),
            ],

            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.05),
            width: 1.2,
          ),

          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(.20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                HugeIcons.strokeRoundedDentalTooth,
                size: 35,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.welcome_no_name.trnsltd,
                    maxLines: 1,
                    textWidthBasis: TextWidthBasis.parent,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dateText,
                    maxLines: 1,
                    textWidthBasis: TextWidthBasis.parent,

                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(.8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    maxLines: 1,
                    textWidthBasis: TextWidthBasis.parent,
                    LocaleKeys.welcome_message.trnsltd,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(.6),
                    ),
                  ),
                  SizedBox(height: 6),
                  AppVersionText(),
                ],
              ),
            ),
            const SizedBox(width: 10),

            SizedBox(
              width: context.mediaQuery.width * 0.25,
              height: 120,
              child: BlocProvider<QueueCubit>(
                create: (context) => getIt<QueueCubit>()..loadStatus(),
                child: QueueCardPro(),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildThemeToggle(context),
                const SizedBox(height: 5),
                _buildLanguageToggle(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildLanguageToggle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(.2),
        shape: BoxShape.circle,
      ),
      child: IconButton.filledTonal(
        icon: const Icon(HugeIcons.strokeRoundedEarth),
        color: colorScheme.primary,
        onPressed: () {
          if (locale.languageCode == 'ar') {
            context.setLocale(const Locale('en'));
          } else {
            context.setLocale(const Locale('ar', 'DZ'));
          }
        },
      ),
    );
  }

  _buildThemeToggle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(.2),
        shape: BoxShape.circle,
      ),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final isDark = state.mode == AppMode.dark;
          return IconButton.filledTonal(
            icon: isDark
                ? const Icon(HugeIcons.strokeRoundedMoon02)
                : const Icon(HugeIcons.strokeRoundedSun01),
            color: colorScheme.primary,
            onPressed: () => context.read<ThemeCubit>().toggleMode(),
            onLongPress: () => showDialog(
              context: context,
              builder: (_) => ChooseThemesDialog(),
            ),
          );
        },
      ),
    );
  }
}
