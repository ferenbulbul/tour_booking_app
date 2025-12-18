// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:tour_booking/features/auth/login/widgets/google_view_model.dart';

// class SignOut extends StatelessWidget {
//   const SignOut({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             final viewModel = Provider.of<AuthViewModel>(
//               context,
//               listen: false,
//             );
//             context.go('/login');
//             viewModel.signOut();
//           },
//           child: Text('Çıkış Yap'),
//         ),
//       ],
//     );
//   }
// }
