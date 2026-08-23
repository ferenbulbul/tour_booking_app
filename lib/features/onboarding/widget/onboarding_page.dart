import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/features/onboarding/widget/onboarding_illustration.dart';

class OnboardingPage extends StatelessWidget {
  final int index;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.index,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        children: [
          const Spacer(flex: 1),

          // ── Image with decorative background ──
          SizedBox(
            height: size.height * 0.38,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Subtle background circle
                Positioned(
                  child: Container(
                    width: size.width * 0.7,
                    height: size.width * 0.7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          context.colors.secondary.withValues(alpha: 0.06),
                          context.colors.secondary.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                // Tema renkleriyle kod içinde çizilen görsel (asset gerekmez)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Semantics(
                    label: title,
                    child: OnboardingIllustration(index: index),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // ── Title ──
          Text(
            title,
            style: AppTextStyles.headlineMedium.copyWith(
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.m),

          // ── Description ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
            child: Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.onSurfaceVariant,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
