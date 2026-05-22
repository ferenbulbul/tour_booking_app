import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/navigation/app_router.dart';

/// Shows "Create Account" bottom sheet for guest users.
/// Returns `true` if not a guest (continue flow).
/// Shows bottom sheet and returns `false` for guests (stop flow).
Future<bool> guestGate(BuildContext context) async {
  if (!splashViewModel.isGuest) return true;

  await showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.l, AppSpacing.xxl, AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: AppSpacing.xxxxl,
                height: AppSpacing.xs,
                decoration: BoxDecoration(
                  color: ctx.ext.shimmerBase,
                  borderRadius: BorderRadius.circular(AppSpacing.xxs),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: ctx.colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: Icon(
                  SolarIconsOutline.userPlus,
                  size: AppIconSize.xxl,
                  color: ctx.colors.primary,
                  semanticLabel: 'Create account',
                ),
              ),
              const SizedBox(height: AppSpacing.l),

              // Title
              Text(
                tr("guest_gate_title"),
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s),

              // Subtitle
              Text(
                tr("guest_gate_subtitle"),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: ctx.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // CTA: Sign Up
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.ml),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.ml),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    context.push('/upgrade-account');
                  },
                  child: Text(tr("upgrade_account_button")),
                ),
              ),
              const SizedBox(height: AppSpacing.ms),

              // Cancel
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.ml),
                    side: BorderSide(color: ctx.ext.shimmerBase),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.ml),
                    ),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(tr("common_cancel")),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  return false;
}
