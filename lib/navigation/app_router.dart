import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/features/auth/change_password/change_password_viewmodel.dart';
import 'package:tour_booking/features/auth/email_verification/email_verification_viewmodel.dart';
import 'package:tour_booking/features/auth/forgot_passwords/forgot_password_viewmodel.dart';
import 'package:tour_booking/features/auth/login/login_viewmodel.dart';
import 'package:tour_booking/features/auth/phone_verification/verify_phone_viewmodel.dart';
import 'package:tour_booking/features/auth/register/register_viewmodel.dart';
import 'package:tour_booking/features/auth/change_password/screen/change_password.dart';
import 'package:tour_booking/features/tour/booking/screen/tour_search_detail_screen.dart';
import 'package:tour_booking/features/bookings/screen/bookings_screen.dart';
import 'package:tour_booking/features/auth/change_password/screen/change_password_driver.dart';
import 'package:tour_booking/features/driver_home_page/screen/driver_home_page.dart';
import 'package:tour_booking/features/auth/email_verification/screen/email_verification_screen.dart';
import 'package:tour_booking/features/favorite/screen/favorite_screen.dart';
import 'package:tour_booking/features/auth/forgot_passwords/forgot_password/screen/forgot_password_screen.dart';
import 'package:tour_booking/features/auth/forgot_passwords/reset_password/screen/reset_password_screen.dart';
import 'package:tour_booking/features/auth/forgot_passwords/verify_reset_code/screen/verify_reset_code_screen.dart';
import 'package:tour_booking/features/home/screen/nearby_tourpoint.dart';
import 'package:tour_booking/features/home/screen/detail_search.dart';
import 'package:tour_booking/features/home/screen/tour_search_by_tour_type.dart';
import 'package:tour_booking/features/auth/login/screen/login_screen.dart';
import 'package:tour_booking/features/auth/phone_verification/screen/verify_phone_screen.dart';
import 'package:tour_booking/features/profile/screen/language_screen.dart';
import 'package:tour_booking/features/profile/screen/legal_detail_screen.dart';
import 'package:tour_booking/features/profile/screen/permission_screen.dart';
import 'package:tour_booking/features/profile/screen/profile_screen.dart';
import 'package:tour_booking/core/constants/legal_texts.dart';
import 'package:tour_booking/features/profile/screen/personal_info_screen.dart';
import 'package:tour_booking/features/profile/screen/update_phone_screen.dart';
import 'package:tour_booking/features/root/widget/root_scaffold.dart';
import 'package:tour_booking/features/tour/search_result/screen/tour_search_result.dart';
import 'package:tour_booking/features/tour/booking/payment_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/screen/guides_screen.dart';
import 'package:tour_booking/features/tour/booking/screen/payment_fail_screen.dart';
import 'package:tour_booking/features/tour/booking/screen/payment_screen.dart';
import 'package:tour_booking/features/tour/booking/screen/payment_success_screen.dart';
import 'package:tour_booking/features/tour/booking/screen/summary_screen.dart';
import 'package:tour_booking/features/tour/booking/screen/vehicle_list_screen.dart';
import 'package:tour_booking/features/tour/booking/screen/vehicle_detail_screen.dart';
import 'package:tour_booking/features/tour/booking/screen/google_place_search.dart';
import 'package:tour_booking/features/checkout/screen/contact_info_screen.dart';
import 'package:tour_booking/features/checkout/viewmodel/contact_info_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_detail_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_booking_selection_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_vehicle_guide_viewmodel.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/features/auth/upgrade_account/screen/upgrade_account_screen.dart';
import 'package:tour_booking/features/auth/upgrade_account/upgrade_account_viewmodel.dart';
import 'package:tour_booking/models/vehicle_detail_request/vehicle_detail_request.dart';
import 'package:tour_booking/features/transport/screen/transport_screen.dart';
import 'package:tour_booking/features/transport/screen/transport_vehicle_list_screen.dart';
import 'package:tour_booking/features/transport/screen/transport_summary_screen.dart';
import 'package:tour_booking/features/transport/transport_viewmodel.dart';
import 'package:tour_booking/features/transport/transport_vehicle_list_viewmodel.dart';
import 'package:tour_booking/features/transport/transport_summary_viewmodel.dart';
import 'package:tour_booking/models/transport/search_vehicles_request/search_vehicles_request.dart';
import 'package:tour_booking/models/transport/transport_vehicle/transport_vehicle.dart';
import 'package:tour_booking/navigation/app_navigator.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import '../features/onboarding/screen/onboarding_screen.dart';
import '../features/splash/screen/splash_screen.dart';
import '../features/auth/register/screen/register_screen.dart';
import '../features/home/screen/home_screen.dart';
import 'package:tour_booking/features/tour/search/screen/search.dart';
import 'package:tour_booking/features/home/screen/all_featured_screen.dart';

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

    // Auth sayfalar (login haric — login artik bottom sheet)
    final authRoutes = [
      '/register',
      '/forgot-password',
      '/verify-reset-code',
      '/reset-password',
    ];

    debugPrint(
      'redirect | path=$path | loggedIn=$loggedIn | guest=$isGuestUser | deepLink=$isDeepLink',
    );

    // /login'e gelen her istegi /home'a yonlendir — login artik bottom sheet
    if (path == '/login') {
      return '/home';
    }

    // ONBOARDING KONTROLU
    if (splashVM.shouldShowOnboarding) {
      if (path != '/onboarding') return '/onboarding';
      return null;
    }
    // Onboarding'i gormus ama hala o sayfadaysa
    if (path == '/onboarding') {
      return role == UserRole.driver ? '/driver' : '/home';
    }

    // LOGIN YOKSA — guest sign-in her zaman yapilir, bu durum nadir
    // Her durumda home'a yonlendir
    if (!loggedIn) {
      if (path == '/' || !authRoutes.contains(path)) {
        return '/home';
      }
      return null;
    }

    // GUEST KULLANICI — email dogrulamayi atla, direkt home'a git
    if (isGuestUser) {
      if (path == '/' || path == '/email-confirmed') {
        return '/home';
      }
      // Upgrade-account ve auth sayfalarına gidebilir
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

    // Auth/splash sayfalarindan cikis
    if (authRoutes.contains(path) || path == '/') {
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
      path: '/all-featured',
      name: 'allFeatured',
      builder: (context, state) => const AllFeaturedScreen(),
    ),
    GoRoute(
      path: '/search-results',
      name: 'searchResults',
      builder: (context, state) {
        final qp = state.uri.queryParameters;
        final type = int.tryParse(qp['type'] ?? '0') ?? 0;

        return TourSearchResultsScreen(
          type: type,
          regionId: qp['regionId'],
          cityId: qp['cityId'],
          districtId: qp['districtId'],
          regionName: qp['regionName'],
          cityName: qp['cityName'],
          districtName: qp['districtName'],
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
        String? heroTag;

        if (data is String) {
          // Eski kullanim: sadece ID
          tourPointId = data;
        } else if (data is Map<String, dynamic>) {
          tourPointId = data["id"] as String;
          initialImage = data["initialImage"] as String?;
          heroTag = data["heroTag"] as String?;
        } else {
          return MaterialPage(key: state.pageKey, child: const HomeScreen());
        }

        return MaterialPage(
          key: ValueKey('searchDetail_$tourPointId'),
          child: TourSearchDetailScreen(
            tourPointId: tourPointId,
            initialImage: initialImage,
            heroTag: heroTag,
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
        final String bookingType;
        TransportSummaryViewModel? transportVm;
        if (state.extra is Map<String, dynamic>) {
          final args = state.extra as Map<String, dynamic>;
          bookingType = args['bookingType'] as String? ?? 'tour';
          transportVm = args['transportVm'] as TransportSummaryViewModel?;
        } else {
          bookingType = state.extra is String ? state.extra as String : 'tour';
        }
        return ChangeNotifierProvider(
          create: (_) => ContactInfoViewModel(),
          child: ContactInfoScreen(
            onContinue: (firstName, lastName, email, phone) async {
              final nav = GoRouter.of(context);
              final ctx = context;
              if (bookingType == 'transport') {
                await transportVm!.createBooking(
                  buyerFirstName: firstName,
                  buyerLastName: lastName,
                  buyerEmail: email,
                  buyerPhone: phone,
                );
                if (transportVm.bookingId != null && transportVm.bookingId!.isNotEmpty) {
                  nav.push('/payment', extra: transportVm.bookingId);
                } else if (transportVm.errorMessage != null) {
                  UIHelper.showError(ctx, transportVm.errorMessage!);
                }
              } else {
                final detailVm = context.read<TourDetailViewModel>();
                final selectionVm = context.read<TourBookingSelectionViewModel>();
                final vehicleGuideVm = context.read<TourVehicleGuideViewModel>();
                await vehicleGuideVm.controlBooking(
                  buyerFirstName: firstName,
                  buyerLastName: lastName,
                  buyerEmail: email,
                  buyerPhone: phone,
                  cityId: detailVm.selectedCityId!,
                  districtId: detailVm.selectedDistrictId!,
                  tourPointId: detailVm.selectedTourPointId!,
                  date: selectionVm.selectedDate!,
                  departureTime: selectionVm.selectedTime!,
                  locationDescription: selectionVm.selectedPlaceDesc,
                  latitude: selectionVm.selectedPlaceLat,
                  longitude: selectionVm.selectedPlaceLng,
                );
                if (vehicleGuideVm.isValid && vehicleGuideVm.bookingId != null) {
                  nav.push('/payment', extra: vehicleGuideVm.bookingId);
                } else if (vehicleGuideVm.errorMessage != null) {
                  UIHelper.showError(ctx, vehicleGuideVm.errorMessage!);
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
      path: '/search',
      builder: (context, state) => const TourSearchScreen(),
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
        final qp = state.uri.queryParameters;
        return TourSearchResultsByTourTypeScreen(
          tourTypeId: qp['tourTypeId'],
          tourTypeName: qp['tourTypeName'],
        );
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
      path: '/personal-info',
      builder: (context, state) => const PersonalInfoScreen(),
    ),
    GoRoute(
      path: '/settings/permissions',
      name: 'permissionsSettings',
      builder: (context, state) => const PermissionsScreen(),
    ),
    GoRoute(
      path: '/legal/:type',
      name: 'legalDetail',
      builder: (context, state) {
        final type = state.pathParameters['type'] ?? '';
        late final String title;
        late final String content;
        switch (type) {
          case 'privacy-policy':
            title = 'Gizlilik Politikası';
            content = LegalTexts.privacyPolicy;
            break;
          case 'kvkk':
            title = 'KVKK Aydınlatma Metni';
            content = LegalTexts.kvkk;
            break;
          case 'sales-agreement':
            title = 'Mesafeli Satış Sözleşmesi';
            content = LegalTexts.salesAgreement;
            break;
          default:
            title = '';
            content = '';
        }
        return LegalDetailScreen(title: title, content: content);
      },
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
          builder: (context, state) =>
              const ProfileScreen(), //GoogleMapTestPage
        ),
      ],
    ),
  ],
);
