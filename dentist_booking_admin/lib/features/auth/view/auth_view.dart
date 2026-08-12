import 'package:dentist_booking_admin/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_setup.dart';
import '../../../core/enum/enum.dart';
import '../../../core/util/util.dart';
import '../../../core/widgets/custom_title_bar.dart';
import '../blocs/auth/auth_cubit.dart';
import 'sign_in/view/sign_in_screen.dart';
import 'sign_in/widgets/account_status_screen.dart';
import 'sign_in/widgets/loading_sign_in.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => getIt<AuthCubit>(),
      child: Column(
        children: [
          CustomTitleBar(),
          Expanded(child: AuthView()),
        ],
      ),
    );
  }
}

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return current.maybeMap(
          error: (_) => true,
          orElse: () => false,
        );
      },
      buildWhen: (previous, current) {
        return current.maybeMap(
          loading: (_) => false,
          error: (_) => true,
          orElse: () => true,
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
      builder: (context, state) {
        return state.maybeMap(
          // Fallback: show login form until initialSession resolves
          initial: (_) => const SignInScreen(),

          // On Loading 🔄
          loading: (_) => _buildLoading(context),

          //On Login User ✅
          status: (auth) => _buildStatus(auth, context),

          //On Error ❌ ✅
          error: (error) => const SignInScreen(),

          //On Initial State 🔄
          orElse: () => const SignInScreen(),
        );
      },
    );
  }

  Widget _buildStatus(Status auth, BuildContext context) {
    if (auth.status != AuthStatus.authenticated) {
      return const SignInScreen();
    }

    final userStatus = auth.userStatus;

    if (userStatus == null) {
      return _buildLoading(context);
    }

    return switch (userStatus) {
      AccountStatus.active => MainWrapper(),
      AccountStatus.banned => const AccountStatusScreen(
        status: AccountStatus.banned,
      ),
      AccountStatus.suspended => const AccountStatusScreen(
        status: AccountStatus.suspended,
      ),
      AccountStatus.inactive => const AccountStatusScreen(
        status: AccountStatus.inactive,
      ),
      AccountStatus.paused => const AccountStatusScreen(
        status: AccountStatus.paused,
      ),
      AccountStatus.appMaintenance => const AccountStatusScreen(
        status: AccountStatus.appMaintenance,
      ),

      AccountStatus.resigned => const AccountStatusScreen(
        status: AccountStatus.appMaintenance,
      ),

      AccountStatus.vacation => const AccountStatusScreen(
        status: AccountStatus.appMaintenance,
      ),

      AccountStatus.terminated => const AccountStatusScreen(
        status: AccountStatus.appMaintenance,
      ),
    };
  }

  _buildLoading(BuildContext context) => LoadingSignIn();
}
