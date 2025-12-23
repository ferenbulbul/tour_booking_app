import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/auth/forgot_passwords/reset_password/widget/reset_password_form.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,

      appBar: CommonAppBar(title: 'new_password'.tr(), showBack: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: scheme.shadow.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ResetPasswordForm(email: email),
          ),
        ),
      ),
    );
  }
}
