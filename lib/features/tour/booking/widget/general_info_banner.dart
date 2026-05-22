import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class GeneralInfoBanner extends StatelessWidget {
  final String cityDistrict;
  final String tourType;
  final int durationHours;
  final int durationMinutes;

  const GeneralInfoBanner({
    super.key,
    required this.cityDistrict,
    required this.tourType,
    required this.durationHours,
    required this.durationMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(
          icon: Icons.check,
          iconColor: context.ext.success,
          title: tr("easy_cancellation"),
          subtitle: tr("free_cancellation_24h"),
        ),
        _InfoRow(
          icon: Icons.schedule_outlined,
          iconColor: context.colors.onSurfaceVariant,
          title: "${tr("duration_label")}: ${tr("duration_format", namedArgs: {
                "hours": "$durationHours",
                "minutes": "$durationMinutes",
              })}",
          subtitle: tr("duration_note"),
        ),
        _InfoRow(
          icon: Icons.place_outlined,
          iconColor: context.colors.onSurfaceVariant,
          title: cityDistrict,
        ),
        _InfoRow(
          icon: Icons.style_outlined,
          iconColor: context.colors.onSurfaceVariant,
          title: tourType,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xxs),
            child: Icon(icon, size: AppIconSize.m, color: iconColor),
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.colors.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
