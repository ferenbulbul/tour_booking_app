import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tour_booking/core/theme/app_elevation.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/auth/register/widget/register_form.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final text = context.textStyles;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: CommonAppBar(title: tr("register")),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.s),
                Text(
                  tr("register_subtitle"),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // --- FORM CARD ---
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.xxl),
                    boxShadow: AppElevation.shadowLg,
                  ),
                  child: const RegisterForm(),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // --- FOOTER ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tr("already_have_account"),
                      style: text.bodyMedium?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Semantics(
                      button: true,
                      label: 'Navigate to login',
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: Text(
                          tr("login"),
                          style: text.labelLarge?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xxxl - 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
