import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

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
      borderColor = context.colors.error.withValues(alpha: 0.5);
      iconColor = context.colors.error;
    } else if (hasValue) {
      borderColor = context.colors.secondary.withValues(alpha: 0.2);
      iconColor = context.colors.secondary;
    } else {
      borderColor = context.colors.outline;
      iconColor = context.ext.textLight;
    }

    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.m),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: AppIconSize.ml,
                color: iconColor,
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Text(
                  hasValue ? value! : label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: hasValue
                        ? context.colors.onSurface
                        : context.ext.textLight,
                    fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
              Icon(
                SolarIconsOutline.altArrowDown,
                size: AppIconSize.s,
                color: hasValue ? context.colors.onSurfaceVariant : context.ext.textLight,
                semanticLabel: 'Expand',
              ),
            ],
          ),
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

    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.ml),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.ml),
            border: Border.all(
              color: isEmpty ? context.colors.outline : context.colors.secondary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // ICON
              Container(
                width: AppIconSize.xxxl,
                height: AppIconSize.xxxl,
                decoration: BoxDecoration(
                  color: isEmpty
                      ? context.colors.surfaceContainerHighest
                      : context.colors.secondary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppSpacing.ms),
                ),
                child: Icon(
                  icon,
                  size: AppIconSize.ml,
                  color: isEmpty ? context.ext.textLight : context.colors.secondary,
                ),
              ),

              const SizedBox(width: AppSpacing.m),

              // LABEL + VALUE/HINT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        color: context.ext.textLight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      isEmpty ? (hint ?? label) : value!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isEmpty ? context.ext.textLight : context.colors.onSurface,
                        fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // CHEVRON
              Icon(
                SolarIconsOutline.altArrowDown,
                size: 18,
                color: isEmpty ? context.ext.textLight : context.colors.onSurfaceVariant,
                semanticLabel: 'Expand',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
