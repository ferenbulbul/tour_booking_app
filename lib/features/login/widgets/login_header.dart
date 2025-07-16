import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Ortala
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text('Hoş Geldin', style: AppTextStyles.heading),
        SizedBox(height: 8),
        Text('Hesabına giriş yap ve hemen devam et', style: AppTextStyles.body),
      ],
    );
  }
}
