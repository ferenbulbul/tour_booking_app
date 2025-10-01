import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/localization/localization_setup.dart';
import 'package:tour_booking/core/theme/app_theme.dart';
import 'package:tour_booking/features/change_password/change_password_viewmodel.dart';
import 'package:tour_booking/features/driver_home_page/driver_viewmodel.dart';
import 'package:tour_booking/features/email_verification/widget/email_verification_view_model.dart';
import 'package:tour_booking/features/favorite/favorite_viewmodel.dart';
import 'package:tour_booking/features/forgot_passwords/forgot_password/widget/forgot_password_view_model.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/login/widgets/google_view_model.dart';
import 'package:tour_booking/features/login/widgets/login_view_model.dart';
import 'package:tour_booking/features/phone_verification/verify_phone_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_status_viewmodel.dart';
import 'package:tour_booking/features/register/widgets/register_view_model.dart';
import 'package:tour_booking/features/search/search_viewmodel.dart';
import 'package:tour_booking/features/search_result/search_result_viewmodel.dart';
import 'package:tour_booking/features/splash/widget/splash_view_model.dart';
import 'package:tour_booking/features/tour_search_detail/payment_viewmodel.dart';
import 'package:tour_booking/features/tour_search_detail/tour_search_detail_viewmodel.dart';
import 'package:tour_booking/firebase_options.dart';
import 'package:tour_booking/navigation/app_router.dart';
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

  runApp(const AppProviders());
}

// AppProviders ve MyApp sınıfları aynı kalabilir.
class AppProviders extends StatelessWidget {
  const AppProviders({super.key});
  @override
  Widget build(BuildContext context) {
    return LocalizationSetup.wrapWithLocalization(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginViewModel()),
          ChangeNotifierProvider(create: (_) => SplashViewModel()),
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
          ChangeNotifierProvider(create: (_) => DriverHomeViewModel()),
          ChangeNotifierProvider(
            create: (_) => ProfileStatusViewModel()..init(),
          ),
          ChangeNotifierProvider(create: (_) => ProfileViewModel()),
          ChangeNotifierProvider(create: (_) => VerifyPhoneViewModel()),
          ChangeNotifierProvider(create: (_) => FavoriteViewModel()),
          ChangeNotifierProvider(create: (_) => PaymentViewModel()),
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
    return MaterialApp.router(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.lightTheme,
    );
  }
}
