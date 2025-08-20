import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/login/widgets/google_view_model.dart';
import 'package:tour_booking/services/core/secure_token_storage.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const ProfileHeader({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/images/logo.png'),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(email),
        ElevatedButton(
          onPressed: () {
            final viewModel = Provider.of<GoogleViewModel>(
              context,
              listen: false,
            );
            context.go('/login');
            viewModel.signOut();
          },
          child: Text('____'),
        ),
      ],
    );
  }
}
