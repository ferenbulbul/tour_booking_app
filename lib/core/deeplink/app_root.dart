import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_theme.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';

class AppRoot extends StatefulWidget {
  final GoRouter router;
  const AppRoot({super.key, required this.router});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: UIHelper.rootMessengerKey,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: widget.router,
      builder: (context, child) {
        return _AuthTransitionOverlay(child: child);
      },
    );
  }
}

class _AuthTransitionOverlay extends StatelessWidget {
  final Widget? child;
  const _AuthTransitionOverlay({required this.child});

  @override
  Widget build(BuildContext context) {
    final isTransitioning = context.watch<SplashViewModel>().isTransitioning;

    return Stack(
      children: [
        if (child != null) child!,
        IgnorePointer(
          ignoring: !isTransitioning,
          child: AnimatedOpacity(
            opacity: isTransitioning ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
