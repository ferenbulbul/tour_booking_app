import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class CompactPickerField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;
  final bool showError;

  const CompactPickerField({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    final Color borderColor;
    final Color iconColor;
    if (showError) {
      borderColor = AppColors.error.withValues(alpha: 0.5);
      iconColor = AppColors.error;
    } else if (hasValue) {
      borderColor = AppColors.accent.withValues(alpha: 0.2);
      iconColor = AppColors.accent;
    } else {
      borderColor = AppColors.border;
      iconColor = AppColors.textLight;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: iconColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                hasValue ? value! : label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: hasValue
                      ? AppColors.textPrimary
                      : AppColors.textLight,
                  fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              SolarIconsOutline.altArrowDown,
              size: 14,
              color: hasValue ? AppColors.textSecondary : AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}

class PickerField extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;
  final String? hint;

  const PickerField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = value == null || value!.isEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isEmpty ? AppColors.border : AppColors.accent.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // ICON
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isEmpty
                    ? AppColors.background
                    : AppColors.accent.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isEmpty ? AppColors.textLight : AppColors.accent,
              ),
            ),

            const SizedBox(width: 12),

            // LABEL + VALUE/HINT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isEmpty ? (hint ?? label) : value!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: isEmpty ? AppColors.textLight : AppColors.textPrimary,
                      fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            // CHEVRON
            Icon(
              SolarIconsOutline.altArrowDown,
              size: 18,
              color: isEmpty ? AppColors.textLight : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
