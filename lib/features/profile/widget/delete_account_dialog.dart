import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

/// Shows a confirmation dialog for deleting the user's account.
/// Returns `true` if user confirmed, `false` or `null` otherwise.
Future<bool?> showDeleteAccountDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSpacing.xxxxxl + AppSpacing.s,
              height: AppSpacing.xxxxxl + AppSpacing.s,
              decoration: BoxDecoration(
                color: context.colors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: Icon(
                SolarIconsOutline.trashBinTrash,
                size: AppIconSize.xxl,
                color: context.colors.error,
                semanticLabel: 'Delete account',
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              tr("delete_account"),
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              tr("delete_account_warning"),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: AppSpacing.xxxxxl - 2,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colors.onSurfaceVariant,
                        side: BorderSide(color: context.colors.outline),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(false),
                      child: Text(tr("common_cancel")),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: SizedBox(
                    height: AppSpacing.xxxxxl - 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: context.colors.error,
                        foregroundColor: context.colors.onError,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(true),
                      child: Text(tr("common_yes")),
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
