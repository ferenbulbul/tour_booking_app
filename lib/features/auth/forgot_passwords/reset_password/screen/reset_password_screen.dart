import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_elevation.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/auth/forgot_passwords/reset_password/widget/reset_password_form.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    return Scaffold(
      backgroundColor: scheme.surface,

      appBar: CommonAppBar(title: 'new_password'.tr(), showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.xxl),
              boxShadow: AppElevation.shadowMd,
            ),
            child: ResetPasswordForm(email: email),
          ),
        ),
      ),
    );
  }
}
