import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/announcement/widget/announcement_table.dart';
import 'package:flutter/material.dart';

import '../../../core/enum/enum.dart';
import '../../../core/model/announcement_model.dart';
import '../../../core/widgets/custom_dropdown.dart';
import '../../../generated/locale_keys.g.dart';
import '../../booking/widget/custom_search_bar.dart';

class AnnouncementContent extends StatefulWidget {
  const AnnouncementContent({
    super.key,
    required this.announcements,
  });

  final List<AnnouncementModel> announcements;

  @override
  State<AnnouncementContent> createState() => _AnnouncementContentState();
}

class _AnnouncementContentState extends State<AnnouncementContent> {
  String search = '';
  AnnouncementAudience? selectedStatus = AnnouncementAudience.all;

  @override
  Widget build(BuildContext context) {
    final filtered = widget.announcements.where((announcement) {
      final matchSearch = announcement.title.toLowerCase().contains(
        search.toLowerCase(),
      );

      final matchStatus = selectedStatus == AnnouncementAudience.all
          ? true
          : announcement.audience.toAnnouncementAudience() == selectedStatus;

      return matchSearch && matchStatus;
    }).toList();

    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 3,
              child: CustomSearchBar(
                controller: TextEditingController(text: search),
                hint: LocaleKeys.search_by_announcement_name.trnsltd,
                onChanged: (value) {
                  setState(() => search = value);
                },
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: CustomDropdown<AnnouncementAudience?>(
                enableSearch: false,
                value: selectedStatus,
                hintText: LocaleKeys.booking_status.trnsltd,
                items: _getStatusAndAudienceItems(),
                onChanged: (value) {
                  setState(() => selectedStatus = value);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Flexible(
          child: AnnouncementTable(
            announcements: filtered,
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<AnnouncementAudience?>> _getStatusAndAudienceItems() {
    return [
      ...AnnouncementAudience.values.map((status) {
        return DropdownMenuItem(
          value: status,
          child: Text(status.name),
        );
      }),
    ];
  }
}
