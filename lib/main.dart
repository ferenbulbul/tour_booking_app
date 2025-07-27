// Gerekli import'ları ekliyoruz
import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:tour_booking/navigation/app_navigator.dart';

// Mevcut import'larınız
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart'; // go() metodu için
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/localization/localization_setup.dart';
import 'package:tour_booking/core/theme/app_theme.dart';
import 'package:tour_booking/features/email_verification/widget/email_verification_view_model.dart';
import 'package:tour_booking/features/login/widgets/google_view_model.dart';
import 'package:tour_booking/features/login/widgets/login_view_model.dart';
import 'package:tour_booking/features/register/widgets/register_view_model.dart';
import 'package:tour_booking/features/reset_password/widget/reset_password_view_model.dart';
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
          ChangeNotifierProvider(create: (_) => ResetPasswordViewModel()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

// MyApp'i StatelessWidget yerine StatefulWidget'a çeviriyoruz
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initURIListener();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  /// SADECE UYGULAMA AÇIKKEN GELEN LİNKLERİ DİNLER
  void _initURIListener() {
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      print("✅ MyApp: Uygulama açıkken link geldi: $uri");
      _handleUri(uri);
    });
  }

  void _handleUri(Uri uri) {
    if (uri.scheme == 'tourbookingapp' && uri.host == 'reset-password') {
      final segments = uri.pathSegments;
      if (segments.length >= 2) {
        final email = Uri.decodeComponent(segments[0]);
        final token = segments[1];

        print("✅ MyApp: Yönlendiriliyor...");
        appNavigatorKey.currentContext?.go(
          '/reset-password?email=$email&token=$token',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // build metodu aynı kalıyor, sadece _MyAppState içine taşınıyor.
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
