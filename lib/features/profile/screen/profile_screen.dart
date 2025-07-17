import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/profile/widget/language_select.dart';
import 'package:tour_booking/features/profile/widget/profile_header.dart';
import 'package:tour_booking/features/profile/widget/profile_actions_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'profile'.tr()),
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
