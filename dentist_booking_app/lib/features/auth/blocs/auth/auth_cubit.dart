// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/core/services/push_notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gotrue/gotrue.dart' as gotrue;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/enum/enum.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../repo/sign_in_repo.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInRepo _signInRepo;
  final PushNotificationService? _pushNotificationService;

  late final StreamSubscription<gotrue.AuthState> _authSubscription;
  StreamSubscription<Map<String, dynamic>>? _profileSubscription;

  AuthCubit({
    required SignInRepo signInRepo,
    required SupabaseClient client,
    PushNotificationService? pushNotificationService,
  }) : _signInRepo = signInRepo,
       _pushNotificationService = pushNotificationService,
       super(const AuthState.initial()) {
    _listenToAuthChanges();
  }

  gotrue.User? currentUser() => _signInRepo.currentSession?.user;

  Future<void> _listenToAuthChanges() async {
    _authSubscription = _signInRepo.authStateChanges.listen(
      (auth) async {
        if (!await InternetConnection().hasInternetAccess) {
          _emitNoInternet();
          return;
        }

        final session = auth.session;
        if (session == null) {
          _handleNoSession();
          return;
        }

        final userId = session.user.id;
        emit(const AuthState.status(status: AuthStatus.authenticated));

        await _updateUserStatus(userId);
      },
      onError: (e) => _emitError(LocaleKeys.failed_to_sign_in.trnsltd),
    );
  }

  Future<void> signInGoogle() async {
    emit(const AuthState.loading());

    try {
      final ok = await _signInRepo.signInWithGoogle();

      if (!ok || _signInRepo.currentSession == null) {
        _emitError(LocaleKeys.failed_to_sign_in.trnsltd);

        // Allow snackBar to show before changing state
        await Future.delayed(const Duration(milliseconds: 50));

        _handleNoSession();
        return;
      }

      final userId = _signInRepo.currentSession!.user.id;
      await _updateUserStatus(userId);
    } catch (e, stack) {
      debugPrint('📜 Stack trace: $stack');
      _emitError(LocaleKeys.failed_to_sign_in.trnsltd);
      await Future.delayed(const Duration(milliseconds: 50));
      _handleNoSession();
    }
  }

  Future<void> signInGuest() async {
    emit(
      AuthState.status(
        status: AuthStatus.authenticated,
        typeLogin: TypeLogin.guest,
      ),
    );
  }

  Future<void> _updateUserStatus(String userId) async {
    if (!await InternetConnection().hasInternetAccess) return;

    final session = _signInRepo.currentSession;
    if (session == null) {
      _handleNoSession();
      return;
    }

    debugPrint('🔥 User Id: $userId');

    // Best-effort only; must not block sign-in.
    await _signInRepo.updateLastSeen(userId);

    try {
      final profile = await _signInRepo.fetchProfileOnce(userId);
      if (profile == null || profile.isEmpty) {
        debugPrint('🔥 Profile not found for $userId');
        _emitError(LocaleKeys.profile_not_found.trnsltd);
        // Keep session; do not force logout — profile may be created shortly.
        emit(
          const AuthState.status(
            status: AuthStatus.authenticated,
            typeLogin: TypeLogin.google,
          ),
        );
        _listenToProfileUpdates(userId);
        return;
      }

      _emitAuthenticatedFromProfile(profile);
      _registerPushSafely();
      _listenToProfileUpdates(userId);
    } catch (e, st) {
      debugPrint('🔥 Error loading profile: $e\n$st');
      _emitError(LocaleKeys.failed_to_update_user_status.trnsltd);
      // Keep authenticated shell if session is valid; Realtime may recover.
      emit(
        const AuthState.status(
          status: AuthStatus.authenticated,
          typeLogin: TypeLogin.google,
        ),
      );
      _listenToProfileUpdates(userId);
    }
  }

  void _emitAuthenticatedFromProfile(Map<String, dynamic> profile) {
    final userStatus = (profile['status'] as String?).toAccountStatus();
    final userRole = (profile['role'] as String?).toUserRole();

    emit(
      AuthState.status(
        status: AuthStatus.authenticated,
        userStatus: userStatus,
        userRole: userRole,
        data: profile['meta'],
        typeLogin: TypeLogin.google,
      ),
    );
  }

  void _listenToProfileUpdates(String userId) {
    unawaited(_profileSubscription?.cancel());
    _profileSubscription = _signInRepo.getProfile(userId).listen(
      (profile) {
        if (profile.isEmpty) return;
        _emitAuthenticatedFromProfile(profile);
      },
      onError: (e, st) {
        debugPrint('🔥 Profile stream error (non-fatal): $e\n$st');
      },
      onDone: () => _profileSubscription = null,
    );
  }

  void _registerPushSafely() {
    final push = _pushNotificationService;
    if (push == null) return;
    unawaited(() async {
      try {
        await push.requestPermissionAndRegister();
      } catch (e, st) {
        debugPrint('Push register failed (non-fatal): $e\n$st');
      }
    }());
  }

  Future<void> signOut() async {
    emit(const AuthState.loading());
    try {
      await _pushNotificationService?.unregisterCurrentToken();
    } catch (e) {
      debugPrint('Push unregister failed: $e');
    }
    await _signInRepo.signOut();
    emit(const AuthState.status(status: AuthStatus.unauthenticated));
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final ok = await _signInRepo.updateProfile(data);

      if (ok) {
        final currentStatus = state.mapOrNull(status: (s) => s);
        if (currentStatus != null) {
          final meta = currentStatus.data is Map
              ? Map<String, dynamic>.from(currentStatus.data as Map)
              : <String, dynamic>{};
          final raw = meta['raw_user_meta_data'] is Map
              ? Map<String, dynamic>.from(meta['raw_user_meta_data'] as Map)
              : <String, dynamic>{};
          final newRaw = {...raw, ...data};
          final newMeta = {...meta, 'raw_user_meta_data': newRaw};
          emit(currentStatus.copyWith(data: newMeta));
        }
      }

      return ok;
    } catch (e) {
      debugPrint("❌ Update profile error: $e");
      _emitError(LocaleKeys.update_profile_success.trnsltd);
      return false;
    }
  }

  void _emitError(String msg) => emit(AuthState.error(message: msg));
  void _emitNoInternet() => _emitError(LocaleKeys.no_internet_connection.trnsltd);
  void _handleNoSession({
    TypeLogin? type = TypeLogin.google,
  }) async {
    emit(
      AuthState.status(
        status: AuthStatus.unauthenticated,
        typeLogin: type,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _authSubscription.cancel();
    await _profileSubscription?.cancel();
    return super.close();
  }
}
