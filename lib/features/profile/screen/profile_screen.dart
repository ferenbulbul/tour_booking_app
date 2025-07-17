import 'package:flutter/material.dart';
import 'package:tour_booking/features/profile/widget/language_select.dart';
import 'package:tour_booking/features/profile/widget/profile_header.dart';
import 'package:tour_booking/features/profile/widget/profile_actions_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: const [
            ProfileHeader(name: 'Ege Çetin', email: 'ege@mail.com'),
            SizedBox(height: 32),
            ProfileActionsButton(),
            LanguageSelector(),
          ],
        ),
      ),
    );
  }
}
