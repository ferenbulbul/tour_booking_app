import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/localization/localization_setup.dart';
import 'package:tour_booking/core/theme/app_theme.dart';
import 'package:tour_booking/features/email_verification/widget/email_verification_view_model.dart';
import 'package:tour_booking/features/forgot_passwords/forgot_password/widget/forgot_password_view_model.dart';
import 'package:tour_booking/features/login/widgets/google_view_model.dart';
import 'package:tour_booking/features/login/widgets/login_view_model.dart';
import 'package:tour_booking/features/register/widgets/register_view_model.dart';
import 'package:tour_booking/features/splash/widget/splash_view_model.dart';
import 'package:tour_booking/firebase_options.dart';
import 'package:tour_booking/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  await LocalizationSetup.init();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('f8fa783c-24c8-4655-b17d-2ecbc6a8ab22');
  await OneSignal.Notifications.requestPermission(true);

  // Foreground’da da sistem bildirimi olarak göster
  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    event.preventDefault();
    event.notification.display();
  });

  runApp(
    LocalizationSetup.wrapWithLocalization(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginViewModel()),
          ChangeNotifierProvider(create: (_) => SplashViewModel()),
          ChangeNotifierProvider(create: (_) => EmailVerificationViewModel()),
          ChangeNotifierProvider(create: (_) => GoogleViewModel()),
          ChangeNotifierProvider(create: (_) => RegisterViewModel()),
          ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ],
        child: const MyApp(),
      ),
    ),
  );
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
