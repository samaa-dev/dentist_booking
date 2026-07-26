import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/core/model/announcement_model.dart';
import 'package:dentist_booking_admin/features/announcement/blocs/announcement/announcement_cubit.dart';
import 'package:dentist_booking_admin/features/announcement/widget/announcement_form_dialog.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/util/util.dart';
import 'announcement_item.dart';

class AnnouncementTable extends StatelessWidget {
  const AnnouncementTable({
    super.key,
    required this.announcements,
  });

  final List<AnnouncementModel> announcements;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (c, index) => AnnouncementItem(
              item: announcements[index],
              onDelete: () => _onDeletedAnnouncement(
                context,
                announcements[index],
              ),
              onEdit: () {
                showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<AnnouncementCubit>(),
                    child: AnnouncementFormDialog(
                      announcement: announcements[index],
                    ),
                  ),
                );
              },
            ),
            childCount: announcements.length,
          ),
        ),
      ],
    );
  }

  _onDeletedAnnouncement(BuildContext context, AnnouncementModel announcemen) {
    SnackbarMes.showCustomDialog(
      context,
      title: LocaleKeys.announcement_delete_title.trnsltd,
      content: LocaleKeys.announcement_delete_confirm.trnsltd,
      buttonCancelText: LocaleKeys.cancel_button.trnsltd,
      buttonConfirmText: LocaleKeys.delete_button.trnsltd,
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () {
        context.read<AnnouncementCubit>().deleteAnnouncement(
          announcemen.id,
        );
        Navigator.of(context).pop();
      },
    );
  }
}
