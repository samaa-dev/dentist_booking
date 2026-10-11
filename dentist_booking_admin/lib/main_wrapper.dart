import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/booking/view/booking_screen.dart';
import 'package:dentist_booking_admin/features/patient/view/patient_screen.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sidebarx/sidebarx.dart';

import 'core/util/util.dart';
import 'core/widgets/welcome_banner.dart';
import 'features/announcement/announcement.dart';
import 'features/auth/blocs/auth/auth_cubit.dart';
import 'core/access/access_cubit.dart';
import 'core/access/app_permission.dart';
import 'core/access/user_access.dart';
import 'core/app_setup.dart';
import 'features/statistics/view/statistics_screen.dart';
import 'features/settings/settings.dart';
import 'features/staff/staff.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final SidebarXController _controller = SidebarXController(
    selectedIndex: 0,
    extended: false,
  );

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final userRole = authState is Status ? authState.userRole : null;

    return BlocProvider<AccessCubit>(
      create: (_) => getIt<AccessCubit>()..load(fallbackRole: userRole),
      child: BlocBuilder<AccessCubit, AccessState>(
        builder: (context, accessState) {
          final access = context.read<AccessCubit>().access;
          final pages = _pagesFor(access);
          if (_controller.selectedIndex >= pages.length && pages.isNotEmpty) {
            _controller.selectIndex(0);
          }
          return _buildShell(context, accessState, access, pages);
        },
      ),
    );
  }

  Widget _buildShell(
    BuildContext context,
    AccessState accessState,
    UserAccess access,
    List<_NavPage> pages,
  ) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: buildSidebar(context, pages: pages),
          ),
          Expanded(
            child: Column(
              children: [
                WelcomeBanner(),
                _contanierView(accessState, access, pages),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contanierView(
    AccessState accessState,
    UserAccess access,
    List<_NavPage> pages,
  ) {
    return Flexible(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final colorScheme = Theme.of(context).colorScheme;

          return Padding(
            padding: const EdgeInsets.only(
              right: 10,
              bottom: 10,
              left: 10,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
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
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(24),

                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.05, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _pageBody(accessState, access, pages),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSidebar(BuildContext context, {required List<_NavPage> pages}) {
    final colorScheme = Theme.of(context).colorScheme;

    return SidebarX(
      controller: _controller,
      theme: sidebarTheme(context),
      animationDuration: Duration(milliseconds: 250),
      extendedTheme: sidebarExtendedTheme(context),
      collapseIcon: HugeIcons.strokeRoundedArrowRight01,
      extendIcon: HugeIcons.strokeRoundedArrowLeft01,
      headerBuilder: (context, extended) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              CircleAvatar(
                radius: extended ? 32 : 26,
                backgroundColor: colorScheme.primary.withOpacity(.15),
                child: Icon(
                  HugeIcons.strokeRoundedDentalTooth,
                  size: extended ? 32 : 26,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      },
      footerBuilder: (context, extended) {
        final cs = Theme.of(context).colorScheme;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
          child: extended
              ? SizedBox(
                  width: 200, // مهم جداً لمنع الـ Overflow
                  child: InkWell(
                    onTap: () => _logout(),
                    borderRadius: BorderRadius.circular(36),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(.15),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max, // يأخذ كامل المساحة
                        mainAxisAlignment: MainAxisAlignment.center, // وسط
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedLogout01,
                            size: 20,
                            color: cs.primary,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              LocaleKeys.logout_button.trnsltd,
                              overflow: TextOverflow.ellipsis, // مهم جداً!
                              style: TextStyle(
                                color: cs.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(.15),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton.filled(
                    onPressed: () => _logout(),
                    icon: Icon(HugeIcons.strokeRoundedLogout01),
                  ),
                ),
        );
      },

      items: [
        for (final page in pages)
          SidebarXItem(icon: page.icon, label: page.label),
      ],
    );
  }

  /// Pages the signed-in account may open, in sidebar order.
  List<_NavPage> _pagesFor(UserAccess access) {
    return [
      if (access.can(AppPermission.statistics))
        _NavPage(
          HugeIcons.strokeRoundedChartLineData02,
          LocaleKeys.Statistics.trnsltd,
          () => const StatisticsScreen(),
        ),
      if (access.can(AppPermission.bookings))
        _NavPage(
          HugeIcons.strokeRoundedAddToList,
          LocaleKeys.Reservations.trnsltd,
          () => const BookingScreen(),
        ),
      if (access.can(AppPermission.announcements))
        _NavPage(
          HugeIcons.strokeRoundedAdvertisiment,
          LocaleKeys.Ads.trnsltd,
          () => AnnouncementScreen(),
        ),
      if (access.can(AppPermission.settings))
        _NavPage(
          HugeIcons.strokeRoundedSettings01,
          LocaleKeys.Settings.trnsltd,
          () => const SettingsScreen(),
        ),
      if (access.can(AppPermission.patients))
        _NavPage(
          HugeIcons.strokeRoundedUserGroup,
          LocaleKeys.AccountPatients.trnsltd,
          () => const PatientScreen(),
        ),
      if (access.canManageStaff)
        _NavPage(
          HugeIcons.strokeRoundedUserAccount,
          LocaleKeys.AccountEmployees.trnsltd,
          () => const StaffScreen(),
        ),
    ];
  }

  Widget _pageBody(
    AccessState accessState,
    UserAccess access,
    List<_NavPage> pages,
  ) {
    if (accessState is AccessLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (pages.isEmpty) {
      return _NoPagesView(
        key: const ValueKey('no-pages'),
        queueOnly: access.can(AppPermission.queue),
      );
    }
    final index = _controller.selectedIndex.clamp(0, pages.length - 1);
    return KeyedSubtree(
      key: ValueKey(pages[index].label),
      child: pages[index].builder(),
    );
  }

  SidebarXTheme sidebarTheme(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SidebarXTheme(
      width: 65,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(.15),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      itemPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      selectedItemPadding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 10,
      ),

      textStyle: TextStyle(
        color: colorScheme.onSurface.withOpacity(0.8),
        fontSize: 14,
      ),

      selectedTextStyle: TextStyle(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),

      iconTheme: IconThemeData(
        color: colorScheme.onSurface.withOpacity(0.8),
        size: 22,
      ),

      selectedIconTheme: IconThemeData(
        color: colorScheme.primary,
        size: 22,
      ),

      hoverColor: colorScheme.primary.withOpacity(.10),
      hoverIconTheme: IconThemeData(
        color: colorScheme.primary,
        size: 22,
      ),

      itemDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
      ),

      selectedItemDecoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(.15),
        borderRadius: BorderRadius.circular(36),
      ),
    );
  }

  SidebarXTheme sidebarExtendedTheme(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SidebarXTheme(
      width: 230,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        // color: cs.surface.withOpacity(0.9),
        color: colorScheme.primary.withOpacity(.15),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      itemPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
      selectedItemPadding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 13,
      ),
      textStyle: TextStyle(
        color: colorScheme.onSurface.withOpacity(0.9),
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),

      selectedTextStyle: TextStyle(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      hoverTextStyle: TextStyle(
        color: colorScheme.secondary,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      itemTextPadding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 5,
      ),

      selectedItemTextPadding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 5,
      ),
    );
  }

  void _logout() {
    SnackbarMes.showCustomDialog(
      context,
      title: LocaleKeys.SignOutTitle.trnsltd,
      content: LocaleKeys.SignOutDescription.trnsltd,
      buttonCancelText: LocaleKeys.CancelButton.trnsltd,
      buttonConfirmText: LocaleKeys.logout_button.trnsltd,
      onCancel: () {
        Navigator.pop(context);
      },
      onConfirm: () async {
        Navigator.pop(context);
        context.read<AuthCubit>().signOut();
      },
    );
  }
}

class _NavPage {
  const _NavPage(this.icon, this.label, this.builder);

  final IconData icon;
  final String label;
  final Widget Function() builder;
}

/// Shown when the account has no page to open (e.g. queue-only staff, whose
/// queue controls live in the top banner).
class _NoPagesView extends StatelessWidget {
  const _NoPagesView({super.key, required this.queueOnly});

  final bool queueOnly;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            queueOnly
                ? HugeIcons.strokeRoundedUserMultiple02
                : HugeIcons.strokeRoundedSquareLock02,
            size: 72,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            queueOnly
                ? LocaleKeys.access_queue_only.trnsltd
                : LocaleKeys.access_none.trnsltd,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
