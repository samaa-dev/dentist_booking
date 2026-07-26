import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/announcement/blocs/announcement/announcement_cubit.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_setup.dart';
import '../../../core/util/util.dart';
import '../../../core/widgets/loading_dialog.dart';
import '../widget/announcemen_header.dart';
import '../widget/announcement_content.dart';
import '../widget/empty_announcemen.dart';
import '../widget/error_announcemen.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AnnouncementCubit>(
      create: (context) => getIt<AnnouncementCubit>()..getAllAnnouncements(),

      child: BlocConsumer<AnnouncementCubit, AnnouncementState>(
        listenWhen: (previous, current) {
          return current.maybeWhen(
            orElse: () => false,
            error: (_) => true,
            errorAddAnnouncement: (_) => true,
            errorDeleteAnnouncement: (_) => true,
            errorUpdateAnnouncement: (_) => true,
            loadingAnnouncement: () => true,
            successAddAnnouncement: (_) => true,
            successUpdateAnnouncement: (_) => true,
            successDeleteAnnouncement: (_) => true,
          );
        },

        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            loadingAnnouncement: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => LoadingDialog(),
              );
            },
            successAddAnnouncement: (_) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              if (Navigator.canPop(context)) Navigator.pop(context);

              SnackbarMes.showToastMsg(
                context,
                message: LocaleKeys.announcement_success_create.trnsltd,
              );
            },

            successUpdateAnnouncement: (_) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              if (Navigator.canPop(context)) Navigator.pop(context);

              SnackbarMes.showToastMsg(
                context,
                message: LocaleKeys.announcement_success_update.trnsltd,
              );
            },

            successDeleteAnnouncement: (_) {
              if (Navigator.canPop(context)) Navigator.pop(context);

              SnackbarMes.showToastMsg(
                context,
                message: LocaleKeys.announcement_success_delete.trnsltd,
              );
            },

            errorAddAnnouncement: (message) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              SnackbarMes.showToastMsg(context, message: message);
            },
          );
        },

        builder: (context, state) {
          return _AnnouncementLayout();
        },
      ),
    );
  }
}

class _AnnouncementLayout extends StatelessWidget {
  const _AnnouncementLayout();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AnnouncementCubit, AnnouncementState>(
      buildWhen: (previous, current) {
        return current.maybeWhen(
          orElse: () => false,
          loading: () => true,
          loaded: (_) => true,
          error: (_) => false,
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => Center(
            child: CircularProgressIndicator(
              color: colorScheme.primary,
            ),
          ),

          loaded: (announcementListList) {
            if (announcementListList.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocProvider.value(
                    value: context.read<AnnouncementCubit>(),
                    child: AnnouncemenHeader(),
                  ),
                  Spacer(),
                  EmptyAnnouncemen(),
                  Spacer(),
                ],
              );
            }

            return Column(
              children: [
                BlocProvider.value(
                  value: context.read<AnnouncementCubit>(),
                  child: AnnouncemenHeader(),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: BlocProvider.value(
                    value: context.read<AnnouncementCubit>(),
                    child: AnnouncementContent(
                      announcements: announcementListList,
                    ),
                  ),
                ),
              ],
            );
          },

          error: (message) => ErrorAnnouncemen(message: message),
          orElse: () => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
