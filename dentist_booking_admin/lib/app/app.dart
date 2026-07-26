import 'package:dentist_booking_admin/core/app_setup.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/blocs/theme/theme_cubit.dart';
import '../core/l10n/dz_material_localizations.dart';
import '../core/routes/app_route.dart';
import '../core/version/app_version_utils.dart';
import '../core/version/version_gate.dart';
import '../features/auth/auth.dart';

class DentistBookingAdmin extends StatelessWidget {
  const DentistBookingAdmin({super.key, required AppRouter appRouter})
    : _appRouter = appRouter;

  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (_) => getIt<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Dentist Booking Admin',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: _appRouter.generateRoute,
            localizationsDelegates: [
              const DzMaterialLocalizationsDelegate(),
              ...context.localizationDelegates,
            ],
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            themeMode: state.themeMode,
            theme: _buildLightTheme(state.seedColor),
            darkTheme: _buildDarkTheme(state.seedColor),

            home: const VersionGate(
              appType: AppVersionTarget.desktop,
              child: Auth(),
            ),

            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme(Color color) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        brightness: Brightness.light,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme(Color color) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        brightness: Brightness.dark,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
