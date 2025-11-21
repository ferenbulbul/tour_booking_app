import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/detailed_search/flow/screen/tour_search_detail_screen.dart';
import 'package:tour_booking/features/bookings/screen/bookings_screen.dart';
import 'package:tour_booking/features/auth/change_password/screen/change_password.dart';
import 'package:tour_booking/features/driver_home_page/screen/driver_home_page.dart';
import 'package:tour_booking/features/auth/email_verification/screen/email_verification_screen.dart';
import 'package:tour_booking/features/favorite/screen/favorite_screen.dart';
import 'package:tour_booking/features/auth/forgot_passwords/forgot_password/screen/forgot_password_screen.dart';
import 'package:tour_booking/features/auth/forgot_passwords/reset_password/screen/reset_password_screen.dart';
import 'package:tour_booking/features/auth/forgot_passwords/verify_reset_code/screen/%20verify_reset_code_screen.dart';
import 'package:tour_booking/features/google_map_test_page.dart';
import 'package:tour_booking/features/home/screen/nearby_tourpoiont.dart';
import 'package:tour_booking/features/home/screen/detail_search.dart';
import 'package:tour_booking/features/home/screen/tour_search_by_tour_type.dart';
import 'package:tour_booking/features/auth/login/screens/login_screen.dart';
import 'package:tour_booking/features/auth/phone_verification/screen/verify_phone_screen.dart';
import 'package:tour_booking/features/profile/screen/language_screen.dart';
import 'package:tour_booking/features/profile/screen/permission_screen.dart';
import 'package:tour_booking/features/profile/screen/profile_screen.dart';
import 'package:tour_booking/features/profile/screen/update_phone_screen.dart';
import 'package:tour_booking/features/root/wigdet/root_scaffold.dart';
import 'package:tour_booking/features/detailed_search/search/screen/search.dart';
import 'package:tour_booking/features/detailed_search/search_result/screen/tour_search_result.dart';
import 'package:tour_booking/features/detailed_search/flow/payment_viewmodel.dart';
import 'package:tour_booking/features/detailed_search/flow/screen/guides_screen.dart';
import 'package:tour_booking/features/detailed_search/flow/screen/payment_fail_screen.dart';
import 'package:tour_booking/features/detailed_search/flow/screen/payment_screen.dart';
import 'package:tour_booking/features/detailed_search/flow/screen/payment_success_screen.dart';
import 'package:tour_booking/features/detailed_search/flow/screen/summary_screen.dart';
import 'package:tour_booking/features/detailed_search/flow/screen/vehicle_list_screen.dart';
import 'package:tour_booking/features/detailed_search/flow/screen/vehicle_detail_screen.dart';
import 'package:tour_booking/features/detailed_search/flow/screen/google_place_saerch.dart';
import 'package:tour_booking/navigation/app_navigator.dart';
import '../features/splash/screen/splash_screen.dart';
import '../features/auth/register/screen/register_screen.dart';
import '../features/home/screen/home_screen.dart';

final RouteObserver<ModalRoute<void>> globalRouteObserver =
    RouteObserver<ModalRoute<void>>();
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
      pageBuilder: (context, state) {
        final data = state.extra;

        late final String tourPointId;
        String? initialImage;

        if (data is String) {
          // Eski kullanım: sadece ID
          tourPointId = data;
        } else if (data is Map<String, dynamic>) {
          tourPointId = data["id"] as String;
          // 🔥 GÖNDERDİĞİN KEY İLE AYNISI
          initialImage = data["initialImage"] as String?;
        } else {
          throw Exception('Invalid extra for searchDetail');
        }

        return MaterialPage(
          // 🔥 Her id için unique key — reuse olmasın
          key: ValueKey('searchDetail_$tourPointId'),
          child: TourSearchDetailScreen(
            tourPointId: tourPointId,
            initialImage: initialImage!, // 🔥 ARTIK GERÇEKTEN GÖNDERİYORUZ
          ),
        );
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
      path: '/verify-phone',
      name: 'verifyPhone',
      builder: (context, state) {
        return VerifyPhoneScreen();
      },
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) {
        final bookingId = state.extra as String;
        return ChangeNotifierProvider(
          create: (_) => PaymentViewModel(),
          child: PaymentPage(bookingId: bookingId),
        );
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
      name: "nearbyPoints",
      path: "/nearby-points",
      builder: (context, state) => const NearbyPointsPage(),
    ),

    GoRoute(
      path: '/driver',
      builder: (context, state) => const DriverHomePage(),
    ),
    GoRoute(
      path: '/change-password',
      name: 'changePassword',
      builder: (context, state) {
        return ChangePasswordScreen();
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
    GoRoute(
      path: '/payment-success',
      builder: (context, state) {
        final conversitationId = state.extra as String;
        return PaymentSuccessPage(conversitationId: conversitationId);
      },
    ),
    GoRoute(
      path: '/settings/language',
      builder: (context, state) => const LanguageSettingsScreen(),
    ),
    GoRoute(
      path: '/update-phone',
      builder: (context, state) => const UpdatePhoneScreen(),
    ),
    GoRoute(
      path: '/settings/permissions',
      builder: (context, state) => const PermissionsScreen(),
    ),
    GoRoute(
      path: '/past-bookings',
      builder: (context, state) => const BookingsScreen(),
    ),
    GoRoute(
      path: '/payment-fail',
      builder: (context, state) => const PaymentFailPage(),
    ),
    GoRoute(path: '/deneme', builder: (context, state) => const HomeScreen()),
    ShellRoute(
      builder: (context, state, child) {
        return RootScaffold(child: child);
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/favorite',
          builder: (context, state) => const FavoritePage(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const TourSearchScreen(),
        ),
        GoRoute(
          path: '/reservations',
          builder: (context, state) => const BookingsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) =>
              const GoogleMapTestPage(), //GoogleMapTestPage
        ),
      ],
    ),
  ],
);
