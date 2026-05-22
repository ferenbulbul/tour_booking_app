import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/auth/change_password/change_password_viewmodel.dart';
import 'package:tour_booking/features/auth/email_verification/email_verification_viewmodel.dart';
import 'package:tour_booking/features/auth/forgot_passwords/forgot_password_viewmodel.dart';
import 'package:tour_booking/features/auth/login/login_viewmodel.dart';
import 'package:tour_booking/features/auth/phone_verification/verify_phone_viewmodel.dart';
import 'package:tour_booking/features/auth/register/register_viewmodel.dart';
import 'package:tour_booking/features/auth/change_password/screen/change_password.dart';
import 'package:tour_booking/features/auth/change_password/screen/change_password_driver.dart';
import 'package:tour_booking/features/auth/email_verification/screen/email_verification_screen.dart';
import 'package:tour_booking/features/auth/forgot_passwords/forgot_password/screen/forgot_password_screen.dart';
import 'package:tour_booking/features/auth/forgot_passwords/reset_password/screen/reset_password_screen.dart';
import 'package:tour_booking/features/auth/forgot_passwords/verify_reset_code/screen/verify_reset_code_screen.dart';
import 'package:tour_booking/features/auth/login/screen/login_screen.dart';
import 'package:tour_booking/features/auth/phone_verification/screen/verify_phone_screen.dart';
import 'package:tour_booking/features/auth/register/screen/register_screen.dart';
import 'package:tour_booking/features/auth/upgrade_account/screen/upgrade_account_screen.dart';
import 'package:tour_booking/features/auth/upgrade_account/upgrade_account_viewmodel.dart';

/// Authentication-related routes.
List<RouteBase> authRoutes() => [
      GoRoute(
        path: '/login',
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/email-confirmed',
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => EmailVerificationViewModel(),
          child: const EmailVerificationScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => RegisterViewModel(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => ForgotPasswordViewModel(),
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: '/verify-reset-code',
        builder: (context, state) {
          final email = state.extra is String ? state.extra as String : '';
          return ChangeNotifierProvider(
            create: (_) => ForgotPasswordViewModel(),
            child: VerifyResetCodeScreen(email: email),
          );
        },
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final email = state.extra is String ? state.extra as String : '';
          return ChangeNotifierProvider(
            create: (_) => ForgotPasswordViewModel(),
            child: ResetPasswordScreen(email: email),
          );
        },
      ),
      GoRoute(
        path: '/verify-phone',
        name: 'verifyPhone',
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => VerifyPhoneViewModel(),
          child: VerifyPhoneScreen(),
        ),
      ),
      GoRoute(
        path: '/change-password-driver',
        name: 'changePasswordDriver',
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => ChangePasswordViewModel(),
          child: ChangePasswordDriverScreen(),
        ),
      ),
      GoRoute(
        path: '/change-password',
        name: 'changePassword',
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => ChangePasswordViewModel(),
          child: ChangePasswordScreen(),
        ),
      ),
      GoRoute(
        path: '/upgrade-account',
        name: 'upgradeAccount',
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => UpgradeAccountViewModel(),
          child: const UpgradeAccountScreen(),
        ),
      ),
    ];
