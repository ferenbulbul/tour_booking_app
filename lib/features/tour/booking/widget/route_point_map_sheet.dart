import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/models/tour_detail_sub_items/tour_detail_sub_items.dart';

class RoutePointMapSheet extends StatelessWidget {
  final RoutePointItem point;

  const RoutePointMapSheet({super.key, required this.point});

  Color _dotColor(BuildContext context, int pointType) {
    switch (pointType) {
      case 0:
        return context.colors.secondary;
      case 1:
        return context.ext.info;
      default:
        return context.ext.textLight;
    }
  }

  String _pointLabel(int pointType) {
    switch (pointType) {
      case 0:
        return tr("route_point_start");
      case 1:
        return tr("route_point_stop");
      default:
        return tr("route_point_pass");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dotColor = _dotColor(context, point.pointType);
    final position = LatLng(point.latitude, point.longitude);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.35,
      maxChildSize: 0.75,
      expand: false,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xxl),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.m, bottom: AppSpacing.s),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.colors.outline,
                    borderRadius: BorderRadius.circular(AppRadius.xxs),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.l,
                  vertical: AppSpacing.s,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            point.name,
                            style: AppTextStyles.titleMedium,
                          ),
                          Text(
                            _pointLabel(point.pointType),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: dotColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: context.colors.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, size: AppIconSize.ml, semanticLabel: 'Close'),
                      ),
                    ),
                  ],
                ),
              ),
              if (point.description != null && point.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                  ).copyWith(bottom: AppSpacing.m),
                  child: Text(
                    point.description!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: context.colors.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                ),
              // Map
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(AppRadius.xxl),
                  ),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: position,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(point.name),
                        position: position,
                        infoWindow: InfoWindow(title: point.name),
                      ),
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
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
