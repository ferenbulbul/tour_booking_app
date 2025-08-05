import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/localization/localization_setup.dart';
import 'package:tour_booking/core/theme/app_theme.dart';
import 'package:tour_booking/features/email_verification/widget/email_verification_view_model.dart';
import 'package:tour_booking/features/forgot_passwords/forgot_password/widget/forgot_password_view_model.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/login/widgets/google_view_model.dart';
import 'package:tour_booking/features/login/widgets/login_view_model.dart';
import 'package:tour_booking/features/register/widgets/register_view_model.dart';
import 'package:tour_booking/features/splash/widget/splash_view_model.dart';
import 'package:tour_booking/firebase_options.dart';
import 'package:tour_booking/navigation/app_router.dart';
import 'package:tour_booking/services/location/location_viewmodel.dart.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
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
          ChangeNotifierProvider(create: (_) => GoogleViewModel()),
          ChangeNotifierProvider(create: (_) => RegisterViewModel()),
          ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
          ChangeNotifierProvider(create: (_) => LocationViewModel()),
          ChangeNotifierProvider(create: (_) => HomeViewModel()..init()),
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
