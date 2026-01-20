import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
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
    _startInitialization();
  }

  Future<void> _startInitialization() async {
    // 1. OneSignal başlat
    await _initializeOneSignal();

    if (!mounted) return;

    // 2. Token ve User verilerini yükle (ViewModel üzerinden)
    // Bu bittiğinde ViewModel notifyListeners() yapacak ve GoRouter uyanacak
    await context.read<SplashViewModel>().initializeApp();

    // 3. Splash resmini kaldır
    FlutterNativeSplash.remove();
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
