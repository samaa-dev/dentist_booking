// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
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

  late final StreamSubscription<gotrue.AuthState> _authSubscription;
  StreamSubscription<Map<String, dynamic>>? _profileSubscription;

  AuthCubit({
    required SignInRepo signInRepo,
    required SupabaseClient client,
  }) : _signInRepo = signInRepo,
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

    try {
      await _signInRepo.updateLastSeen(userId);

      await _profileSubscription?.cancel();
      _profileSubscription = _signInRepo
          .getProfile(userId)
          .listen(
            (profile) {
              final userStatus = (profile['status'] as String?).toAccountStatus();

              final userRole = (profile['role'] as String?).toUserRole();

              //

              emit(
                AuthState.status(
                  status: AuthStatus.authenticated,
                  userStatus: userStatus,
                  userRole: userRole,
                  data: profile['meta'],
                  typeLogin: TypeLogin.google,
                ),
              );
            },
            onError: (e) => _emitError(LocaleKeys.failed_to_update_user_status.trnsltd),
            onDone: () => _profileSubscription = null,
          );
    } catch (e) {
      debugPrint('🔥 Error aa: $e');
      _emitError(LocaleKeys.failed_to_update_user_status.trnsltd);
      _handleNoSession();
    }
  }

  Future<void> signOut() async {
    emit(const AuthState.loading());
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
