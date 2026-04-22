import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/features/auth/change_password/change_password_viewmodel.dart';
import 'package:tour_booking/features/auth/email_verification/widget/email_verification_view_model.dart';
import 'package:tour_booking/features/auth/forgot_passwords/forgot_password/widget/forgot_password_view_model.dart';
import 'package:tour_booking/features/auth/login/widgets/login_view_model.dart';
import 'package:tour_booking/features/auth/phone_verification/verify_phone_viewmodel.dart';
import 'package:tour_booking/features/auth/register/widgets/register_view_model.dart';
import 'package:tour_booking/features/auth/change_password/screen/change_password.dart';
import 'package:tour_booking/features/detailed_search/flow/screen/tour_search_detail_screen.dart';
import 'package:tour_booking/features/bookings/screen/bookings_screen.dart';
import 'package:tour_booking/features/auth/change_password/screen/change_password_driver.dart';
import 'package:tour_booking/features/driver_home_page/screen/driver_home_page.dart';
import 'package:tour_booking/features/auth/email_verification/screen/email_verification_screen.dart';
import 'package:tour_booking/features/favorite/screen/favorite_screen.dart';
import 'package:tour_booking/features/auth/forgot_passwords/forgot_password/screen/forgot_password_screen.dart';
import 'package:tour_booking/features/auth/forgot_passwords/reset_password/screen/reset_password_screen.dart';
import 'package:tour_booking/features/auth/forgot_passwords/verify_reset_code/screen/%20verify_reset_code_screen.dart';
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
import 'package:tour_booking/features/checkout/screen/contact_info_screen.dart';
import 'package:tour_booking/features/checkout/viewmodel/contact_info_viewmodel.dart';
import 'package:tour_booking/features/detailed_search/flow/tour_search_detail_viewmodel.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/features/auth/upgrade_account/screen/upgrade_account_screen.dart';
import 'package:tour_booking/features/auth/upgrade_account/widget/upgrade_account_viewmodel.dart';
import 'package:tour_booking/models/vehicle_detail_request/vehicle_detail_request.dart';
import 'package:tour_booking/features/transport/screen/transport_screen.dart';
import 'package:tour_booking/features/transport/screen/transport_vehicle_list_screen.dart';
import 'package:tour_booking/features/transport/screen/transport_summary_screen.dart';
import 'package:tour_booking/features/transport/screen/transport_vehicle_detail_screen.dart';
import 'package:tour_booking/features/transport/transport_viewmodel.dart';
import 'package:tour_booking/features/transport/transport_vehicle_list_viewmodel.dart';
import 'package:tour_booking/features/transport/transport_summary_viewmodel.dart';
import 'package:tour_booking/models/transport/search_vehicles_request/search_vehicles_request.dart';
import 'package:tour_booking/models/transport/transport_vehicle/transport_vehicle.dart';
import 'package:tour_booking/navigation/app_navigator.dart';
import '../features/splash/screen/splash_screen.dart';
import '../features/auth/register/screen/register_screen.dart';
import '../features/home/screen/home_screen.dart';

final RouteObserver<ModalRoute<void>> globalRouteObserver =
    RouteObserver<ModalRoute<void>>();
