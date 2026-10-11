import 'package:dentist_booking_admin_app/core/blocs/pages/pages_cubit.dart';
import 'package:dentist_booking_admin_app/core/enum/enum.dart';
import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin_app/features/booking/view/booking_screen.dart';
import 'package:dentist_booking_admin_app/features/home/view/home_screen.dart';
import 'package:dentist_booking_admin_app/features/profile/view/profile_screen.dart';
import 'package:dentist_booking_admin_app/features/settings/view/settings_screen.dart';
import 'package:dentist_booking_admin_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import 'core/access/access_cubit.dart';
import 'core/access/app_permission.dart';
import 'core/access/user_access.dart';
import 'core/app_setup.dart';
import 'features/auth/blocs/auth/auth_cubit.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({
    super.key,
    required this.userRole,
  });

  final UserRole userRole;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<PagesCubit>()),
        BlocProvider.value(value: context.read<AuthCubit>()),
        BlocProvider(
          create: (_) => getIt<AccessCubit>()..load(fallbackRole: userRole),
        ),
      ],
      child: BlocBuilder<AccessCubit, AccessState>(
        builder: (context, state) => switch (state) {
          AccessLoading() => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          _ => _MainShell(access: context.read<AccessCubit>().access),
        },
      ),
    );
  }
}

class _MainShell extends StatelessWidget {
  const _MainShell({required this.access});

  final UserAccess access;

  @override
  Widget build(BuildContext context) {
    final canQueue = access.can(AppPermission.queue);
    final canBookings = access.can(AppPermission.bookings);
    final canSettings = access.can(AppPermission.settings);

    final pages = <Widget>[
      if (canQueue) const HomeScreen(),
      if (canBookings) const BookingScreen(),
      if (canSettings) const SettingsScreen(),
      const ProfileScreen(),
    ];

    final destinations = <NavigationDestination>[
      if (canQueue)
        NavigationDestination(
          icon: const Icon(HugeIcons.strokeRoundedDashboardCircle),
          label: LocaleKeys.Dashboard.trnsltd,
        ),
      if (canBookings)
        NavigationDestination(
          icon: const Icon(HugeIcons.strokeRoundedAddToList),
          label: LocaleKeys.Reservations.trnsltd,
        ),
      if (canSettings)
        NavigationDestination(
          icon: const Icon(HugeIcons.strokeRoundedSettings01),
          label: LocaleKeys.Settings.trnsltd,
        ),
      NavigationDestination(
        icon: const Icon(HugeIcons.strokeRoundedUserCircle),
        label: LocaleKeys.Profile.trnsltd,
      ),
    ];

    return BlocBuilder<PagesCubit, int>(
      builder: (context, index) {
        final safeIndex = index.clamp(0, pages.length - 1);

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            if (safeIndex != 0) {
              context.read<PagesCubit>().setPage(0);
              return;
            }
            final shouldExit = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(LocaleKeys.SignOutTitle.trnsltd),
                content: const Text('Exit app?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(LocaleKeys.CancelButton.trnsltd),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            if (shouldExit == true) {
              SystemNavigator.pop();
            }
          },
          child: Scaffold(
            body: IndexedStack(
              index: safeIndex,
              children: pages,
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: safeIndex,
              onDestinationSelected: (i) =>
                  context.read<PagesCubit>().setPage(i),
              destinations: destinations,
            ),
          ),
        );
      },
    );
  }
}
