import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final VoidCallback onTap;
  final bool showDivider;

  final Color? titleColor;
  final Color? iconColor;
  final Color? subtitleColor;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailingText,
    this.titleColor,
    this.iconColor,
    this.subtitleColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDestructive = titleColor == context.colors.error;
    final effectiveIconColor = iconColor ?? context.colors.onSurfaceVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          label: title,
          child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.small),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.m + 1, horizontal: AppSpacing.ml),
            child: Row(
              children: [
                Container(
                  width: AppIconSize.xxxl,
                  height: AppIconSize.xxxl,
                  decoration: BoxDecoration(
                    color: (isDestructive
                            ? context.colors.error
                            : effectiveIconColor)
                        .withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.ms),
                  ),
                  child: Icon(
                    icon,
                    size: AppIconSize.l,
                    color: isDestructive ? context.colors.error : effectiveIconColor,
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: titleColor ?? context.colors.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xxs),
                          child: Text(
                            subtitle!,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: subtitleColor ?? context.ext.textLight,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                if (trailingText != null)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: Text(
                      trailingText!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: context.ext.textLight,
                      ),
                    ),
                  ),

                if (!isDestructive)
                  Icon(
                    SolarIconsOutline.arrowRight,
                    size: AppIconSize.ml,
                    color: context.ext.textLight.withValues(alpha: 0.6),
                  ),
              ],
            ),
          ),
        ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.only(left: AppIconSize.xxxl + AppSpacing.m + AppSpacing.ml),
            child: Divider(
              height: 0.5,
              thickness: 0.5,
              color: context.colors.outline.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }
}
