import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/services/location/location_permission_service.dart';
import 'package:tour_booking/features/location/location_viewmodel.dart';

/// Status widget shown only for the Driver role.
class DriverLocationStatus extends StatelessWidget {
  const DriverLocationStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationViewModel>(
      builder: (context, viewModel, child) {
        String statusText;
        Color statusColor;
        IconData statusIcon;

        final status = viewModel.permissionStatus;

        if (viewModel.isTracking) {
          final pos = viewModel.currentPosition;
          final lat = pos?.latitude.toStringAsFixed(4) ?? '...';
          final lon = pos?.longitude.toStringAsFixed(4) ?? '...';
          statusText = tr('driver_location_sharing', namedArgs: {'lat': lat, 'lon': lon});
          statusColor = context.ext.success;
          statusIcon = SolarIconsOutline.mapPoint;
        } else {
          switch (status) {
            case LocationPermissionStatus.grantedWhenInUse:
              statusText = tr('driver_bg_permission_needed');
              statusColor = context.ext.info;
              statusIcon = SolarIconsOutline.infoCircle;
              break;
            case LocationPermissionStatus.denied:
              statusText = tr('driver_location_permission_needed');
              statusColor = context.colors.error;
              statusIcon = SolarIconsOutline.mapPointRemove;
              break;
            case LocationPermissionStatus.permanentlyDenied:
              statusText = tr('driver_location_permission_denied');
              statusColor = context.colors.error;
              statusIcon = SolarIconsOutline.settings;
              break;
            default:
              statusText = tr('driver_location_permission_pending');
              statusColor = context.ext.warning;
              statusIcon = SolarIconsOutline.stopwatch;
          }
        }

        // Don't show anything if status is null on first launch
        if (status == null) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.m),
          margin: const EdgeInsets.only(bottom: AppSpacing.s),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.small),
            border: Border.all(color: statusColor),
          ),
          child: Row(
            children: [
              Icon(statusIcon, color: statusColor, semanticLabel: 'Location status'),
              const SizedBox(width: AppSpacing.ms),
              Expanded(
                child: Text(
                  statusText,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
