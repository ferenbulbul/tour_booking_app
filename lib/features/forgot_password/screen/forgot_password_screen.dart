import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/features/forgot_password/widget/forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifremi Unuttum'),
        titleTextStyle: const TextStyle(fontSize: 20),
        centerTitle: true,
      ),
      body: ForgotPasswordForm(),
    );
  }
}
