// lib/features/splash/screen/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/splash/widget/splash_view_model.dart';
import 'package:tour_booking/navigation/app_navigator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideInitialNavigation();
  }

  Future<void> _decideInitialNavigation() async {
    // SADECE BAŞLANGIÇ LİNKİNİ KONTROL ET
    final initialLink = await AppLinks().getInitialLink();

    if (initialLink != null && _isResetLink(initialLink)) {
      _navigateToResetScreen(initialLink);
      return;
    }

    // LİNK YOKSA NORMAL AKIŞ
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    final splashVM = Provider.of<SplashViewModel>(context, listen: false);
    final isLoggedIn = await splashVM.isLoggedIn();

    if (!mounted) return;
    if (isLoggedIn) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  bool _isResetLink(Uri uri) {
    return uri.scheme == 'tourbookingapp' &&
        uri.host == 'reset-password' &&
        uri.pathSegments.length >= 2;
  }

  void _navigateToResetScreen(Uri uri) {
    final segments = uri.pathSegments;
    final email = Uri.decodeComponent(segments[0]);
    final token = segments[1];

    Future.delayed(Duration.zero, () {
      if (mounted) {
        appNavigatorKey.currentContext?.go(
          '/reset-password?email=$email&token=$token',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
