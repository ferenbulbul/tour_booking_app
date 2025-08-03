// splash_screen.dart - YENİDEN BASİTLEŞTİRİLMİŞ KOD

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/splash/widget/splash_view_model.dart';

class PushConfig {
  static const iosAppId = '5f3bbef4-7907-4207-9d1d-eaf43763d91c';
  static const androidAppId = 'f8fa783c-24c8-4655-b17d-2ecbc6a8ab22';
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // UI çizildikten sonra işlemleri başlatıyoruz ki donma hissi azalsın.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAppAndNavigate();
    });
  }

  Future<void> _initializeAppAndNavigate() async {
    try {
      // Artık sadece OneSignal ve giriş kontrolü kaldı. Bu çok daha hızlı olacaktır.
      await _initializeOneSignal();

      if (!mounted) return;
      final splashVM = Provider.of<SplashViewModel>(context, listen: false);
      final isLoggedIn = await splashVM.isLoggedIn();

      FlutterNativeSplash.remove();

      if (!mounted) return;
      final targetRoute = isLoggedIn ? '/home' : '/login';
      context.go(targetRoute);
    } catch (e, s) {
      print("Splash Screen başlatma hatası: $e");
      print(s);
      FlutterNativeSplash.remove();
      if (mounted) {
        context.go('/login');
      }
    }
  }

  Future<void> _initializeOneSignal() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    String? appId;
    if (Platform.isIOS) {
      appId = PushConfig.iosAppId;
    } else if (Platform.isAndroid) {
      appId = PushConfig.androidAppId;
    } else {
      // Diğer platformlar (macOS, Windows, Linux) için kurulum yapmıyoruz
      return;
    }
    OneSignal.initialize(appId);
    await OneSignal.Notifications.requestPermission(true);

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
