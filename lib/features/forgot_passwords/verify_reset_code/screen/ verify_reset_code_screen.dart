import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/features/forgot_passwords/verify_reset_code/widget/verify_reset_code_form.dart';

class VerifyResetCodeScreen extends StatelessWidget {
  final String email;
  const VerifyResetCodeScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("verify_code".tr())),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.sectionSpacing,
          ),
          child: VerifyResetCodeForm(email: email),
        ),
      ),
    );
  }
}
