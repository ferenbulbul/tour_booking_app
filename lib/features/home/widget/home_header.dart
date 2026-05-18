import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final logoHeight = width < 360 ? 30.0 : 36.0;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        16,
        12,
        16, // 🔥 artık sağ da padding alıyor
        8,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart, // 🔥 RTL → sağ, LTR → sol
        child: Image.asset(
          'assets/images/header.png',
          height: logoHeight,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
