import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/features/bookings/screen/bookings_screen.dart';
import 'package:tour_booking/features/driver_home_page/screen/driver_home_page.dart';
import 'package:tour_booking/features/driver_home_page/screen/driver_profile_screen.dart';
import 'package:tour_booking/features/favorite/screen/favorite_screen.dart';
import 'package:tour_booking/features/home/screen/home_screen.dart';
import 'package:tour_booking/features/onboarding/screen/onboarding_screen.dart';
import 'package:tour_booking/features/profile/screen/profile_screen.dart';
import 'package:tour_booking/features/root/screen/error_screen.dart';
import 'package:tour_booking/features/root/widget/root_scaffold.dart';
import 'package:tour_booking/features/splash/screen/splash_screen.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/features/transport/screen/transport_screen.dart';
import 'package:tour_booking/features/transport/transport_viewmodel.dart';
import 'package:tour_booking/navigation/app_navigator.dart';
import 'package:tour_booking/navigation/routes/auth_routes.dart';
import 'package:tour_booking/navigation/routes/checkout_routes.dart';
import 'package:tour_booking/navigation/routes/profile_routes.dart';
import 'package:tour_booking/navigation/routes/tour_routes.dart';
import 'package:tour_booking/navigation/routes/transport_routes.dart';

final RouteObserver<ModalRoute<void>> globalRouteObserver =
    RouteObserver<ModalRoute<void>>();
final SplashViewModel splashViewModel = SplashViewModel();
final GoRouter router = GoRouter(
  navigatorKey: appNavigatorKey,

  refreshListenable: splashViewModel, // Must listen to ViewModel!
  debugLogDiagnostics: false,
  initialLocation: '/',
  errorBuilder: (context, state) => ErrorScreen(error: state.error),

  redirect: (context, state) {
    final splashVM = splashViewModel;

    if (splashVM.isChecking) return null;

    final bool loggedIn = splashVM.isLoggedInStatus;
    final bool isEmailConfirmed = splashVM.user?.emailConfirmed ?? false;
    final bool isGuestUser = splashVM.isGuest;
    final UserRole? role = splashVM.role;

    final String path = state.uri.path;
    final bool isDeepLink = path.startsWith('/tour/');
    final redirectParam = state.uri.queryParameters['redirect'];

    // Auth pages (except login -- login is now a bottom sheet)
    final authPaths = [
      '/register',
      '/forgot-password',
      '/verify-reset-code',
      '/reset-password',
    ];

    debugPrint(
      'redirect | path=$path | loggedIn=$loggedIn | guest=$isGuestUser | deepLink=$isDeepLink',
    );

    // Redirect all /login requests to /home -- login is now a bottom sheet
    if (path == '/login') {
      return '/home';
    }

    // ONBOARDING CHECK
    if (splashVM.shouldShowOnboarding) {
      if (path != '/onboarding') return '/onboarding';
      return null;
    }
    // Seen onboarding but still on that page
    if (path == '/onboarding') {
      return role == UserRole.driver ? '/driver' : '/home';
    }

    // NOT LOGGED IN -- guest sign-in is always performed, this case is rare
    if (!loggedIn) {
      if (path == '/' || !authPaths.contains(path)) {
        return '/home';
      }
      return null;
    }

    // GUEST USER -- skip email verification, go directly to home
    if (isGuestUser) {
      if (path == '/' || path == '/email-confirmed') {
        return '/home';
      }
      return null;
    }

    // NORMAL USER -- EMAIL NOT CONFIRMED
    if (!isEmailConfirmed) {
      return path == '/email-confirmed' ? null : '/email-confirmed';
    }

    // POST-LOGIN DEEP LINK RETURN
    if (redirectParam != null) {
      return Uri.decodeComponent(redirectParam);
    }

    // Exit from auth/splash pages
    if (authPaths.contains(path) || path == '/') {
      return role == UserRole.driver ? '/driver' : '/home';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/driver',
      builder: (context, state) => const DriverHomeScreen(),
    ),
    GoRoute(
      path: '/driver-profile',
      builder: (context, state) => const DriverProfileScreen(),
    ),
    GoRoute(
      path: '/past-bookings',
      builder: (context, state) => const BookingsScreen(),
    ),

    // Extracted route groups
    ...authRoutes(),
    ...tourRoutes(),
    ...transportRoutes(),
    ...checkoutRoutes(),
    ...profileRoutes(),

    // Shell route (bottom navigation)
    ShellRoute(
      builder: (context, state, child) {
        return RootScaffold(child: child);
      },
      routes: [
        GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/favorite',
          builder: (context, state) => const FavoriteScreen(),
        ),
        GoRoute(
          path: '/transport',
          name: 'transportTab',
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => TransportViewModel(),
            child: const TransportScreen(),
          ),
        ),
        GoRoute(
          path: '/reservations',
          builder: (context, state) => const BookingsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