final SplashViewModel splashViewModel = SplashViewModel();
final GoRouter router = GoRouter(
  navigatorKey: appNavigatorKey,

  refreshListenable: splashViewModel, // ViewModel'i dinlemesi sart!
  debugLogDiagnostics: false,
  initialLocation: '/',

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

    // Login gerektirmeyen sayfalar
    final publicRoutes = [
      '/login',
      '/register',
      '/forgot-password',
      '/verify-reset-code',
      '/reset-password',
    ];

    debugPrint(
      'redirect | path=$path | loggedIn=$loggedIn | guest=$isGuestUser | deepLink=$isDeepLink',
    );

    // LOGIN YOKSA
    if (!loggedIn) {
      // Deep link geldiyse login'e yonlendir + redirect parami ekle
      if (isDeepLink) {
        final encoded = Uri.encodeComponent(state.uri.toString());
        return '/login?redirect=$encoded';
      }

      // Public route degilse login'e at
      if (!publicRoutes.contains(path)) {
        return '/login';
      }

      return null;
    }

    // GUEST KULLANICI — email dogrulamayi atla, direkt home'a git
    if (isGuestUser) {
      // Guest auth sayfalarinda olmamali (login/register disinda)
      if (publicRoutes.contains(path) || path == '/' || path == '/email-confirmed') {
        return '/home';
      }
      // Upgrade-account sayfasina gidebilir
      if (path == '/upgrade-account') {
        return null;
      }
      return null;
    }

    // NORMAL KULLANICI — EMAIL ONAYSIZ
    if (!isEmailConfirmed) {
      return path == '/email-confirmed' ? null : '/email-confirmed';
    }

    // LOGIN SONRASI DEEP LINK GERI DONUS
    if (redirectParam != null) {
      return Uri.decodeComponent(redirectParam);
    }

    // Auth sayfalarindan cikis
    if (publicRoutes.contains(path) || path == '/') {
      return role == UserRole.driver ? '/driver' : '/home';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

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
          // Eski kullanim: sadece ID
          tourPointId = data;
        } else if (data is Map<String, dynamic>) {
          tourPointId = data["id"] as String;
          initialImage = data["initialImage"] as String?;
        } else {
          return MaterialPage(key: state.pageKey, child: const HomeScreen());
        }

        return MaterialPage(
          key: ValueKey('searchDetail_$tourPointId'),
          child: TourSearchDetailScreen(
            tourPointId: tourPointId,
            initialImage: initialImage,
          ),
        );
      },
    ),
    GoRoute(
      path: '/tour/:id',
      name: 'tourDetailDeepLink',
      pageBuilder: (context, state) {
        final tourPointId = state.pathParameters['id']!;
        return MaterialPage(
          key: ValueKey('tourDetail_$tourPointId'),
          child: TourSearchDetailScreen(tourPointId: tourPointId),
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
        final args = state.extra;
        if (args is! VehicleDetailRequest) {
          return const TourSearchDetailScreen(tourPointId: '');
        }
        return VehicleDetailScreen(args: args);
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
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => VerifyPhoneViewModel(),
        child: VerifyPhoneScreen(),
      ),
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) {
        final rawBookingId = state.extra;
        final bookingId = rawBookingId is String ? rawBookingId : '';
        if (bookingId.isEmpty) return const HomeScreen();
        return ChangeNotifierProvider(
          create: (_) => PaymentViewModel(),
          child: PaymentPage(bookingId: bookingId),
        );
      },
    ),
    GoRoute(
      path: '/checkout/contact-info',
      name: 'contactInfo',
      builder: (context, state) {
        final bookingType = state.extra is String ? state.extra as String : 'tour';
        return ChangeNotifierProvider(
          create: (_) => ContactInfoViewModel(),
          child: ContactInfoScreen(
            onContinue: (firstName, lastName, email, phone) async {
              final nav = GoRouter.of(context);
              final messenger = ScaffoldMessenger.of(context);
              if (bookingType == 'transport') {
                final transportVm = context.read<TransportSummaryViewModel>();
                await transportVm.createBooking(
                  buyerFirstName: firstName,
                  buyerLastName: lastName,
                  buyerEmail: email,
                  buyerPhone: phone,
                );
                if (transportVm.bookingId != null && transportVm.bookingId!.isNotEmpty) {
                  nav.push('/payment', extra: transportVm.bookingId);
                } else if (transportVm.errorMessage != null) {
                  messenger.showSnackBar(
                    SnackBar(content: Text(transportVm.errorMessage!)),
                  );
                }
              } else {
                final tourVm = context.read<TourSearchDetailViewModel>();
                await tourVm.ControlBooking(
                  buyerFirstName: firstName,
                  buyerLastName: lastName,
                  buyerEmail: email,
                  buyerPhone: phone,
                );
                if (tourVm.isValid && tourVm.bookingId != null) {
                  nav.push('/payment', extra: tourVm.bookingId);
                } else if (tourVm.errorMessage != null) {
                  messenger.showSnackBar(
                    SnackBar(content: Text(tourVm.errorMessage!)),
                  );
                }
              }
            },
          ),
        );
      },
    ),
    GoRoute(
      name: 'placePicker',
      path: '/place-picker',
      builder: (context, state) {
        final params = state.extra is Map
            ? Map<String, dynamic>.from(state.extra as Map)
            : <String, dynamic>{};

        return PlacePickerPage(
          city: params['city'],
          district: params['district'],
        );
      },
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
        final conversitationId = state.extra is String ? state.extra as String : '';
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
      name: 'permissionsSettings',
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

    // --- Upgrade Account ---
    GoRoute(
      path: '/upgrade-account',
      name: 'upgradeAccount',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => UpgradeAccountViewModel(),
        child: const UpgradeAccountScreen(),
      ),
    ),

    // --- Transport Routes ---
    GoRoute(
      path: '/transport',
      name: 'transport',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => TransportViewModel(),
        child: const TransportScreen(),
      ),
    ),
    GoRoute(
      path: '/transport-vehicles',
      name: 'transportVehicles',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final request = TransportSearchVehiclesRequest.fromJson(
          args['request'] as Map<String, dynamic>,
        );
        return ChangeNotifierProvider(
          create: (_) => TransportVehicleListViewModel()
            ..searchVehicles(request),
          child: TransportVehicleListScreen(searchContext: args),
        );
      },
    ),
    GoRoute(
      path: '/transport-vehicle-detail',
      name: 'transportVehicleDetail',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final vehicle = args['vehicle'] as TransportVehicle;
        return TransportVehicleDetailScreen(
          vehicle: vehicle,
          searchContext: args,
        );
      },
    ),
    GoRoute(
      path: '/transport-summary',
      name: 'transportSummary',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final vehicle = args['vehicle'] as TransportVehicle;
        return ChangeNotifierProvider(
          create: (_) => TransportSummaryViewModel()
            ..setContext(
              vehicle: vehicle,
              pickup: args['pickupAddress'] as String?,
              pLat: args['pickupLat'] as double?,
              pLng: args['pickupLng'] as double?,
              dropoff: args['dropoffAddress'] as String?,
              dLat: args['dropoffLat'] as double?,
              dLng: args['dropoffLng'] as double?,
              date: args['date'] != null
                  ? DateTime.parse(args['date'] as String)
                  : null,
              time: args['time'] as String?,
              distanceKm: args['clientDistanceKm'] as double?,
              durationMinutes: args['clientDurationMinutes'] as int?,
            ),
          child: const TransportSummaryScreen(),
        );
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
              const ProfileScreen(), //GoogleMapTestPage
        ),
      ],
    ),
  ],
);
