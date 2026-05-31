import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_elevation.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/features/location/location_viewmodel.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

/// Location permission/tracking control card for Driver.
class LocationControlCard extends StatelessWidget {
  const LocationControlCard({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final locationVm = context.watch<LocationViewModel>();
    final tracking = locationVm.isTracking;
    final scheme = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: AppElevation.shadowSm,
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('driver_location_sharing_title'),
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              tracking
                  ? tr('driver_location_active')
                  : tr('driver_location_inactive'),
              style: AppTextStyles.bodySmall.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              children: [
                OutlinedButton.icon(
                  icon: Icon(
                    tracking ? SolarIconsOutline.stop : SolarIconsOutline.play,
                    semanticLabel: tracking ? 'Stop tracking' : 'Start tracking',
                  ),
                  label: Text(
                    tracking
                        ? tr('driver_stop_location')
                        : tr('driver_start_location'),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  onPressed: () async {
                    if (tracking) {
                      locationVm.stopTracking();
                    } else {
                      await locationVm.checkAndHandleLocation(role);
                    }
                  },
                ),
                const SizedBox(width: AppSpacing.m),
                OutlinedButton.icon(
                  icon: const Icon(
                    SolarIconsOutline.settings,
                    semanticLabel: 'Settings',
                  ),
                  label: Text(tr('settings')),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  onPressed: () {
                    openAppSettings();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
