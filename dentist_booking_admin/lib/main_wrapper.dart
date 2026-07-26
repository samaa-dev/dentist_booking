import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/booking/view/booking_screen.dart';
import 'package:dentist_booking_admin/features/patient/view/patient_screen.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sidebarx/sidebarx.dart';

import 'core/enum/enum.dart';
import 'core/util/util.dart';
import 'core/widgets/welcome_banner.dart';
import 'features/announcement/announcement.dart';
import 'features/auth/blocs/auth/auth_cubit.dart';
import 'features/dashboard/dashboard.dart';
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

    return Scaffold(
      body: Row(
        children: [
          SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: buildSidebar(context, userRole: userRole),
          ),
          Expanded(
            child: Column(
              children: [
                WelcomeBanner(),
                _contanierView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contanierView() {
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
                    child: _getPage(_controller.selectedIndex),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSidebar(BuildContext context, {required UserRole? userRole}) {
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

      items: _sidebarItemsForRole(userRole),
    );
  }

  List<SidebarXItem> _sidebarItemsForRole(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return [
          SidebarXItem(
            icon: HugeIcons.strokeRoundedDashboardCircle,
            label: LocaleKeys.Dashboard.trnsltd,
          ),
          SidebarXItem(
            icon: HugeIcons.strokeRoundedAddToList,
            label: LocaleKeys.Reservations.trnsltd,
          ),
          SidebarXItem(
            icon: HugeIcons.strokeRoundedAdvertisiment,
            label: LocaleKeys.Ads.trnsltd,
          ),
          SidebarXItem(
            icon: HugeIcons.strokeRoundedSettings01,
            label: LocaleKeys.Settings.trnsltd,
          ),
          SidebarXItem(
            icon: HugeIcons.strokeRoundedUserGroup,
            label: LocaleKeys.AccountPatients.trnsltd,
          ),
          SidebarXItem(
            icon: HugeIcons.strokeRoundedUserAccount,
            label: LocaleKeys.AccountEmployees.trnsltd,
          ),
        ];

      case UserRole.doctor:
        return [
          SidebarXItem(
            icon: HugeIcons.strokeRoundedDashboardCircle,
            label: LocaleKeys.Dashboard.trnsltd,
          ),
          SidebarXItem(
            icon: HugeIcons.strokeRoundedAddToList,
            label: LocaleKeys.Reservations.trnsltd,
          ),
          SidebarXItem(
            icon: HugeIcons.strokeRoundedAdvertisiment,
            label: LocaleKeys.Ads.trnsltd,
          ),
          SidebarXItem(
            icon: HugeIcons.strokeRoundedSettings01,
            label: LocaleKeys.Settings.trnsltd,
          ),
          SidebarXItem(
            icon: HugeIcons.strokeRoundedUserGroup,
            label: LocaleKeys.AccountPatients.trnsltd,
          ),
          SidebarXItem(
            icon: HugeIcons.strokeRoundedUserAccount,
            label: LocaleKeys.AccountEmployees.trnsltd,
          ),
        ];

      case UserRole.staff:
        return [
          SidebarXItem(
            icon: HugeIcons.strokeRoundedDashboardCircle,
            label: LocaleKeys.Dashboard.trnsltd,
          ),
          SidebarXItem(
            icon: HugeIcons.strokeRoundedAddToList,
            label: LocaleKeys.Reservations.trnsltd,
          ),
          SidebarXItem(
            icon: HugeIcons.strokeRoundedAdvertisiment,
            label: LocaleKeys.Ads.trnsltd,
          ),
        ];

      default:
        return [
          // SidebarXItem(
          //   icon: HugeIcons.strokeRoundedDashboardCircle,
          //   label: LocaleKeys.Dashboard.trnsltd,
          // ),
        ];
    }
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return DashboardScreen();
      case 1:
        return const BookingScreen();
      case 2:
        return AnnouncementScreen();
      case 3:
        return const SettingsScreen();
      case 4:
        return const PatientScreen();
      case 5:
        return const StaffScreen();

      default:
        return const Center(child: Text("Page Not Found"));
    }
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
