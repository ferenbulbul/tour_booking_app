import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

/// Shows a confirmation dialog for cancelling a booking.
/// Returns `true` if user confirmed, `false` or `null` otherwise.
Future<bool?> showCancelBookingDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: context.colors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: Icon(
                SolarIconsOutline.infoCircle,
                size: AppIconSize.xxl,
                color: context.colors.error,
                semanticLabel: 'Cancel booking warning',
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              "Rezervasyonu İptal Et",
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ).tr(),
            const SizedBox(height: AppSpacing.s),
            Text(
              "Bu rezervasyonu iptal etmek istediğine emin misin?",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ).tr(),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colors.onSurfaceVariant,
                        side: BorderSide(color: context.colors.outline),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true)
                              .pop(false),
                      child: Text("common_cancel".tr()),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: context.colors.error,
                        foregroundColor: context.colors.onError,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(true),
                      child: Text(
                        "common_yes".tr(),
                        style: TextStyle(color: context.colors.onError),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
