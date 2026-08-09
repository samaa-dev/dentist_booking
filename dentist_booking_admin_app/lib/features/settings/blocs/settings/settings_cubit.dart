import 'package:dentist_booking_admin_app/core/extensions/os_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/model/clinic_config_model.dart';
import '../../../../core/model/clinic_settings_model.dart';
import '../../../../core/model/working_hours_model.dart';
import '../../../../core/util/util.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../repo/settings_repo.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepo _settingsRepo;

  late ClinicConfigModel _originalModel;
  bool showResetButton = false;

  // -------- TMP variables (editable before save) --------
  late int morningLimitTMP;
  late int eveningLimitTMP;
  late int emergencyLimitTMP;

  late bool bookingEnabledTMP;
  late String bookingStartTMP;
  late String bookingEndTMP;
  late int allowBeforeTMP;

  late bool autoConfirmTMP;

  late String stopReasonTMP;
  late TextEditingController stopReasonController;

  late String? clinicPhoneTMP;
  late TextEditingController clinicPhoneController;

  late TextEditingController minVersionPatientController;
  late TextEditingController minVersionAdminController;
  late TextEditingController minVersionDesktopController;
  late TextEditingController minVersionTvController;

  late bool allowWeekendTMP;

  late List<WorkingHoursModel> workingHoursTMP;

  SettingsCubit({
    required SettingsRepo settingsRepo,
  }) : _settingsRepo = settingsRepo,
       super(const SettingsState.initial());

  // ======================================================
  // 🔥 1) INIT
  // ======================================================
  Future<void> init() async {
    try {
      emit(const SettingsState.loading());

      final config = await _settingsRepo.getSettings();
      _originalModel = config;

      morningLimitTMP = config.settings.morningCountLimit;
      eveningLimitTMP = config.settings.eveningCountLimit;
      bookingEnabledTMP = config.settings.isBookingEnabled;
      stopReasonTMP = config.settings.stopReason ?? "";
      stopReasonController = TextEditingController(
        text: stopReasonTMP,
      );

      clinicPhoneTMP = config.settings.clinicPhone;
      clinicPhoneController = TextEditingController(
        text: clinicPhoneTMP ?? "",
      );

      minVersionPatientController = TextEditingController(
        text: config.settings.minVersionPatient ?? '',
      );
      minVersionAdminController = TextEditingController(
        text: config.settings.minVersionAdmin ?? '',
      );
      minVersionDesktopController = TextEditingController(
        text: config.settings.minVersionDesktop ?? '',
      );
      minVersionTvController = TextEditingController(
        text: config.settings.minVersionTv ?? '',
      );

      bookingStartTMP = config.settings.bookingMorningStartTime;
      allowBeforeTMP = config.settings.allowBeforeMinutes;

      autoConfirmTMP = config.settings.autoConfirm;

      workingHoursTMP = List.from(config.workingHours);

      emit(SettingsState.loaded(config));
    } catch (e) {
      emit(SettingsState.error("Failed to load settings"));
    }
  }

  // ======================================================
  // 🔥 2) UPDATES — used live in UI before save
  // ======================================================

  // ---------- Booking Limits ----------
  void updateMorningLimit(int val) {
    morningLimitTMP = val;
    _pushTemporaryState();
  }

  void updateStopReason(String value) {
    stopReasonTMP = value;
    // stopReasonController.text = value;
    _pushTemporaryState();
  }

  void updateClinicPhone(String? value) {
    clinicPhoneTMP = value?.trim().isEmpty == true ? null : value?.trim();
    _pushTemporaryState();
  }

  void updateMinVersionPatient(String value) {
    _pushTemporaryState();
  }

  void updateMinVersionAdmin(String value) {
    _pushTemporaryState();
  }

  void updateMinVersionDesktop(String value) {
    _pushTemporaryState();
  }

  void updateMinVersionTv(String value) {
    _pushTemporaryState();
  }

  void updateEveningLimit(int val) {
    eveningLimitTMP = val;
    _pushTemporaryState();
  }

  void updateEmergencyLimit(int val) {
    emergencyLimitTMP = val;
    _pushTemporaryState();
  }

  // ---------- Booking Control ----------
  void updateBookingEnabled(bool val) {
    bookingEnabledTMP = val;

    if (bookingEnabledTMP == true) {
      stopReasonTMP = "";
      stopReasonController.text = "";
    }

    _pushTemporaryState();
  }

  void updateBookingStart(String val) {
    bookingStartTMP = val;
    _pushTemporaryState();
  }

  // void updateBookingEnd(String val) {
  //   bookingEndTMP = val;
  //   _pushTemporaryState();
  // }

  void updateAllowBefore(int val) {
    allowBeforeTMP = val;
    _pushTemporaryState();
  }

  void updateAutoConfirm(bool val) {
    autoConfirmTMP = val;
    _pushTemporaryState();
  }

  void updateAllowWeekend(bool val) {
    allowWeekendTMP = val;
    _pushTemporaryState();
  }

  // ======================================================
  // 🔥 3) Working Hours Updates
  // ======================================================

  void updateDayOpen(String id, bool val) {
    workingHoursTMP = workingHoursTMP.map((d) {
      if (d.id == id) return d.copyWith(isOpen: val);
      return d;
    }).toList();

    _pushTemporaryState();
  }

  void updateMorningIsOpen(String id, bool val) {
    workingHoursTMP = workingHoursTMP.map((d) {
      if (d.id == id) return d.copyWith(morningIsOpen: val);
      return d;
    }).toList();

    _pushTemporaryState();
  }

  void updateEveningIsOpen(String id, bool val) {
    workingHoursTMP = workingHoursTMP.map((d) {
      if (d.id == id) return d.copyWith(eveningIsOpen: val);
      return d;
    }).toList();

    _pushTemporaryState();
  }

  void updateMorningStart(String id, String val) {
    workingHoursTMP = workingHoursTMP.map((d) {
      if (d.id == id) return d.copyWith(morningStart: val);
      return d;
    }).toList();

    _pushTemporaryState();
  }

  void updateMorningEnd(String id, String val) {
    workingHoursTMP = workingHoursTMP.map((d) {
      if (d.id == id) return d.copyWith(morningEnd: val);
      return d;
    }).toList();

    _pushTemporaryState();
  }

  void updateEveningStart(String id, String val) {
    workingHoursTMP = workingHoursTMP.map((d) {
      if (d.id == id) return d.copyWith(eveningStart: val);
      return d;
    }).toList();

    _pushTemporaryState();
  }

  void updateEveningEnd(String id, String val) {
    workingHoursTMP = workingHoursTMP.map((d) {
      if (d.id == id) return d.copyWith(eveningEnd: val);
      return d;
    }).toList();

    _pushTemporaryState();
  }

  // ======================================================
  // 🔥 4) Emit temporary live config to UI
  // ======================================================
  void _pushTemporaryState() {
    showResetButton = true;

    emit(
      SettingsState.loaded(
        _buildTemporaryConfigModel(),
      ),
    );
  }

  ClinicConfigModel _buildTemporaryConfigModel() {
    return ClinicConfigModel(
      settings: ClinicSettingsModel(
        morningCountLimit: morningLimitTMP,
        eveningCountLimit: eveningLimitTMP,

        // emergencyLimit: emergencyLimitTMP,
        isBookingEnabled: bookingEnabledTMP,
        bookingMorningStartTime: bookingStartTMP,
        // bookingEndTime: bookingEndTMP,
        allowBeforeMinutes: allowBeforeTMP,

        autoConfirm: autoConfirmTMP,
        stopReason: stopReasonTMP,
        clinicPhone: clinicPhoneTMP,
        minVersionPatient: _nullableVersion(minVersionPatientController.text),
        minVersionAdmin: _nullableVersion(minVersionAdminController.text),
        minVersionDesktop: _nullableVersion(minVersionDesktopController.text),
        minVersionTv: _nullableVersion(minVersionTvController.text),

        // allowWeekend: allowWeekendTMP,
        updatedAt: DateTime.now(),
      ),

      workingHours: workingHoursTMP,
    );
  }

  // ======================================================
  // 🔥 5) SAVE CHANGES TO SUPABASE
  // ======================================================
  Future<void> saveSettings(BuildContext context) async {
    if (!validateBeforeSave(context)) return;

    try {
      emit(const SettingsState.loadingSetting());
      showResetButton = false;

      final updatedModel = _buildTemporaryConfigModel();

      await _settingsRepo.updateSettings(updatedModel);

      emit(SettingsState.successUpdateSetting(updatedModel));
    } catch (e) {
      showResetButton = true;
      final details = e.toString().replaceFirst('Exception: ', '').trim();
      final message = details.isEmpty
          ? LocaleKeys.settings_error_update.trnsltd
          : '${LocaleKeys.settings_error_update.trnsltd} $details';
      emit(SettingsState.errorUpdateSetting(message));
    } finally {}
  }

  void resetSettings() {
    final config = _originalModel;
    showResetButton = false;

    // 🟩 Restore all main settings
    morningLimitTMP = config.settings.morningCountLimit;
    eveningLimitTMP = config.settings.eveningCountLimit;
    // emergencyLimitTMP = config.settings.emergencyLimit;

    bookingEnabledTMP = config.settings.isBookingEnabled;
    bookingStartTMP = config.settings.bookingMorningStartTime;
    // bookingEndTMP = config.settings.bookingEndTime;
    allowBeforeTMP = config.settings.allowBeforeMinutes;

    autoConfirmTMP = config.settings.autoConfirm;
    stopReasonTMP = config.settings.stopReason ?? "";
    stopReasonController.text = stopReasonTMP;

    clinicPhoneTMP = config.settings.clinicPhone;
    clinicPhoneController.text = clinicPhoneTMP ?? "";

    minVersionPatientController.text = config.settings.minVersionPatient ?? '';
    minVersionAdminController.text = config.settings.minVersionAdmin ?? '';
    minVersionDesktopController.text = config.settings.minVersionDesktop ?? '';
    minVersionTvController.text = config.settings.minVersionTv ?? '';

    // allowWeekendTMP = config.settings.allowWeekend;

    // 🟩 Restore all working hours completely
    workingHoursTMP = List.from(config.workingHours);

    // Emit original UI
    emit(SettingsState.loaded(config));
  }

  // ==== Validate before save ==== //

  bool validateBeforeSave(BuildContext context) {
    // ====== Booking Limits ======
    if (morningLimitTMP < 0) {
      return _error(
        context,
        LocaleKeys.error_morning_limit_negative.trnsltd,
      );
    }

    if (eveningLimitTMP < 0) {
      return _error(
        context,
        LocaleKeys.error_evening_limit_negative.trnsltd,
      );
    }

    if (bookingEnabledTMP &&
        morningLimitTMP == 0 &&
        eveningLimitTMP == 0) {
      return _error(
        context,
        LocaleKeys.error_booking_limits_both_zero.trnsltd,
      );
    }

    // ====== Stop reason validation ======
    if (!bookingEnabledTMP) {
      if (stopReasonTMP.trim().isEmpty) {
        return _error(
          context,
          LocaleKeys.stopReason_required.trnsltd,
        );
      }
    }

    // ====== Working Hours ======
    for (final d in workingHoursTMP) {
      if (!d.isOpen) continue;

      final ms = _toMinutes(d.morningStart);
      final me = _toMinutes(d.morningEnd);

      final es = _toMinutes(d.eveningStart);
      final ee = _toMinutes(d.eveningEnd);

      // Morning validation
      if (ms >= 0 && me >= 0 && me <= ms) {
        return _error(
          context,
          LocaleKeys.error_morning_end_before_start.trnsltd.replaceAll(
            "{day}",
            d.dayOfWeek.toString(),
          ),
        );
      }

      // Evening validation
      if (es >= 0 && ee >= 0 && ee <= es) {
        return _error(
          context,
          LocaleKeys.error_evening_end_before_start.trnsltd.replaceAll(
            "{day}",
            d.dayOfWeek.toString(),
          ),
        );
      }

      // Overlap between morning & evening
      if (ms >= 0 && me >= 0 && es >= 0 && es < me) {
        return _error(
          context,
          LocaleKeys.error_evening_overlap_morning.trnsltd.replaceAll(
            "{day}",
            d.dayOfWeek.toString(),
          ),
        );
      }
    }

    // ======================================================
    // 🔥 EXTRA CHECKS: Booking window must align with working hours
    // ======================================================

    final List<int> allStarts = [];
    final List<int> allEnds = [];

    for (final d in workingHoursTMP) {
      if (!d.isOpen) continue;

      final ms = _toMinutes(d.morningStart);
      final me = _toMinutes(d.morningEnd);
      final es = _toMinutes(d.eveningStart);
      final ee = _toMinutes(d.eveningEnd);

      if (ms >= 0) allStarts.add(ms);
      if (me >= 0) allEnds.add(me);
      if (es >= 0) allStarts.add(es);
      if (ee >= 0) allEnds.add(ee);
    }

    if (allStarts.isNotEmpty && allEnds.isNotEmpty) {
      final earliestStart = allStarts.reduce((a, b) => a < b ? a : b);

      final bookingStart = _toMinutes(bookingStartTMP);
      // final bookingEnd = _toMinutes(bookingEndTMP);

      if (bookingStart > earliestStart) {
        return _error(
          context,
          LocaleKeys.error_booking_start_after_work_start.trnsltd.replaceAll(
            "{time}",
            _formatMinutes(earliestStart),
          ),
        );
      }
    }

    return true;
  }

  String? _nullableVersion(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _formatMinutes(int m) {
    final h = (m ~/ 60).toString().padLeft(2, '0');
    final mm = (m % 60).toString().padLeft(2, '0');
    return "$h:$mm";
  }

  bool _error(BuildContext context, String msg) {
    SnackbarMes.showToastMsg(context, message: msg);
    return false;
  }

  int _toMinutes(String? t) {
    if (t == null || t.isEmpty) return -1;
    final parts = t.split(":");
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
