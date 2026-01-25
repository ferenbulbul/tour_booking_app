import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/deeplink/app_router.dart';
import 'package:tour_booking/core/localization/localization_setup.dart';
import 'package:tour_booking/features/bookings/bookings_viewmodel.dart';
import 'package:tour_booking/features/auth/change_password/change_password_viewmodel.dart';
import 'package:tour_booking/features/driver_home_page/driver_viewmodel.dart';
import 'package:tour_booking/features/auth/email_verification/widget/email_verification_view_model.dart';
import 'package:tour_booking/features/favorite/favorite_viewmodel.dart';
import 'package:tour_booking/features/auth/forgot_passwords/forgot_password/widget/forgot_password_view_model.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/auth/login/widgets/google_view_model.dart';
import 'package:tour_booking/features/auth/login/widgets/login_view_model.dart';
import 'package:tour_booking/features/auth/phone_verification/verify_phone_viewmodel.dart';
import 'package:tour_booking/features/auth/register/widgets/register_view_model.dart';
import 'package:tour_booking/features/detailed_search/search/search_viewmodel.dart';
import 'package:tour_booking/features/detailed_search/search_result/search_result_viewmodel.dart';
import 'package:tour_booking/features/profile/permission_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_status_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/features/detailed_search/flow/payment_viewmodel.dart';
import 'package:tour_booking/features/detailed_search/flow/tour_search_detail_viewmodel.dart';
import 'package:tour_booking/firebase_options.dart';
import 'package:tour_booking/navigation/app_router.dart';
import 'package:tour_booking/services/driver/driver_service.dart';
import 'package:tour_booking/services/location/location_viewmodel.dart';

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

  // Firebase'i burada başlatarak, Provider'lar oluşturulmadan önce hazır olmasını garantiliyoruz.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPaintBaselinesEnabled = false;
  debugPaintSizeEnabled = false;
  debugPaintPointersEnabled = false;
  debugPaintLayerBordersEnabled = false;

  runApp(const AppProviders());
}

// AppProviders ve MyApp sınıfları aynı kalabilir.
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
    splashViewModel.initializeApp(); // 🔥 KRİTİK SATIR
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
          ChangeNotifierProvider(create: (_) => LoginViewModel()),
          ChangeNotifierProvider(create: (_) => EmailVerificationViewModel()),
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => RegisterViewModel()),
          ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
          ChangeNotifierProvider(create: (_) => LocationViewModel()),
          ChangeNotifierProvider(create: (_) => HomeViewModel()..init()),
          ChangeNotifierProvider(create: (_) => SearchViewmodel()),
          ChangeNotifierProvider(create: (_) => TourSearchResultsViewModel()),
          ChangeNotifierProvider(create: (_) => TourSearchDetailViewModel()),
          ChangeNotifierProvider(create: (_) => ChangePasswordViewModel()),
          Provider<DriverService>(create: (_) => DriverService()),
          ChangeNotifierProvider(
            create: (context) =>
                DriverHomeViewModel(context.read<DriverService>()),
          ),
          ChangeNotifierProvider(
            create: (_) => ProfileStatusViewModel()..init(),
          ),
          ChangeNotifierProvider(create: (_) => ProfileViewModel()),
          ChangeNotifierProvider(create: (_) => VerifyPhoneViewModel()),
          ChangeNotifierProvider(create: (_) => FavoriteViewModel()),
          ChangeNotifierProvider(create: (_) => PaymentViewModel()),
          ChangeNotifierProvider(create: (_) => BookingsViewModel()),
          ChangeNotifierProvider(create: (_) => PermissionsViewModel()),
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
