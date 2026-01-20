import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tour_booking/core/deeplink/deeplink_service.dart';
import 'package:tour_booking/core/theme/app_theme.dart';

class AppRoot extends StatefulWidget {
  final GoRouter router;
  const AppRoot({super.key, required this.router});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  // Manuel init yerine GoRouter'a güveniyoruz.
  // Sadece çok özel bir stream yapın varsa burada tutmalısın.

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // GoRouter tüm deep link yönetimini burada devralır.
      routerConfig: widget.router,
    );
  }
}
