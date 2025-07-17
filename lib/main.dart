import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/localization/localization_setup.dart';
import 'package:tour_booking/core/theme/app_theme.dart';
import 'package:tour_booking/features/email_verification/widget/email_verification_view_model.dart';
import 'package:tour_booking/features/login/widgets/login_view_model.dart';
import 'package:tour_booking/features/splash/widget/splash_view_model.dart';
import 'package:tour_booking/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await LocalizationSetup.init();
  runApp(
    LocalizationSetup.wrapWithLocalization(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginViewModel()),
          ChangeNotifierProvider(create: (_) => SplashViewModel()),
          ChangeNotifierProvider(create: (_) => EmailVerificationViewModel()),
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
