import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final VoidCallback onTap;

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
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.m,
          horizontal: AppSpacing.xs,
        ),
        decoration: const BoxDecoration(
          // Arkaplan yok → Home settings sheet tarzı
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ---------------------------------
            // ICON
            // ---------------------------------
            Icon(icon, size: 22, color: iconColor ?? scheme.primary),

            const SizedBox(width: AppSpacing.l),

            // ---------------------------------
            // TITLE + SUBTITLE
            // ---------------------------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 15,
                      color: titleColor ?? scheme.onSurface,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 13,
                          color:
                              subtitleColor ??
                              scheme.onSurfaceVariant.withOpacity(.8),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ---------------------------------
            // OPTIONAL TRAILING TEXT
            // ---------------------------------
            if (trailingText != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  trailingText!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 13,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),

            // ---------------------------------
            // ARROW ICON
            // ---------------------------------
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: scheme.onSurfaceVariant.withOpacity(.7),
            ),
          ],
        ),
      ),
    );
  }
}
