import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_elevation.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/auth/forgot_passwords/forgot_password/widget/forgot_password_form.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: CommonAppBar(title: 'reset_password'.tr()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.l),
          child: Column(
            children: [
              // FORM CARD
              Container(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.xxl),
                  boxShadow: AppElevation.shadowLg,
                ),
                child: const ForgotPasswordForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
