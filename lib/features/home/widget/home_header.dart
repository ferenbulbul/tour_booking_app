import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final logoHeight = width < 360 ? 30.0 : 36.0;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.l,
        AppSpacing.m,
        AppSpacing.l,
        AppSpacing.s,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart, // RTL: right, LTR: left
        child: Image.asset(
          'assets/images/header.png',
          height: logoHeight,
          fit: BoxFit.contain,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
