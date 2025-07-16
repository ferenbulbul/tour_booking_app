import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/features/login/widgets/login_form.dart';
import 'package:tour_booking/features/login/widgets/login_header.dart';
import 'package:tour_booking/features/login/widgets/social_login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.sectionSpacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                SizedBox(height: 80), // 💡 sayfayı aşağı kaydırır
                LoginHeader(),
                SizedBox(height: AppSpacing.sectionSpacing),
                LoginForm(),
                SizedBox(height: 10),
                _RegisterPrompt(),
                SizedBox(height: 40),
                SocialLoginButtons(),
                SizedBox(height: AppSpacing.elementSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterPrompt extends StatelessWidget {
  const _RegisterPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Hesabın yok mu? ", style: TextStyle(fontSize: 14)),
          TextButton(
            onPressed: () {
              context.push('/register');
            },
            child: const Text(
              "Hesap oluştur",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
