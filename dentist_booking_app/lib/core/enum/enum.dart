import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';

import '../../generated/locale_keys.g.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

enum UserRole { admin, doctor, staff, patient, unknown }

enum AnnouncementAudience { all, appOnly, tvOnly }

enum BookingShift {
  morning('morning'),
  evening('evening');

  final String code;
  const BookingShift(this.code);
}

enum PatientType {
  registered('registered'),
  guest('guest');

  final String code;
  const PatientType(this.code);
}

enum AccountStatus {
  active("active"),
  vacation("vacation"),
  suspended("suspended"),
  resigned("resigned"),
  inactive("inactive"),
  terminated("terminated"),
  banned("banned"),
  paused("paused"),
  appMaintenance("appMaintenance");

  final String code;
  const AccountStatus(this.code);
}

enum TypeLogin {
  google,
  guest,
}

enum BookingStatus {
  pending('pending'),
  confirmed('confirmed'),
  completed('completed'),
  cancelledByPatient('cancelledByPatient'),
  cancelledByStaff('cancelledByStaff'),
  noShow('noShow');

  final String code;
  const BookingStatus(this.code);
}

extension BookingStatusExt on BookingStatus {
  String get name {
    switch (this) {
      case BookingStatus.pending:
        return LocaleKeys.status_pending.trnsltd;
      case BookingStatus.confirmed:
        return LocaleKeys.status_confirmed.trnsltd;
      case BookingStatus.completed:
        return LocaleKeys.status_completed.trnsltd;
      case BookingStatus.cancelledByPatient:
        return LocaleKeys.status_cancelledByPatient.trnsltd;
      case BookingStatus.cancelledByStaff:
        return LocaleKeys.status_cancelledByStaff.trnsltd;
      case BookingStatus.noShow:
        return LocaleKeys.status_noShow.trnsltd;
    }
  }

  Color tobgColorsBooking() => switch (this) {
    BookingStatus.pending => Colors.orange.withOpacity(.18),
    BookingStatus.confirmed => Colors.green.withOpacity(.18),
    BookingStatus.completed => Colors.blue.withOpacity(.18),
    BookingStatus.cancelledByPatient => Colors.red.withOpacity(.18),
    BookingStatus.cancelledByStaff => Colors.red.withOpacity(.18),
    BookingStatus.noShow => Colors.red.withOpacity(.18),
  };
  Color totxtColorsBooking() => switch (this) {
    BookingStatus.pending => Colors.orange,
    BookingStatus.confirmed => Colors.green,
    BookingStatus.completed => Colors.blue,
    BookingStatus.cancelledByPatient => Colors.red,
    BookingStatus.cancelledByStaff => Colors.red,
    BookingStatus.noShow => Colors.red,
  };
}

extension BookingStatusMapper on String? {
  String toBookingStringStatus() => switch (this) {
    'pending' => LocaleKeys.status_pending.trnsltd,
    'confirmed' => LocaleKeys.status_confirmed.trnsltd,
    'completed' => LocaleKeys.status_completed.trnsltd,
    'cancelledByPatient' => LocaleKeys.status_cancelledByPatient.trnsltd,
    'cancelledByStaff' => LocaleKeys.status_cancelledByStaff.trnsltd,
    'noShow' => LocaleKeys.status_noShow.trnsltd,
    _ => LocaleKeys.status_pending.trnsltd,
  };
  toBookingStatus() => switch (this) {
    'pending' => BookingStatus.pending,
    'confirmed' => BookingStatus.confirmed,
    'completed' => BookingStatus.completed,
    'cancelledByPatient' => BookingStatus.cancelledByPatient,
    'cancelledByStaff' => BookingStatus.cancelledByStaff,
    'noShow' => BookingStatus.noShow,
    _ => BookingStatus.pending,
  };
  BookingStatus toBookingStatusEnum() {
    if (this == LocaleKeys.status_confirmed.trnsltd) {
      return BookingStatus.confirmed;
    }
    if (this == LocaleKeys.status_completed.trnsltd) {
      return BookingStatus.completed;
    }
    if (this == LocaleKeys.status_cancelledByPatient.trnsltd) {
      return BookingStatus.cancelledByPatient;
    }
    if (this == LocaleKeys.status_cancelledByStaff.trnsltd) {
      return BookingStatus.cancelledByStaff;
    }
    if (this == LocaleKeys.status_noShow.trnsltd) {
      return BookingStatus.noShow;
    }
    return BookingStatus.pending;
  }
}

