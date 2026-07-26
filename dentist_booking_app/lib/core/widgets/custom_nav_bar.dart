import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../generated/locale_keys.g.dart';
import '../blocs/pages/pages_cubit.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key, required this.onItemSelected});

  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget buildItemIcon(String iconPath, {double size = 25}) {
      return WebsafeSvg.asset(
        iconPath,
        height: size,
        colorFilter: ColorFilter.mode(
          colorScheme.secondary,
          BlendMode.srcIn,
        ),
      );
    }

    return BlocBuilder<PagesCubit, PagesState>(
      builder: (context, state) {
        final selectedIndex = state.maybeWhen(
          changed: (currentPageIndex, _) => currentPageIndex,
          orElse: () => 0,
        );

        return NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: selectedIndex,
          onDestinationSelected: onItemSelected,
          animationDuration: const Duration(milliseconds: 300),
          destinations: [
            NavigationDestination(
              tooltip: '',
              icon: buildItemIcon('assets/svgs/home-off.svg'),
              selectedIcon: buildItemIcon('assets/svgs/home.svg'),
              label: LocaleKeys.navigation_bar_home.trnsltd,
            ),
            NavigationDestination(
              tooltip: '',
              icon: buildItemIcon('assets/svgs/booking-off.svg'),
              selectedIcon: buildItemIcon('assets/svgs/booking.svg'),
              label: LocaleKeys.navigation_bar_booking.trnsltd,
            ),
            NavigationDestination(
              tooltip: '',
              icon: buildItemIcon('assets/svgs/tracking-off.svg', size: 23),
              selectedIcon: buildItemIcon('assets/svgs/tracking.svg'),
              label: LocaleKeys.navigation_bar_booking_tracking.trnsltd,
            ),
            NavigationDestination(
              tooltip: '',
              icon: buildItemIcon('assets/svgs/profile-off.svg'),
              selectedIcon: buildItemIcon('assets/svgs/profile.svg'),
              label: LocaleKeys.navigation_bar_profile.trnsltd,
            ),
          ],
        );
      },
    );
  }
}
