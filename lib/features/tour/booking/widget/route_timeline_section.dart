import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/tour/booking/widget/route_map_sheet.dart' show RouteMapPage;
import 'package:tour_booking/features/tour/booking/widget/route_point_map_sheet.dart';
import 'package:tour_booking/models/tour_detail_sub_items/tour_detail_sub_items.dart';

class RouteTimelineSection extends StatelessWidget {
  final List<RoutePointItem> routePoints;
  final bool showTitle;
  final bool showCard;

  const RouteTimelineSection({
    super.key,
    required this.routePoints,
    this.showTitle = true,
    this.showCard = true,
  });

  Color _pointColor(int pointType) {
    switch (pointType) {
      case 0:
        return AppColors.accent;
      case 1:
        return AppColors.info;
      default:
        return AppColors.textLight;
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
    if (routePoints.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        ...List.generate(routePoints.length, (index) {
          final point = routePoints[index];
          final isLast = index == routePoints.length - 1;
          final isFirst = index == 0;
          final color = _pointColor(point.pointType);
          final dotSize = isFirst || isLast ? 12.0 : 8.0;

          // Uses CustomSingleChildLayout-free approach:
          // Left side has a dot + connector via decoration on a Container
          // that wraps the content. No IntrinsicHeight needed.
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _showRoutePointSheet(context, point),
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.xl),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline dot
                  Container(
                    width: 20,
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: isFirst || isLast ? 4 : 6),
                    child: Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: BoxDecoration(
                        color: isFirst || isLast
                            ? color
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color,
                          width: isFirst || isLast ? 0 : 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          point.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _pointLabel(point.pointType),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: color,
                          ),
                        ),
                        if (point.description != null &&
                            point.description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              point.description!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.3,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        // "Haritada Gör" button
        const SizedBox(height: AppSpacing.m),
        GestureDetector(
          onTap: () => _showRouteMapSheet(context),
          child: Row(
            children: [
              Icon(
                Icons.map_outlined,
                size: 16,
                color: AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                tr("view_on_map"),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showRoutePointSheet(BuildContext context, RoutePointItem point) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RoutePointMapSheet(point: point),
    );
  }

  void _showRouteMapSheet(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RouteMapPage(points: routePoints),
      ),
    );
  }
}

