// import 'package:flutter/material.dart';

// class HomeHeader extends StatelessWidget {
//   const HomeHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final logoHeight = width < 360 ? 30.0 : 36.0;

//     return Padding(
//       padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
//       child: Center(
//         child: Image.asset(
//           'assets/images/header.png',
//           height: logoHeight,
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final logoHeight = width < 360 ? 30.0 : 36.0;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/images/header.png',
          height: logoHeight,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
