import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/core/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/model/profile_model.dart';
import '../../../generated/locale_keys.g.dart';
import '../blocs/staff/staff_cubit.dart';

class ChosseDropdownProfile extends StatelessWidget {
  const ChosseDropdownProfile({
    super.key,
    required this.onChanged,
    required this.value,
  });

  final Function(String? value) onChanged;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffCubit, StaffState>(
      buildWhen: (previous, current) {
        return current.maybeWhen(
          orElse: () => false,
          loadingProfile: () => true,
          loadedProfile: (_) => true,
          errorProfile: (_) => true,
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          loadingProfile: () {
            return _loadingDropdown();
          },

          loadedProfile: (profiles) {
            final items = _getProfileItems(context, profiles);

            return CustomDropdown<String>(
              enableSearch: false,
              hintText: LocaleKeys.ChosseUser.trnsltd,
              items: items,
              value: null,
              onChanged: (selected) => onChanged(selected),

              validator: (value) =>
                  value == null ? LocaleKeys.User_required.trnsltd : null,
            );
          },

          errorProfile: (_) => _loadingDropdown(),

          orElse: () => _loadingDropdown(),
        );
      },
    );
  }

  Widget _loadingDropdown() {
    return CustomDropdown<String>(
      enableSearch: false,
      hintText: LocaleKeys.ChosseUser.trnsltd,
      items: [
        DropdownMenuItem(
          value: null,
          child: Text(LocaleKeys.loading.trnsltd),
        ),
      ],
      value: null,
      onChanged: (_) {},
      validator: (value) =>
          value == null ? LocaleKeys.User_required.trnsltd : null,
    );
  }

  List<DropdownMenuItem<String>> _getProfileItems(
    BuildContext context,
    List<ProfileModel> profiles,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return profiles.map((profile) {
      final name = profile.meta['name'] ?? 'Unknown';
      return DropdownMenuItem(
        value: profile.userId,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              shortUserId(profile.userId),
              style: textTheme.bodySmall!.copyWith(
                color: colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String shortUserId(String id, {int start = 4, int end = 2}) {
    if (id.length <= start + end) return id;
    return "${id.substring(0, start)}...${id.substring(id.length - end)}";
  }
}
