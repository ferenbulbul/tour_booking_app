import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class PaymentFailScreen extends StatelessWidget {
  const PaymentFailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: context.colors.surfaceContainerHighest,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.xxxxl,
            AppSpacing.l,
            bottomPad > 0 ? bottomPad : AppSpacing.l,
          ),
          child: Column(
            children: [
              const Spacer(),

              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.error.withValues(alpha: 0.08),
                  border: Border.all(
                    color: context.colors.error.withValues(alpha: 0.15),
                  ),
                ),
                child: Icon(
                  SolarIconsOutline.closeCircle,
                  size: AppIconSize.xxxxl,
                  color: context.colors.error,
                  semanticLabel: 'Payment failed',
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Title
              Text(
                tr("payment_failed_title"),
                style: AppTextStyles.titleLarge,
              ),

              const SizedBox(height: AppSpacing.s),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Text(
                  tr("payment_failed_description"),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.colors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xxxl),

              // Help card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.ml),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.ml),
                  border: Border.all(color: context.colors.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr("payment_failed_help_title"),
                      style: AppTextStyles.labelMedium,
                    ),
                    const SizedBox(height: AppSpacing.ms),
                    _hint(context, SolarIconsOutline.card, tr("payment_failed_hint_card")),
                    const SizedBox(height: AppSpacing.sm),
                    _hint(context, SolarIconsOutline.wifiRouter, tr("payment_failed_hint_connection")),
                    const SizedBox(height: AppSpacing.sm),
                    _hint(context, SolarIconsOutline.refresh, tr("payment_failed_hint_retry")),
                  ],
                ),
              ),

              const Spacer(),

              // Home button
              Semantics(
                button: true,
                label: tr("back_to_home"),
                child: GestureDetector(
                  onTap: () => context.go('/home'),
                  child: Container(
                    width: double.infinity,
                    height: 46,
                    decoration: BoxDecoration(
                      color: context.colors.secondary,
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tr("back_to_home"),
                      style: AppTextStyles.labelLarge.copyWith(
                        color: context.colors.onSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hint(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: AppIconSize.s, color: context.ext.textLight),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
