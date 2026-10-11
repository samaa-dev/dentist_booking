import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_setup.dart';
import '../../../../core/extensions/os_extensions.dart';
import '../../../../core/model/staff_member.dart';
import '../../../../core/services/session_service.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../repo/staff_repo.dart';

sealed class StaffState {
  const StaffState();
}

class StaffLoading extends StaffState {
  const StaffLoading();
}

class StaffLoaded extends StaffState {
  const StaffLoaded(this.members);
  final List<StaffMember> members;
}

class StaffError extends StaffState {
  const StaffError(this.message);
  final String message;
}

/// Staff management (admin only). Each action returns `null` on success or a
/// translated error message, so dialogs can show the error in place.
class StaffCubit extends Cubit<StaffState> {
  StaffCubit({required StaffRepo staffRepo})
    : _staffRepo = staffRepo,
      super(const StaffLoading());

  final StaffRepo _staffRepo;

  Future<void> load({bool showLoading = true}) async {
    if (showLoading) emit(const StaffLoading());
    try {
      final members = await _staffRepo.getStaff();
      if (!isClosed) emit(StaffLoaded(members));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      if (!isClosed) emit(StaffError(LocaleKeys.staff_error_load.trnsltd));
    }
  }

  Future<String?> create(StaffDraft draft) =>
      _run(() => _staffRepo.createStaff(draft));

  Future<String?> update(String id, StaffDraft draft) =>
      _run(() => _staffRepo.updateStaff(id, draft));

  Future<String?> setActive(String id, {required bool active}) =>
      _run(() => _staffRepo.setActive(id, active: active));

  Future<String?> setPassword(String userId, String password) =>
      _run(() => _staffRepo.setPassword(userId, password), reload: false);

  Future<String?> delete(String id) => _run(() => _staffRepo.deleteStaff(id));

  Future<String?> _run(Future<void> Function() action, {bool reload = true}) async {
    try {
      await action();
      if (reload) await load(showLoading: false);
      return null;
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return null;
      return _messageFor(e);
    }
  }

  static String _messageFor(Object e) {
    final code = e is StaffActionException ? e.code : 'unknown';
    return switch (code) {
      'invalid_email' => LocaleKeys.staff_err_invalid_email.trnsltd,
      'password_too_short' => LocaleKeys.staff_err_password_short.trnsltd,
      'full_name_required' => LocaleKeys.required_field.trnsltd,
      'email_in_use' => LocaleKeys.staff_err_email_in_use.trnsltd,
      'already_staff' => LocaleKeys.staff_err_already_staff.trnsltd,
      'forbidden' => LocaleKeys.staff_err_forbidden.trnsltd,
      'staff_not_found' => LocaleKeys.staff_err_not_found.trnsltd,
      _ => LocaleKeys.staff_err_unknown.trnsltd,
    };
  }
}
