import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

enum UserRole { admin, doctor, staff, patient, unknown }

enum AnnouncementAudience { all, appOnly, tvOnly }

enum AnnouncementStatus { stopping, activeing }

enum BookingDateScope {
  today('today'),
  yesterday('yesterday'),
  last3Days('last3Days'),
  last7Days('last7Days'),
  other('other');

  final String code;
  const BookingDateScope(this.code);
}

enum PatientType {
  registered('registered'),
  guest('guest');

  final String code;
  const PatientType(this.code);
}

enum BookingShift {
  morning('morning'),
  evening('evening');

  final String code;
  const BookingShift(this.code);
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

enum StaffPosition {
  nurse("nurse"),
  receptionist("receptionist"),
  assistant("assistant"),
  technician("technician"),
  cleaner("cleaner"),
  manager("manager");

  final String code;
  const StaffPosition(this.code);
}

enum ShiftType {
  morning("morning"),
  evening("evening"),
  mixed("mixed");

  final String code;
  const ShiftType(this.code);
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

extension StaffPositionExt on StaffPosition {
  String get name {
    switch (this) {
      case StaffPosition.nurse:
        return LocaleKeys.pos_nurse.trnsltd;
      case StaffPosition.receptionist:
        return LocaleKeys.pos_receptionist.trnsltd;
      case StaffPosition.assistant:
        return LocaleKeys.pos_assistant.trnsltd;
      case StaffPosition.technician:
        return LocaleKeys.pos_technician.trnsltd;
      case StaffPosition.cleaner:
        return LocaleKeys.pos_cleaner.trnsltd;
      case StaffPosition.manager:
        return LocaleKeys.pos_manager.trnsltd;
    }
  }
}

extension StaffStatusExt on AccountStatus {
  String get name {
    switch (this) {
      case AccountStatus.active:
        return LocaleKeys.status_active.trnsltd;
      case AccountStatus.vacation:
        return LocaleKeys.status_vacation.trnsltd;
      case AccountStatus.suspended:
        return LocaleKeys.status_suspended.trnsltd;
      case AccountStatus.resigned:
        return LocaleKeys.status_resigned.trnsltd;
      case AccountStatus.terminated:
        return LocaleKeys.status_terminated.trnsltd;
      case AccountStatus.inactive:
        return LocaleKeys.status_inactive.trnsltd;
      case AccountStatus.banned:
        return LocaleKeys.status_banned.trnsltd;
      case AccountStatus.paused:
        return LocaleKeys.status_paused.trnsltd;
      case AccountStatus.appMaintenance:
        return LocaleKeys.status_appMaintenance.trnsltd;
    }
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

extension ShiftTypeExt on ShiftType {
  String get name {
    switch (this) {
      case ShiftType.morning:
        return LocaleKeys.shift_morning.trnsltd;
      case ShiftType.evening:
        return LocaleKeys.shift_evening.trnsltd;
      case ShiftType.mixed:
        return LocaleKeys.shift_mixed.trnsltd;
    }
  }
}

extension AnnouncementAudienceExt on AnnouncementAudience {
  String get name {
    switch (this) {
      case AnnouncementAudience.all:
        return LocaleKeys.audience_all.trnsltd;
      case AnnouncementAudience.appOnly:
        return LocaleKeys.audience_appOnly.trnsltd;
      case AnnouncementAudience.tvOnly:
        return LocaleKeys.audience_tvOnly.trnsltd;
    }
  }
}

extension AnnouncementAudienceMapper on String? {
  Color tobgColorsAnnouncemen() => switch (this) {
    'all' => Colors.green.withOpacity(.18),
    'appOnly' => Colors.blue.withOpacity(.18),
    'tvOnly' => Colors.purple.withOpacity(.18),
    _ => Colors.purple.withOpacity(.18),
  };
  Color totxtColorsAnnouncemen() => switch (this) {
    'all' => Colors.green,
    'appOnly' => Colors.blue,
    'tvOnly ' => Colors.purple,
    _ => Colors.purple,
  };

  String toAnnouncementStringAudience() => switch (this) {
    'all' => LocaleKeys.audience_all.trnsltd,
    'appOnly' => LocaleKeys.audience_appOnly.trnsltd,
    'tvOnly' => LocaleKeys.audience_tvOnly.trnsltd,
    _ => LocaleKeys.audience_all.trnsltd,
  };

  AnnouncementAudience toAnnouncementAudience() => switch (this) {
    'all' => AnnouncementAudience.all,
    'appOnly' => AnnouncementAudience.appOnly,
    'tvOnly' => AnnouncementAudience.tvOnly,
    _ => AnnouncementAudience.all,
  };
}

extension AnnouncementAudienceString on String? {
  String toAudienceString() {
    if (this == LocaleKeys.audience_all.trnsltd) {
      return 'all';
    }
    if (this == LocaleKeys.audience_appOnly.trnsltd) {
      return 'appOnly';
    }
    if (this == LocaleKeys.audience_tvOnly.trnsltd) {
      return 'tvOnly';
    }
    return 'all';
  }
}

extension AnnouncementStatusExt on AnnouncementStatus {
  String get name {
    switch (this) {
      case AnnouncementStatus.stopping:
        return LocaleKeys.status_stopping.trnsltd;
      case AnnouncementStatus.activeing:
        return LocaleKeys.status_activeing.trnsltd;
    }
  }
}

extension AnnouncementStatusMapperBool on bool? {
  String toAnnouncementStringStatus() => switch (this) {
    false => LocaleKeys.status_stopping.trnsltd,
    true => LocaleKeys.status_activeing.trnsltd,
    _ => LocaleKeys.status_stopping.trnsltd,
  };

  Color tobgColorsAnnouncemen() => switch (this) {
    false => Colors.red.withOpacity(.18),
    true => Colors.green.withOpacity(.18),
    _ => Colors.purple.withOpacity(.18),
  };
  Color totxtColorsAnnouncemen() => switch (this) {
    false => Colors.red,
    true => Colors.green,
    _ => Colors.purple,
  };
}

extension AnnouncementStatusMapperString on String? {
  AnnouncementStatus toAnnouncementStatus() => switch (this) {
    'active' => AnnouncementStatus.activeing,
    'inactive' => AnnouncementStatus.stopping,
    _ => AnnouncementStatus.stopping,
  };
}

extension AnnouncementStatusString on String {
  bool toAnnouncementBool() {
    return this == LocaleKeys.status_activeing.trnsltd;
  }
}

extension BookingDateScopeExt on BookingDateScope {
  String get name {
    switch (this) {
      case BookingDateScope.today:
        return LocaleKeys.date_today.trnsltd;
      case BookingDateScope.yesterday:
        return LocaleKeys.date_yesterday.trnsltd;
      case BookingDateScope.last3Days:
        return LocaleKeys.date_last3Days.trnsltd;
      case BookingDateScope.last7Days:
        return LocaleKeys.date_last7Days.trnsltd;
      case BookingDateScope.other:
        return LocaleKeys.today.trnsltd;
    }
  }
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
      // case BookingStatus.all:
      //   return LocaleKeys.status_all.trnsltd;
    }
  }

