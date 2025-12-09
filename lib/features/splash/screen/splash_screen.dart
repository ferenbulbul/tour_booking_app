import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';

final appId = "f8fa783c-24c8-4655-b17d-2ecbc6a8ab22";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAppAndNavigate();
    });
  }

  Future<void> _initializeAppAndNavigate() async {
    try {
      await _initializeOneSignal();

      if (!mounted) return;
      final splashVM = Provider.of<SplashViewModel>(context, listen: false);
      final isLoggedIn = await splashVM.isLoggedIn();

      String targetRoute;
      if (isLoggedIn) {
        final user = await splashVM.getUserMeSafe();
        final prefs = await SharedPreferences.getInstance();
        final roleStr = prefs.getString('user_role');
        final role = roleStr != null
            ? UserRoleExtension.fromString(roleStr)
            : null;

        if (user != null && !user.emailConfirmed) {
          FlutterNativeSplash.remove();
          context.go('/email-confirmed');
          return;
        }

        if (role == UserRole.driver) {
          targetRoute = '/driver';
        } else {
          targetRoute = '/home';
        }
      } else {
        targetRoute = '/login';
      }

      if (!mounted) return;

      FlutterNativeSplash.remove(); // ✔ sadece burada

      context.go(targetRoute);
    } catch (e, s) {
      print("Splash Screen başlatma hatası: $e");
      print(s);

      FlutterNativeSplash.remove();
      if (mounted) context.go('/login');
    }
  }

  Future<void> _initializeOneSignal() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(appId);
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.preventDefault();
      event.notification.display();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