extension BookingStatusString on String? {
  bool toBookingBool() {
    return this == LocaleKeys.status_pending.trnsltd;
  }
}

extension AccountStatusMapper on String? {
  AccountStatus toAccountStatus() => switch (this) {
    'active' => AccountStatus.active,
    'vacation' => AccountStatus.vacation,
    'suspended' => AccountStatus.suspended,
    'resigned' => AccountStatus.resigned,
    'terminated' => AccountStatus.terminated,
    'inactive' => AccountStatus.inactive,
    'banned' => AccountStatus.banned,
    'paused' => AccountStatus.paused,
    'appMaintenance' => AccountStatus.appMaintenance,
    _ => AccountStatus.paused,
  };

  String toAccountStringStatus() => switch (this) {
    'active' => LocaleKeys.status_active.trnsltd,
    'vacation' => LocaleKeys.status_vacation.trnsltd,
    'suspended' => LocaleKeys.status_suspended.trnsltd,
    'resigned' => LocaleKeys.status_resigned.trnsltd,
    'terminated' => LocaleKeys.status_terminated.trnsltd,
    'inactive' => LocaleKeys.status_inactive.trnsltd,
    'banned' => LocaleKeys.status_banned.trnsltd,
    'paused' => LocaleKeys.status_paused.trnsltd,
    'appMaintenance' => LocaleKeys.status_appMaintenance.trnsltd,
    _ => LocaleKeys.status_paused.trnsltd,
  };

  Color tobgColorsStatus() => switch (this) {
    'active' => Colors.green.withOpacity(.18),
    'vacation' => Colors.blue.withOpacity(.18),
    'suspended' => Colors.orange.withOpacity(.18),
    'resigned' => Colors.red.withOpacity(.18),
    'terminated' => Colors.red.withOpacity(.18),
    'inactive' => Colors.grey.withOpacity(.18),
    'banned' => Colors.red.withOpacity(.18),
    'paused' => Colors.purple.withOpacity(.18),
    'appMaintenance' => Colors.yellow.withOpacity(.18),
    _ => Colors.purple.withOpacity(.18),
  };

  Color totxtColorsStatus() => switch (this) {
    'active' => Colors.green,
    'vacation' => Colors.blue,
    'suspended' => Colors.orange,
    'resigned' => Colors.red,
    'terminated' => Colors.red,
    'inactive' => Colors.grey,
    'banned' => Colors.red,
    'paused' => Colors.purple,
    'appMaintenance' => Colors.yellow,
    _ => Colors.purple,
  };
}

extension UserRoleMapper on String? {
  UserRole toUserRole() => switch (this) {
    'admin' => UserRole.admin,
    'doctor' => UserRole.doctor,
    'staff' => UserRole.staff,
    'patient' => UserRole.patient,
    _ => UserRole.unknown,
  };

  String toUserStringRole() => switch (this) {
    'admin' => LocaleKeys.admin.trnsltd,
    'doctor' => LocaleKeys.doctor.trnsltd,
    'staff' => LocaleKeys.staff.trnsltd,
    'patient' => LocaleKeys.patient.trnsltd,
    _ => LocaleKeys.patient.trnsltd,
  };
}

extension BookingShiftExt on BookingShift {
  String get name {
    switch (this) {
      case BookingShift.morning:
        return LocaleKeys.shift_morning.trnsltd;
      case BookingShift.evening:
        return LocaleKeys.shift_evening.trnsltd;
    }
  }

  Color tobgColorsShiftBooking() => switch (this) {
    BookingShift.morning => Colors.green.withOpacity(.18),
    BookingShift.evening => Colors.blue.withOpacity(.18),
  };

  Color totxtColorsShiftBooking() => switch (this) {
    BookingShift.morning => Colors.green,
    BookingShift.evening => Colors.blue,
  };
}
