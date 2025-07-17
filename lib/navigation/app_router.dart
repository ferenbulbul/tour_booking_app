import 'package:go_router/go_router.dart';
import 'package:tour_booking/features/email_verification/screen/email_verification_screen.dart';
import 'package:tour_booking/features/favorite/screen/favorite_screen.dart';
import 'package:tour_booking/features/forgot_password/screen/forgot_password_screen.dart';
import 'package:tour_booking/features/login/screens/login_screen.dart';
import 'package:tour_booking/features/profile/screen/profile_screen.dart';
import 'package:tour_booking/features/root/wigdet/root_scaffold.dart';
import 'package:tour_booking/features/settings/screen/settings_screen.dart';
import 'package:tour_booking/navigation/app_navigator.dart';
import '../features/splash/screen/splash_screen.dart';
import '../features/register/screen/register_screen.dart';
import '../features/home/screen/home_screen.dart';

final GoRouter router = GoRouter(
  navigatorKey: appNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/email-confirmed',
      builder: (context, state) => const EmailVerificationScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return RootScaffold(child: child);
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/favorite',
          builder: (context, state) => const FavoriteScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
