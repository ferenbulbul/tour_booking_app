import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/models/transport/transport_vehicle/transport_vehicle.dart';

/// Displays the vehicle header (brand, agency, rating) and the specs grid
/// inside the vehicle detail bottom sheet.
class TransportVehicleInfoSection extends StatelessWidget {
  final TransportVehicle vehicle;
  final String formattedPrice;

  const TransportVehicleInfoSection({
    super.key,
    required this.vehicle,
    required this.formattedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand + price row
        Row(
          children: [
            Expanded(
              child: Text(
                '${vehicle.brandName} ${vehicle.className}',
                style: AppTextStyles.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              formattedPrice,
              style: AppTextStyles.titleSmall.copyWith(
                color: context.colors.secondary,
              ),
            ),
          ],
        ),

        // Agency name
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Row(
            children: [
              Icon(SolarIconsOutline.buildings,
                  size: AppIconSize.m, color: context.colors.onSurfaceVariant, semanticLabel: 'Agency'),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  vehicle.agencyName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Rating
        if (vehicle.avgRating > 0 && vehicle.ratingCount > 0) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              ...List.generate(5, (i) {
                final r = vehicle.avgRating;
                IconData icon;
                if (i < r.floor()) {
                  icon = Icons.star_rounded;
                } else if (i < r.ceil() && r - r.floor() >= 0.5) {
                  icon = Icons.star_half_rounded;
                } else {
                  icon = Icons.star_outline_rounded;
                }
                return Icon(icon, size: AppIconSize.m, color: context.ext.warning, semanticLabel: 'Rating star');
              }),
              const SizedBox(width: AppSpacing.xs),
              Text(
                "${vehicle.avgRating.toStringAsFixed(1)} (${vehicle.ratingCount})",
                style: AppTextStyles.labelSmall.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: AppSpacing.l),

        // Specs grid
        _sectionLabel(context, tr("vehicle_features_title")),
        const SizedBox(height: AppSpacing.ms),
        _specsGrid(context),
      ],
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: AppTextStyles.labelLarge,
    );
  }

  Widget _specsGrid(BuildContext context) {
    final specs = <SpecItem>[
      SpecItem(
          SolarIconsOutline.routing, tr("vehicle_brand"), vehicle.brandName),
      SpecItem(
          SolarIconsOutline.settings, tr("vehicle_class"), vehicle.className),
      SpecItem(SolarIconsOutline.usersGroupRounded, tr("seat_count"),
          "${vehicle.seatCount}"),
      if (vehicle.modelYear != null)
        SpecItem(SolarIconsOutline.calendarDate, tr("model_year"),
            vehicle.modelYear!),
    ];

    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children: specs.map((s) {
        return SizedBox(
          width:
              (MediaQuery.of(context).size.width - AppSpacing.l * 2 - AppSpacing.s) / 2,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.ms),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.ms),
              border: Border.all(color: context.colors.outline),
            ),
            child: Row(
              children: [
                Icon(s.icon, size: AppIconSize.ml, color: context.ext.textLight),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.label,
                        style: AppTextStyles.caption.copyWith(
                          color: context.ext.textLight,
                        ),
                      ),
                      Text(
                        s.value,
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Data class for a single spec item in the vehicle specs grid.
class SpecItem {
  final IconData icon;
  final String label;
  final String value;
  const SpecItem(this.icon, this.label, this.value);
}
