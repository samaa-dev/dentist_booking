import 'package:dentist_booking_tv/core/app_setup.dart';
import 'package:dentist_booking_tv/core/version/app_version_utils.dart';
import 'package:dentist_booking_tv/core/version/version_gate.dart';
import 'package:dentist_booking_tv/features/display/blocs/tv_display_cubit.dart';
import 'package:dentist_booking_tv/features/display/screens/tv_display_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DentistBookingTvApp extends StatelessWidget {
  const DentistBookingTvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dentist Booking TV',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      locale: const Locale('ar'),
      home: VersionGate(
        appType: AppVersionTarget.tv,
        child: BlocProvider<TvDisplayCubit>(
          create: (_) => getIt<TvDisplayCubit>(),
          child: const TvDisplayScreen(),
        ),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
            child: child!,
          ),
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    const primaryColor = Color(0xFF1392EC);
    const surfaceColor = Color(0xFFF6F7F8);
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.notoSansArabic().fontFamily,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onSurface: const Color(0xFF1E293B),
        surfaceContainerHighest: const Color(0xFFF1F5F9),
      ),
    );
  }
}
