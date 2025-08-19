import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/enum/search_type.dart';
import 'package:tour_booking/features/email_verification/screen/email_verification_screen.dart';
import 'package:tour_booking/features/favorite/screen/favorite_screen.dart';
import 'package:tour_booking/features/forgot_passwords/forgot_password/screen/forgot_password_screen.dart';
import 'package:tour_booking/features/forgot_passwords/reset_password/screen/reset_password_screen.dart';
import 'package:tour_booking/features/forgot_passwords/verify_reset_code/screen/%20verify_reset_code_screen.dart';
import 'package:tour_booking/features/home/widgets/detail_search.dart';
import 'package:tour_booking/features/home/widgets/tour_search_by_tour_type.dart';
import 'package:tour_booking/features/login/screens/login_screen.dart';
import 'package:tour_booking/features/profile/screen/profile_screen.dart';
import 'package:tour_booking/features/root/wigdet/root_scaffold.dart';
import 'package:tour_booking/features/search/screen/search.dart';
import 'package:tour_booking/features/search_result/screen/tour_search_result.dart';
import 'package:tour_booking/features/settings/screen/settings_screen.dart';
import 'package:tour_booking/features/tour_search_detail/screen/guides_screen.dart';
import 'package:tour_booking/features/tour_search_detail/screen/payment_screen.dart';
import 'package:tour_booking/features/tour_search_detail/screen/summary_screen.dart';
import 'package:tour_booking/features/tour_search_detail/screen/tour_search_detail_screen.dart';
import 'package:tour_booking/features/tour_search_detail/screen/tour_vehicle_list_screen.dart';
import 'package:tour_booking/features/tour_search_detail/screen/vehicle_detail_screen.dart';
import 'package:tour_booking/features/tour_search_detail/widget/place_saerch_widget.dart';
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
      path: '/verify-reset-code',
      builder: (context, state) {
        final email = state.extra as String;
        return VerifyResetCodeScreen(email: email);
      },
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) {
        final email = state.extra as String;
        return ResetPasswordScreen(email: email);
      },
    ),
    GoRoute(
      path: '/search-results',
      name: 'searchResults',
      builder: (context, state) {
        final type =
            int.tryParse(state.uri.queryParameters['type'] ?? '0') ?? 0;
        final regionId = state.uri.queryParameters['regionId'];
        final cityId = state.uri.queryParameters['cityId'];
        final districtId = state.uri.queryParameters['districtId'];

        return TourSearchResultsScreen(
          type: type,
          regionId: regionId,
          cityId: cityId,
          districtId: districtId,
        );
      },
    ),
    GoRoute(
      path: '/search-detail',
      name: 'searchDetail',
      builder: (context, state) {
        final tourPointId = state.extra as String;
        return TourSearchDetailScreen(tourPointId: tourPointId);
      },
    ),
    GoRoute(
      path: '/vehicle-list',
      name: 'vehicleList',
      builder: (context, state) {
        return TourVehicleListScreen();
      },
    ),
    GoRoute(
      path: '/vehicle-detail',
      name: 'vehicleDetail',
      builder: (context, state) {
        final vehicleId = state.extra as String;
        return VehicleDetailScreen(vehicleId: vehicleId);
      },
    ),
    GoRoute(
      path: '/search-guide',
      name: 'searchGuide',
      builder: (context, state) {
        return GuidesScreen();
      },
    ),
    GoRoute(
      path: '/summary',
      name: 'summary',
      builder: (context, state) {
        return SummaryScreen();
      },
    ),
    GoRoute(
      path: '/payment',
      name: 'payment',
      builder: (context, state) {
        return PaymentScreen();
      },
    ),
    GoRoute(
      name: 'placePicker',
      path: '/place-picker',
      builder: (context, state) => const PlacePickerPage(),
    ),
    GoRoute(
      path: '/search-location',
      name: 'searchLocation',
      builder: (context, state) {
        return DetailSearchLocationPage();
      },
    ),
    GoRoute(
      path: '/tour-search-by-type',
      name: 'tour-search-by-type',
      builder: (context, state) {
        final tourTypeId = state.uri.queryParameters['tourTypeId'];
        return TourSearchResultsByTourTypeScreen(tourTypeId: tourTypeId);
      },
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
          path: '/search',
          builder: (context, state) => const TourSearchScreen(),
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
