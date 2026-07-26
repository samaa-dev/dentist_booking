import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_setup.dart';
import '../../core/enum/enum.dart';
import '../../core/util/util.dart';
import '../../main_wrapper.dart';
import 'blocs/auth/auth_cubit.dart';
import 'screen/complete_profile_screen.dart';
import 'screen/sign_in_with_google_screen.dart';
import 'widget/loading_sign_in.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => getIt<AuthCubit>(),
      child: _AuthView(),
    );
  }
}

class _AuthView extends StatelessWidget {
  const _AuthView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return current.maybeMap(
          error: (_) => true,
          orElse: () => false,
        );
      },

      listener: (context, state) {
        state.maybeMap(
          error: (error) => SnackbarMes.showToastMsg(
            context,
            message: error.message,
          ),
          orElse: () => {},
        );
      },
      buildWhen: (previous, current) {
        return current.maybeMap(
          loading: (_) => false,
          error: (_) => false,
          orElse: () => true,
        );
      },
      builder: (context, state) {
        return state.maybeMap(
          //On Initial State 🔄
          initial: (_) => _buildLoading(context),

          // On Loading 🔄
          loading: (_) => _buildLoading(context),

          //On Login User ✅
          status: (auth) => _buildStatus(auth, context),

          //On Error ❌ ✅
          error: (error) => const SignInWithGoogleScreen(),

          //On Initial State 🔄
          orElse: () => const SignInWithGoogleScreen(),
        );
      },
    );
  }

  Widget _buildStatus(Status auth, BuildContext context) {
    if (auth.status != AuthStatus.authenticated) {
      return const SignInWithGoogleScreen();
    }

    if (auth.typeLogin == TypeLogin.guest) {
      return MainWrapper();
    }

    final profile = auth.data;

    if (auth.data == null) {
      return _buildLoading(context);
    }

    if (!_isCompleted(profile)) {
      return CompleteProfileScreen(
        profile: profile['raw_user_meta_data'] as Map<String, dynamic>,
      );
    }

    return MainWrapper();
  }

  bool _isCompleted(Map<String, dynamic>? profile) {
    if (profile == null) return false;

    final meta = profile['raw_user_meta_data'] as Map<String, dynamic>?;

    debugPrint('meta: $meta');

    if (meta == null) return false;

    final fullName = meta['full_name'] as String?;
    final phone = meta['phone'] as String?;
    final address = meta['address'] as String?;

    return (fullName?.isNotEmpty ?? false) && (phone?.isNotEmpty ?? false) && (address?.isNotEmpty ?? false);
  }

  _buildLoading(BuildContext context) => SplashScreen();
}
