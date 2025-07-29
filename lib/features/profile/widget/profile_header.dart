import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tour_booking/services/auth/secure_token_storage.dart';

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
          backgroundImage: AssetImage('assets/iamges/logo.png'),
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
            context.go('/login');
            final SecureTokenStorage _tokenStorage = SecureTokenStorage();
            _tokenStorage.clearTokens();
          },
          child: Text('____'),
        ),
      ],
    );
  }
}
