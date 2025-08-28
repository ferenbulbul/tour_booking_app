import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/login/widgets/google_view_model.dart';
import 'package:tour_booking/services/core/secure_token_storage.dart';

class SignOut extends StatelessWidget {
  const SignOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            final viewModel = Provider.of<GoogleViewModel>(
              context,
              listen: false,
            );
            context.go('/login');
            viewModel.signOut();
          },
          child: Text('Çıkış Yap'),
        ),
      ],
    );
  }
}
