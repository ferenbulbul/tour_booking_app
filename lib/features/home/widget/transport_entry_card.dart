import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class TransportEntryCard extends StatelessWidget {
  const TransportEntryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'transport_title'.tr(),
      child: GestureDetector(
      onTap: () => context.push('/transport'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.colors.primary,
              context.colors.primaryContainer,
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Row(
          children: [
            Container(
              width: AppSpacing.xxxxxl,
              height: AppSpacing.xxxxxl,
              decoration: BoxDecoration(
                color: context.colors.onPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.ml),
              ),
              child: Icon(
                SolarIconsOutline.routing,
                color: context.colors.onPrimary,
                size: AppIconSize.xxl,
              ),
            ),
            const SizedBox(width: AppSpacing.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'transport_title'.tr(),
                    style: AppTextStyles.bodyLargeEmphasis.copyWith(
                      color: context.colors.onPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxs),
                  Text(
                    'transport_entry_subtitle'.tr(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.colors.onPrimary.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              SolarIconsOutline.arrowRight,
              color: context.colors.onPrimary.withValues(alpha: 0.6),
              size: AppIconSize.m,
            ),
          ],
        ),
      ),
    ),
    );
  }
}
