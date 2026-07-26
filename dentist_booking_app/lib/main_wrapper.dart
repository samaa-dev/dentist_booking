import 'dart:async';

import 'package:dentist_booking_app/core/app_setup.dart';
import 'package:dentist_booking_app/core/enum/enum.dart';
import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/features/auth/blocs/auth/auth_cubit.dart';
import 'package:dentist_booking_app/features/booking/blocs/booking/booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'core/blocs/pages/pages_cubit.dart';
import 'core/util/util.dart';
import 'core/widgets/custom_nav_bar.dart';
import 'core/widgets/guest_restriction_view.dart';
import 'features/booking/screens/booking_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/queue/screens/queue_screen.dart';
import 'generated/locale_keys.g.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PagesCubit>(
      create: (_) => getIt<PagesCubit>(),
      child: const _MainWrapperLayout(),
    );
  }
}

class _MainWrapperLayout extends StatefulWidget {
  const _MainWrapperLayout();

  @override
  State<_MainWrapperLayout> createState() => _MainWrapperLayoutState();
}

class _MainWrapperLayoutState extends State<_MainWrapperLayout> with WidgetsBindingObserver {
  StreamSubscription<InternetStatus>? _internetSubscription;

  DateTime? _lastBackPressTime;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthCubit>().state;
    final bool isGuest = authState is Status && authState.typeLogin == TypeLogin.guest;

    _pages = [
      const HomeScreen(),

      isGuest
          ? GuestRestrictionView(
              message: LocaleKeys.guest_booking_restriction.trnsltd,
              icon: HugeIcons.strokeRoundedUserStatus,
            )
          : BlocProvider<BookingCubit>(
              create: (context) => getIt<BookingCubit>(),
              child: const BookingScreen(),
            ),

      const QueueScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        bottomNavigationBar: CustomNavBar(
          onItemSelected: (currentPageIndex) {
            context.read<PagesCubit>().updatePage(
              currentPageIndex: currentPageIndex,
            );
          },
        ),
        body: BlocBuilder<PagesCubit, PagesState>(
          builder: (context, state) {
            final index = state.maybeWhen(
              changed: (currentPageIndex, data) => currentPageIndex,
              orElse: () => 0,
            );

            return Stack(
              children: [
                _pages[index],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final currentIndex = context.read<PagesCubit>().state.maybeWhen(
      changed: (currentPageIndex, data) => currentPageIndex,
      orElse: () => 0,
    );

    if (currentIndex != 0) {
      context.read<PagesCubit>().updatePage(currentPageIndex: 0);
      return false;
    }

    final now = DateTime.now();
    if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 3)) {
      _lastBackPressTime = now;

      SnackbarMes.showToastMsg(
        context,
        message: LocaleKeys.press_again_to_exit.trnsltd,
      );
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _internetSubscription?.cancel();
    super.dispose();
  }
}
