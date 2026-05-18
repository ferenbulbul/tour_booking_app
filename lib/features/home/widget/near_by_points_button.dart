import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
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
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(SolarIconsOutline.gps, color: AppColors.accent, size: 24),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr("nearby_tours"),
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tr("find_tours_nearby"),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              SolarIconsOutline.arrowRight,
              size: 24,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}
