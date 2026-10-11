import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_setup.dart';
import '../enum/enum.dart';
import '../services/session_service.dart';
import 'access_repo.dart';
import 'user_access.dart';

sealed class AccessState {
  const AccessState();
}

class AccessLoading extends AccessState {
  const AccessLoading();
}

class AccessLoaded extends AccessState {
  const AccessLoaded(this.access);
  final UserAccess access;
}

class AccessError extends AccessState {
  const AccessError();
}

/// Loads the signed-in account's permissions and refreshes them periodically,
/// so a change made by an admin reaches open sessions without a restart.
class AccessCubit extends Cubit<AccessState> {
  AccessCubit({required AccessRepo accessRepo})
    : _accessRepo = accessRepo,
      super(const AccessLoading());

  static const _refreshInterval = Duration(minutes: 2);

  final AccessRepo _accessRepo;
  Timer? _refreshTimer;
  UserRole? _fallbackRole;

  UserAccess get access => switch (state) {
    AccessLoaded(:final access) => access,
    _ => UserAccess.none,
  };

  Future<void> load({UserRole? fallbackRole}) async {
    _fallbackRole = fallbackRole ?? _fallbackRole;
    _refreshTimer ??= Timer.periodic(_refreshInterval, (_) => _refresh());
    await _refresh(showLoading: state is! AccessLoaded);
  }

  Future<void> _refresh({bool showLoading = false}) async {
    if (showLoading) emit(const AccessLoading());
    try {
      final access = await _accessRepo.getMyAccess(fallbackRole: _fallbackRole);
      if (isClosed) return;
      emit(AccessLoaded(access));
    } catch (e) {
      if (getIt<SessionService>().handleIfExpired(e)) return;
      debugPrint('Failed to load access: $e');
      if (isClosed) return;
      // Keep the last known access on a failed background refresh.
      if (state is! AccessLoaded) emit(const AccessError());
    }
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
