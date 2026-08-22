import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/app_setup.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/model/profile_model.dart';
import '../../../../core/model/staff_model.dart';
import '../../repo/staff_repo.dart';

part 'staff_cubit.freezed.dart';
part 'staff_state.dart';

class StaffCubit extends Cubit<StaffState> {
  final StaffRepo _staffRepo;

  StaffCubit({required StaffRepo staffRepo})
    : _staffRepo = staffRepo,
      super(const StaffState.loading());

  /// 📌 Load all profiles
  Future<void> getAllProfile() async {
    emit(const StaffState.loadingProfile());
    try {
      final profileList = await _staffRepo.getAllProfiles();

      emit(StaffState.loadedProfile(profileList));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      debugPrint('Error loading profiles: $e');
      emit(StaffState.errorProfile(LocaleKeys.profile_error_load.trnsltd));
    }
  }

  /// 📌 Load all staff
  Future<void> fetchStaff() async {
    emit(const StaffState.loading());
    try {
      final staffList = await _staffRepo.getAllStaff();

      debugPrint('Staff list: $staffList');

      emit(StaffState.loaded(staffList));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      debugPrint('Error loading staff: $e');
      emit(StaffState.error(LocaleKeys.staff_error_load.trnsltd));
    }
  }

  /// 📌 Add create staff
  Future<void> createStaff(StaffModel staff) async {
    try {
      await _staffRepo.createStaff(staff);

      // إعادة تحميل القائمة بالكامل
      final list = await _staffRepo.getAllStaff();
      emit(StaffState.loaded(list));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      debugPrint('Create staff error: $e');
      emit(StaffState.errorAddStaff(LocaleKeys.staff_error_create.trnsltd));
    }
  }

  /// 📌 Update staff
  Future<void> updateStaff(StaffModel updatedStaff) async {
    try {
      final newStaff = await _staffRepo.updateStaff(updatedStaff);

      final currentList = state.maybeWhen(
        loaded: (list) => list,
        orElse: () => <StaffModel>[],
      );

      final updatedList = currentList.map((s) {
        return s.id == newStaff.id ? newStaff : s;
      }).toList();

      emit(StaffState.loaded(updatedList));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      debugPrint('Error updating staff: $e');
      emit(StaffState.errorUpdateStaff(LocaleKeys.staff_error_update.trnsltd));
    }
  }

  /// 📌 Delete staff
  Future<void> deleteStaff(String staffId) async {
    try {
      await _staffRepo.deleteStaff(staffId);

      final currentList = state.maybeWhen(
        loaded: (list) => list,
        orElse: () => <StaffModel>[],
      );

      final updatedList = currentList.where((s) => s.id != staffId).toList();

      emit(StaffState.loaded(updatedList));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      debugPrint('Error deleting staff: $e');
      emit(StaffState.errorUpdateStaff(LocaleKeys.staff_error_delete.trnsltd));
    }
  }

  /// 📌 Change password of staff
  Future<void> changePassword({
    required String staffId,
    required String fullName,
    required String newPassword,
  }) async {
    try {
      final success = await _staffRepo.changePassword(
        newPassword: newPassword,
        staffId: staffId,
      );

      if (success) {
        emit(
          StaffState.successChangePasswordStaff(
            LocaleKeys.staff_success_change_password.tr(
              namedArgs: {
                'name': fullName,
              },
            ),
          ),
        );
      } else {
        emit(
          StaffState.errorChangePasswordStaff(
            LocaleKeys.staff_error_change_password.trnsltd,
          ),
        );
      }
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      debugPrint('Error changing password: $e');
      emit(
        StaffState.errorChangePasswordStaff(
          LocaleKeys.staff_error_change_password.trnsltd,
        ),
      );
    }
  }
}