  Color tobgColorsBooking() => switch (this) {
    BookingStatus.pending => Colors.orange.withOpacity(.18),
    BookingStatus.confirmed => Colors.green.withOpacity(.18),
    BookingStatus.completed => Colors.blue.withOpacity(.18),
    BookingStatus.cancelledByPatient => Colors.red.withOpacity(.18),
    BookingStatus.cancelledByStaff => Colors.red.withOpacity(.18),
    BookingStatus.noShow => Colors.red.withOpacity(.18),
    // BookingStatus.all => Colors.purple.withOpacity(.18),
  };
  Color totxtColorsBooking() => switch (this) {
    BookingStatus.pending => Colors.orange,
    BookingStatus.confirmed => Colors.green,
    BookingStatus.completed => Colors.blue,
    BookingStatus.cancelledByPatient => Colors.red,
    BookingStatus.cancelledByStaff => Colors.red,
    BookingStatus.noShow => Colors.red,
    // BookingStatus.all => Colors.purple,
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

extension BookingShiftMapper on String? {
  BookingShift toBookingShiftEnum() {
    if (this == LocaleKeys.shift_morning.trnsltd) {
      return BookingShift.morning;
    }
    if (this == LocaleKeys.shift_evening.trnsltd) {
      return BookingShift.evening;
    }
    return BookingShift.morning;
  }
}

extension BookingStatusString on String? {
  bool toBookingBool() {
    return this == LocaleKeys.status_pending.trnsltd;
  }
}

extension PatientTypeExt on PatientType {
  String get name {
    switch (this) {
      case PatientType.registered:
        return LocaleKeys.type_registered.trnsltd;
      case PatientType.guest:
        return LocaleKeys.type_guest.trnsltd;
    }
  }

  Color tobgColorsPatient() => switch (this) {
    PatientType.registered => Colors.green.withOpacity(.18),
    PatientType.guest => Colors.blue.withOpacity(.18),
  };
  Color totxtColorsPatient() => switch (this) {
    PatientType.registered => Colors.green,
    PatientType.guest => Colors.blue,
  };
}

extension PatientTypeMapper on String? {
  String toPatientTypeString() => switch (this) {
    'registered' => LocaleKeys.type_registered.trnsltd,
    'guest' => LocaleKeys.type_guest.trnsltd,
    _ => LocaleKeys.type_registered.trnsltd,
  };

  toPatientType() => switch (this) {
    'registered' => PatientType.registered,
    'guest' => PatientType.guest,
    _ => PatientType.registered,
  };
}

extension PatientTypeString on String? {
  bool toPatientBool() {
    return this == LocaleKeys.type_registered.trnsltd;
  }
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

//

extension BookingShiftString on String? {
  bool toBookingShiftBool() {
    return this == LocaleKeys.shift_morning.trnsltd;
  }
}
