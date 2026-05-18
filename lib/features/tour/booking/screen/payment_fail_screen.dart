import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class PaymentFailPage extends StatelessWidget {
  const PaymentFailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.l,
            40,
            AppSpacing.l,
            bottomPad > 0 ? bottomPad : 16,
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
                  color: AppColors.error.withValues(alpha: 0.08),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.15),
                  ),
                ),
                child: const Icon(
                  SolarIconsOutline.closeCircle,
                  size: 40,
                  color: AppColors.error,
                ),
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                tr("payment_failed_title"),
                style: AppTextStyles.titleLarge,
              ),

              const SizedBox(height: 8),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  tr("payment_failed_description"),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Help card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr("payment_failed_help_title"),
                      style: AppTextStyles.labelLarge.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    _hint(SolarIconsOutline.card, tr("payment_failed_hint_card")),
                    const SizedBox(height: 6),
                    _hint(SolarIconsOutline.wifiRouter, tr("payment_failed_hint_connection")),
                    const SizedBox(height: 6),
                    _hint(SolarIconsOutline.refresh, tr("payment_failed_hint_retry")),
                  ],
                ),
              ),

              const Spacer(),

              // Home button
              GestureDetector(
                onTap: () => context.go('/home'),
                child: Container(
                  width: double.infinity,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tr("back_to_home"),
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                      fontSize: 14,
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

  Widget _hint(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textLight),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
