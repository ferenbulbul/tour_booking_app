import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/features/location/location_viewmodel.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

/// Location permission/tracking control card for Driver.
/// Logic unchanged
class LocationControlCard extends StatelessWidget {
  const LocationControlCard({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final locationVm = context.watch<LocationViewModel>();
    final tracking = locationVm.isTracking;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('driver_location_sharing_title'),
              style: context.textStyles.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              tracking
                  ? tr('driver_location_active')
                  : tr('driver_location_inactive'),
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              children: [
                OutlinedButton.icon(
                  icon: Icon(tracking ? SolarIconsOutline.stop : SolarIconsOutline.play, semanticLabel: tracking ? 'Stop tracking' : 'Start tracking'),
                  label: Text(tracking ? tr('driver_stop_location') : tr('driver_start_location')),
                  onPressed: () async {
                    if (tracking) {
                      // Stop tracking
                      locationVm.stopTracking();
                    } else {
                      // Start tracking
                      await locationVm.checkAndHandleLocation(role);
                    }
                  },
                ),
                const SizedBox(width: AppSpacing.m),
                OutlinedButton.icon(
                  icon: const Icon(SolarIconsOutline.settings, semanticLabel: 'Settings'),
                  label: Text(tr('settings')),
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
