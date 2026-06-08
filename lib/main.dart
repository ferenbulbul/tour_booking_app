import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/deeplink/app_root.dart';
import 'package:tour_booking/core/localization/localization_setup.dart';
import 'package:tour_booking/features/bookings/bookings_viewmodel.dart';
import 'package:tour_booking/features/bookings/rating_viewmodel.dart';
import 'package:tour_booking/features/favorite/favorite_viewmodel.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/auth/login/google_viewmodel.dart';
import 'package:tour_booking/features/tour/search/search_viewmodel.dart';
import 'package:tour_booking/features/tour/search_result/search_result_viewmodel.dart';
import 'package:tour_booking/features/profile/permission_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/features/tour/booking/tour_detail_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_booking_selection_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_vehicle_guide_viewmodel.dart';
import 'package:tour_booking/firebase_options.dart';
import 'package:tour_booking/navigation/app_router.dart';
import 'package:tour_booking/services/driver/driver_service.dart';
import 'package:tour_booking/features/location/location_viewmodel.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/features/profile/theme_viewmodel.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  String envFile = '.env';
  if (Platform.isAndroid) {
    envFile = '.env.android';
  } else if (Platform.isIOS) {
    envFile = '.env.ios';
  }
  await dotenv.load(fileName: envFile);
  await LocalizationSetup.init();

  // Initialize Firebase here to ensure it is ready before Providers are created.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPaintBaselinesEnabled = false;
  debugPaintSizeEnabled = false;
  debugPaintPointersEnabled = false;
  debugPaintLayerBordersEnabled = false;

  ServiceLocator.instance.init();

  // Global error handlers for uncaught exceptions
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    return true;
  };

  runApp(const AppProviders());
}

// AppProviders and MyApp classes can remain as-is.
class AppProviders extends StatefulWidget {
  const AppProviders({super.key});

  @override
  State<AppProviders> createState() => _AppProvidersState();
}

final appId = "f8fa783c-24c8-4655-b17d-2ecbc6a8ab22";

class _AppProvidersState extends State<AppProviders> {
  @override
  void initState() {
    super.initState();
    splashViewModel.initializeApp(); // Critical initialization line
    _initOneSignal();
  }

  Future<void> _initOneSignal() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(appId);
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.preventDefault();
      event.notification.display();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LocalizationSetup.wrapWithLocalization(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SplashViewModel>.value(value: splashViewModel),
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => LocationViewModel()),
          ChangeNotifierProvider(create: (_) => HomeViewModel()..init()),
          ChangeNotifierProvider(create: (_) => SearchViewModel()),
          ChangeNotifierProvider(create: (_) => TourSearchResultsViewModel()),
          ChangeNotifierProvider(create: (_) => TourDetailViewModel()),
          ChangeNotifierProvider(create: (_) => TourBookingSelectionViewModel()),
          ChangeNotifierProvider(create: (_) => TourVehicleGuideViewModel()),
          Provider<DriverService>(create: (_) => ServiceLocator.instance.driverService),
          ChangeNotifierProvider(create: (_) => ProfileViewModel()),
          ChangeNotifierProvider(create: (_) => FavoriteViewModel()),
          ChangeNotifierProvider(create: (_) => BookingsViewModel()),
          ChangeNotifierProvider(create: (_) => PermissionsViewModel()),
          ChangeNotifierProvider(create: (_) => RatingsViewModel()),
          ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ],
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppRoot(router: router);
  }
}
