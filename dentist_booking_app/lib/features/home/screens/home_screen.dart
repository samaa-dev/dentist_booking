import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/features/auth/blocs/auth/auth_cubit.dart';
import 'package:dentist_booking_app/features/home/blocs/booking_create/booking_create_cubit.dart';
import 'package:dentist_booking_app/features/queue/blocs/queue/queue_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_setup.dart';
import '../repo/clinic_settings_repo.dart';
import '../../../core/enum/enum.dart';
import '../../../core/util/info_snackbar.dart';
import '../../../core/widgets/header_background.dart';
import '../../../core/widgets/loading_dialog.dart';
import '../../../core/widgets/section_heading.dart';
import '../../../generated/locale_keys.g.dart';
import '../blocs/booking_status/booking_status_cubit.dart';
import '../widget/ads_carousel.dart';
import '../widget/booking_status_panel.dart';
import '../widget/dentist_info_card.dart';
import 'booking_create_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<BookingStatusCubit>()..loadStatus(),
        ),
        BlocProvider(create: (context) => getIt<BookingCreateCubit>()),
        BlocProvider(
          create: (context) => getIt<QueueCubit>()..loadActiveBookingQueue(),
        ),
      ],
      child: BlocListener<BookingCreateCubit, BookingCreateState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            loading: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => LoadingDialog(),
            ),
            successBookingCreate: (booking) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              SnackbarMes.showToastMsg(
                context,
                message: LocaleKeys.booking_add_success.trnsltd,
              );
              // تحديث معلومات الطابور بعد نجاح الحجز
              context.read<QueueCubit>().loadActiveBookingQueue();
            },
            errorBookingCreate: (message) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              SnackbarMes.showToastMsg(context, message: message);
            },
          );
        },
        child: _HomeLayout(),
      ),
    );
  }
}

class _HomeLayout extends StatelessWidget {
  const _HomeLayout();

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final bool isGuest = authState is Status && authState.typeLogin == TypeLogin.guest;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.reversedSystemUiOverlayStylebrightness,
        child: Scaffold(
        body: Stack(
          children: [
            const HeaderBackground(),
            FutureBuilder<String?>(
              future: getIt<ClinicSettingsRepo>().getClinicPhone(),
              builder: (context, snapshot) {
                return DentistInfoCard(
                  clinicPhone: snapshot.data,
                );
              },
            ),
            Positioned.fill(
              top: 200,
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  const SliverToBoxAdapter(child: AdsCarousel()),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(
                    child: SectionTitleHeading(
                      title: LocaleKeys.book_now.trnsltd,
                      description: LocaleKeys.booking_status_subtitle.trnsltd,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  SliverToBoxAdapter(
                    child: BookingStatusPanel(
                      onBookTap: () {
                        if (isGuest) {
                          _showGuestLoginDialog(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: context.read<BookingCreateCubit>()),
                                BlocProvider.value(value: context.read<AuthCubit>()),
                              ],
                              child: const BookingCreateScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGuestLoginDialog(BuildContext context) {
    SnackbarMes.showCustomDialog(
      context,
      title: LocaleKeys.login_required_title.trnsltd,
      content: LocaleKeys.guest_mode_message.trnsltd,
      buttonConfirmText: LocaleKeys.login_with_google.trnsltd,
      buttonCancelText: LocaleKeys.cancel_button.trnsltd,
      onConfirm: () {
        Navigator.of(context).pop();
        context.read<AuthCubit>().signOut();
      },
      onCancel: () => Navigator.of(context).pop(),
    );
  }
}
