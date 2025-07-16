import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/splash/widget/splash_logo.dart';
import 'package:tour_booking/features/splash/widget/splash_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // animasyon için gecikme

    final splashVM = Provider.of<SplashViewModel>(context, listen: false);
    var isLoggedIn = await splashVM.isLoggedIn();
    isLoggedIn = false;
    if (isLoggedIn) {
      context.go('/home'); // Giriş yapmışsa ana sayfaya
    } else {
      context.go('/login'); // Giriş yapmamışsa login'e
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: SplashLogo()));
  }
}
