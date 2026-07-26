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
import '../../repo/sign_in_repo.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInRepo _signInRepo;

  late final StreamSubscription<gotrue.AuthState> _authSubscription;
  StreamSubscription<Map<String, dynamic>>? _profileSubscription;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AuthCubit({
    required SignInRepo signInRepo,
    required SupabaseClient client,
  }) : _signInRepo = signInRepo,
       super(const AuthState.initial()) {
    _listenToAuthChanges();
  }

  //Listeners Changes in AuthState
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

      await _profileSubscription?.cancel();
      _profileSubscription = _signInRepo
          .getProfile(userId)
          .listen(
            (profile) {
              final userStatus = (profile['status'] as String?)
                  .toAccountStatus();
              final userRole = (profile['role'] as String?).toUserRole();

              emit(
                AuthState.status(
                  status: AuthStatus.authenticated,
                  userStatus: userStatus,
                  userRole: userRole,
                ),
              );
            },
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

  //Handle Errors
  void _handleStreamError(dynamic e) {
    // // final msg = SupabaseErrorHandler.getFriendlyMessage(e);
    // if (msg.toLowerCase().contains("timeout") ||
    //     msg.toLowerCase().contains("connection")) {
    //   _emitNoInternet();
    // } else {
    //   _emitError(msg);
    // }
  }

  //Handle Profile Errors
  void _handleProfileError(dynamic e) {
    // final msg = SupabaseErrorHandler.getFriendlyMessage(e);
    // if (!msg.toLowerCase().contains("connection")) {
    //   _emitError(msg);
    // }
  }

  @override
  Future<void> close() async {
    await _authSubscription.cancel();
    await _profileSubscription?.cancel();
    return super.close();
  }
}
