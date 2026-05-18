import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

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
    final isDestructive = titleColor == AppColors.error;
    final effectiveIconColor = iconColor ?? AppColors.textSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: (isDestructive
                            ? AppColors.error
                            : effectiveIconColor)
                        .withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isDestructive ? AppColors.error : effectiveIconColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: titleColor ?? AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            subtitle!,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 12,
                              color: subtitleColor ?? AppColors.textLight,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                if (trailingText != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      trailingText!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textLight,
                        fontSize: 13,
                      ),
                    ),
                  ),

                if (!isDestructive)
                  Icon(
                    SolarIconsOutline.arrowRight,
                    size: 18,
                    color: AppColors.textLight.withValues(alpha: 0.6),
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 62),
            child: Divider(
              height: 0.5,
              thickness: 0.5,
              color: AppColors.border.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }
}
