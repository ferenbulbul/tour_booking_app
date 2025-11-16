import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Ortala
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('welcome_title'.tr(), style: AppTextStyles.headlineSmall),
        SizedBox(height: 8),
        Text('welcome_subtitle'.tr(), style: AppTextStyles.displaySmall),
      ],
    );
  }
}
