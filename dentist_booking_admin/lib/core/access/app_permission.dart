import 'package:flutter/widgets.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../generated/locale_keys.g.dart';
import '../extensions/os_extensions.dart';

/// Permissions a staff account can be granted (mirrors staff.permissions in
/// the database). Admins implicitly hold all of them.
enum AppPermission {
  bookings('bookings'),
  queue('queue'),
  patients('patients'),
  announcements('announcements'),
  statistics('statistics'),
  settings('settings');

  final String code;
  const AppPermission(this.code);

  static AppPermission? fromCode(String? code) {
    for (final p in values) {
      if (p.code == code) return p;
    }
    return null;
  }

  String get label => switch (this) {
    AppPermission.bookings => LocaleKeys.perm_bookings.trnsltd,
    AppPermission.queue => LocaleKeys.perm_queue.trnsltd,
    AppPermission.patients => LocaleKeys.perm_patients.trnsltd,
    AppPermission.announcements => LocaleKeys.perm_announcements.trnsltd,
    AppPermission.statistics => LocaleKeys.perm_statistics.trnsltd,
    AppPermission.settings => LocaleKeys.perm_settings.trnsltd,
  };

  String get description => switch (this) {
    AppPermission.bookings => LocaleKeys.perm_bookings_desc.trnsltd,
    AppPermission.queue => LocaleKeys.perm_queue_desc.trnsltd,
    AppPermission.patients => LocaleKeys.perm_patients_desc.trnsltd,
    AppPermission.announcements => LocaleKeys.perm_announcements_desc.trnsltd,
    AppPermission.statistics => LocaleKeys.perm_statistics_desc.trnsltd,
    AppPermission.settings => LocaleKeys.perm_settings_desc.trnsltd,
  };

  IconData get icon => switch (this) {
    AppPermission.bookings => HugeIcons.strokeRoundedAddToList,
    AppPermission.queue => HugeIcons.strokeRoundedUserMultiple02,
    AppPermission.patients => HugeIcons.strokeRoundedUserGroup,
    AppPermission.announcements => HugeIcons.strokeRoundedAdvertisiment,
    AppPermission.statistics => HugeIcons.strokeRoundedChartLineData02,
    AppPermission.settings => HugeIcons.strokeRoundedSettings01,
  };
}
