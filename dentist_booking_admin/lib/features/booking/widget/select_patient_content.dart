import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/model/profile_model.dart';
import '../../../generated/locale_keys.g.dart';
import 'custom_search_bar.dart';

class SelectPatientContent extends StatefulWidget {
  const SelectPatientContent({
    super.key,
    required this.listPatients,
  });

  final List<ProfileModel> listPatients;

  @override
  State<SelectPatientContent> createState() => _SelectPatientContentState();
}

class _SelectPatientContentState extends State<SelectPatientContent> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final filtered = widget.listPatients.where((patients) {
      final matchSearch =
          patients.meta['raw_user_meta_data']['full_name']
              ?.toLowerCase()
              .contains(
                search.toLowerCase(),
              ) ??
          false;
      patients.meta['raw_user_meta_data']['name']?.toLowerCase().contains(
            search.toLowerCase(),
          ) ??
          false;

      return matchSearch;
    }).toList();

    return Column(
      children: [
        CustomSearchBar(
          controller: TextEditingController(text: search),
          hint: LocaleKeys.search_by_patient_name.trnsltd,
          onChanged: (value) {
            setState(() => search = value);
          },
        ),
        SizedBox(height: 10),
        filtered.isEmpty
            ? Expanded(
                child: Center(
                  child: Text(
                    LocaleKeys.no_patient_found.trnsltd,
                    style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : Expanded(
                child: SelectsPatients(
                  listPatients: filtered,
                ),
              ),
      ],
    );
  }
}

class SelectsPatients extends StatelessWidget {
  const SelectsPatients({super.key, required this.listPatients});

  final List<ProfileModel> listPatients;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final locale = context.locale;

    return ListView.separated(
      itemCount: listPatients.length,
      separatorBuilder: (_, __) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = listPatients[index];

        final meta = item.meta['raw_user_meta_data'] ?? {};

        final fullName =
            meta['full_name'] ??
            meta['name'] ??
            LocaleKeys.unknown_name.trnsltd;

        final phone = meta['phone'] ?? LocaleKeys.unknown_phone.trnsltd;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.pop(context, item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.onSurface.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: colorScheme.primary.withOpacity(0.2),
                  child: Icon(
                    HugeIcons.strokeRoundedUser02,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        phone,
                        style: textTheme.bodySmall!.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                locale.languageCode == 'ar'
                    ? Icon(
                        HugeIcons.strokeRoundedArrowLeft01,
                        color: colorScheme.primary,
                      )
                    : Icon(
                        HugeIcons.strokeRoundedArrowRight01,
                        color: colorScheme.primary,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
