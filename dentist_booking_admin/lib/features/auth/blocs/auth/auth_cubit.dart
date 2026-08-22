// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gotrue/gotrue.dart' as gotrue;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/enum/enum.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/util/session_guard.dart';
import '../../repo/sign_in_repo.dart';
import '../../repo/credentials_store.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInRepo _signInRepo;
  final CredentialsStore _credentialsStore;
  final SessionService _sessionService;

  late final StreamSubscription<gotrue.AuthState> _authSubscription;
  StreamSubscription<void>? _sessionExpiredSubscription;
  StreamSubscription<Map<String, dynamic>>? _profileSubscription;

  bool _handlingSessionExpiry = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool rememberMe = false;
  bool hasSavedCredentials = false;

  AuthCubit({
    required SignInRepo signInRepo,
    required SupabaseClient client,
    required CredentialsStore credentialsStore,
    required SessionService sessionService,
  }) : _signInRepo = signInRepo,
       _credentialsStore = credentialsStore,
       _sessionService = sessionService,
       super(const AuthState.initial()) {
    _sessionExpiredSubscription =
        _sessionService.onExpired.listen((_) => handleSessionExpired());
    _listenToAuthChanges();
    // Load saved email/password for "Remember me"
    // ignore: unawaited_futures
    _loadSavedCredentials();
  }

  Future<void> _listenToAuthChanges() async {
    _authSubscription = _signInRepo.authStateChanges.listen(
      (auth) async {
        if (!await InternetConnection().hasInternetAccess) {
          _emitNoInternet();
          return;
        }

        switch (auth.event) {
          case AuthChangeEvent.initialSession:
          case AuthChangeEvent.signedIn:
          case AuthChangeEvent.userUpdated:
            if (auth.session == null) {
              _handleNoSession();
              return;
            }
            emit(const AuthState.status(status: AuthStatus.authenticated));
            await _updateUserStatus(auth.session!.user.id);

          case AuthChangeEvent.tokenRefreshed:
            break;

          case AuthChangeEvent.signedOut:
          case AuthChangeEvent.userDeleted:
            _handleNoSession();

          default:
            break;
        }
      },
      onError: (e) => _handleStreamError(e),
    );
  }

  //Update User Status
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

      final profile = await _signInRepo.fetchProfileOnce(userId);
      _emitProfileStatus(profile);

      await _profileSubscription?.cancel();
      _profileSubscription = _signInRepo
          .getProfile(userId)
          .listen(
            _emitProfileStatus,
            onError: (e) => _handleProfileError(e),
            onDone: () => _profileSubscription = null,
          );
    } catch (e) {
      debugPrint('🔥 Error aa: $e');
      // _emitError("❌ Failed to update user status.");
      _emitError(LocaleKeys.failed_to_update_user_status.trnsltd);
      _handleNoSession();
    }
  }

  Future<void> _loadSavedCredentials() async {
    final hasSaved = await _credentialsStore.hasSaved();
    if (!hasSaved) return;

    final loaded = await _credentialsStore.load();
    emailController.text = loaded.email ?? '';
    passwordController.text = loaded.password ?? '';

    rememberMe = true;
    hasSavedCredentials = true;
  }

  void toggleRememberMe() {
    rememberMe = !rememberMe;
  }

  Future<void> clearSavedCredentials() async {
    await _credentialsStore.clear();
    emailController.clear();
    passwordController.clear();
    rememberMe = false;
    hasSavedCredentials = false;
  }

  //Sign In With Email And Password
  Future<void> signInWithEmailAndPassword() async {
    emit(const AuthState.loading());

    // Validation
    if (emailController.text.trim().isEmpty) {
      _emitError(LocaleKeys.email_cant_be_empty.trnsltd);
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      _emitError(LocaleKeys.password_cant_be_empty.trnsltd);
      return;
    }

    try {
      final ok = await _signInRepo.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!ok || _signInRepo.currentSession == null) {
        _emitError(LocaleKeys.invalid_email_or_password.trnsltd);

        // Allow snackBar to show before changing state
        await Future.delayed(const Duration(milliseconds: 50));

        _handleNoSession();
        return;
      }

      final userId = _signInRepo.currentSession!.user.id;
      await _updateUserStatus(userId);

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (rememberMe) {
        await _credentialsStore.save(email, password);
        hasSavedCredentials = true;
      } else {
        await _credentialsStore.clear();
        hasSavedCredentials = false;
      }
    } catch (e, stack) {
      debugPrint('📜 Stack trace: $stack');

      _emitError(LocaleKeys.failed_to_sign_in.trnsltd);

      await Future.delayed(const Duration(milliseconds: 50));
      _handleNoSession();
    }
  }

  //Sign Out
  Future<void> signOut() async {
    emit(const AuthState.loading());
    try {
      await _signInRepo.signOut();
      emit(const AuthState.status(status: AuthStatus.unauthenticated));
    } catch (e) {
      // _emitError(SupabaseErrorHandler.getFriendlyMessage(e));
    }
    // await _cleanupSubscriptions();
  }

  Future<void> handleSessionExpired() async {
    if (_handlingSessionExpiry) return;
    _handlingSessionExpiry = true;

    try {
      try {
        await _signInRepo.signOut();
      } catch (_) {}

      _emitError(LocaleKeys.session_expired.trnsltd);
      await Future.delayed(const Duration(milliseconds: 50));
      _handleNoSession();
    } finally {
      _handlingSessionExpiry = false;
    }
  }

  void _emitProfileStatus(Map<String, dynamic> profile) {
    final userStatus = (profile['status'] as String?).toAccountStatus();
    final userRole = (profile['role'] as String?).toUserRole();

    emit(
      AuthState.status(
        status: AuthStatus.authenticated,
        userStatus: userStatus,
        userRole: userRole,
      ),
    );
  }

  //Emitters for Errors
  void _emitError(String msg) => emit(AuthState.error(message: msg));

  //Emitters for No Internet
  void _emitNoInternet() {
    _emitError(
      LocaleKeys.no_internet_connection.trnsltd,
    );
  }

  //Cleanup Subscriptions
  void _handleNoSession() async {
    emit(const AuthState.status(status: AuthStatus.unauthenticated));
  }

  void _handleStreamError(dynamic e) {
    if (SessionGuard.isAuthError(e)) {
      handleSessionExpired();
    }
  }

  void _handleProfileError(dynamic e) {
    if (SessionGuard.isAuthError(e)) {
      handleSessionExpired();
    }
  }

  @override
  Future<void> close() async {
    await _sessionExpiredSubscription?.cancel();
    await _authSubscription.cancel();
    await _profileSubscription?.cancel();
    return super.close();
  }
}
