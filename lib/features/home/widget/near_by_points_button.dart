import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';

class NearbyPointsButton extends StatelessWidget {
  const NearbyPointsButton({super.key});

  Future<bool> _hasPermission() async {
    return (await Permission.locationWhenInUse.status).isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasPermission(),
      builder: (context, snapshot) {
        return _MinimalNearbyCard(
          onTap: () async {
            var status = await Permission.locationWhenInUse.status;

            if (!status.isGranted) {
              status = await Permission.locationWhenInUse.request();
            }

            if (!context.mounted) return;

            if (status.isGranted) {
              context.pushNamed("nearbyPoints");
            } else {
              UIHelper.showWarning(context, tr("enable_location_permission_from_settings"));
            }
          },
        );
      },
    );
  }
}

class _MinimalNearbyCard extends StatelessWidget {
  final VoidCallback onTap;
  const _MinimalNearbyCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tr("nearby_tours"),
      child: InkWell(
      borderRadius: BorderRadius.circular(AppRadius.large),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lm, vertical: AppSpacing.xl),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.m),
              decoration: BoxDecoration(
                color: context.colors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.ml),
              ),
              child: Icon(SolarIconsOutline.gps, color: context.colors.secondary, size: AppIconSize.xl, semanticLabel: 'GPS'),
            ),

            const SizedBox(width: AppSpacing.ml),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr("nearby_tours"),
                    style: AppTextStyles.titleMedium.copyWith(
                      color: context.colors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    tr("find_tours_nearby"),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              SolarIconsOutline.arrowRight,
              size: AppIconSize.xl,
              color: context.ext.textLight,
            ),
          ],
        ),
      ),
    ),
    );
  }
}
