import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

/// A data class holding a single specification item for display in the specs grid.
class SpecItem {
  final IconData icon;
  final String label;
  final String value;
  const SpecItem(this.icon, this.label, this.value);
}

/// Vehicle specifications grid, extra features chips, and driver row.
///
/// Used in [VehicleDetailSheet] to display the detailed vehicle information
/// below the header area.
class VehicleSpecsSection extends StatelessWidget {
  final dynamic vehicle;

  const VehicleSpecsSection({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    final v = vehicle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Specs grid
        _sectionLabel(context, tr("vehicle_features_title")),
        const SizedBox(height: AppSpacing.ms),
        _specsGrid(context, v),

        // Extra features
        if (v.vehicleFeatures != null && v.vehicleFeatures!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.ml),
          _sectionLabel(context, tr("extra_features")),
          const SizedBox(height: AppSpacing.ms),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: v.vehicleFeatures!.map<Widget>((f) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.ms, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: context.colors.secondary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(SolarIconsOutline.checkCircle,
                        size: AppIconSize.m,
                        color: context.ext.success,
                        semanticLabel: 'Included'),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      f,
                      style: AppTextStyles.labelMedium,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],

        // Driver section
        if (v.nameSurname != null && v.nameSurname!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.ml),
          _sectionLabel(context, tr("driver_info_title")),
          const SizedBox(height: AppSpacing.ms),
          _driverRow(context, v),
        ],

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: AppTextStyles.labelLarge,
    );
  }

  Widget _specsGrid(BuildContext context, dynamic v) {
    final specs = <SpecItem>[
      SpecItem(SolarIconsOutline.routing, tr("vehicle_brand"), v.vehicleBrand),
      SpecItem(
          SolarIconsOutline.settings, tr("vehicle_class"), v.vehicleClass),
      SpecItem(SolarIconsOutline.ticket, tr("vehicle_type"), v.vehicleType),
      SpecItem(SolarIconsOutline.usersGroupRounded, tr("seat_count"),
          "${v.seatCount}"),
      if (v.modelYear != null)
        SpecItem(SolarIconsOutline.calendarDate, tr("model_year"),
            "${v.modelYear}"),
      if (v.legRoomSpace != null)
        SpecItem(SolarIconsOutline.routing, tr("legroom"), v.legRoomSpace!),
    ];

    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children: specs.map((s) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - AppSpacing.l * 2 -
                  AppSpacing.s) /
              2,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.m, vertical: AppSpacing.ms),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.small),
              border: Border.all(color: context.colors.outline),
            ),
            child: Row(
              children: [
                Icon(s.icon,
                    size: AppIconSize.ml,
                    color: context.ext.textLight),
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

  Widget _driverRow(BuildContext context, dynamic v) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: context.colors.outline),
      ),
      child: Row(
        children: [
          Semantics(
            image: true,
            label: 'Profile photo',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xxl),
              child: CachedNetworkImage(
                imageUrl: v.photoUrl ?? "",
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: context.colors.outline,
                    shape: BoxShape.circle,
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: context.colors.outline,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(SolarIconsOutline.user,
                      size: AppIconSize.l,
                      color: context.ext.textLight,
                      semanticLabel: 'Driver'),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  v.nameSurname ?? "",
                  style: AppTextStyles.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  children: [
                    if (v.experienceYear != null) ...[
                      Text(
                        tr("driver_experience",
                            namedArgs: {
                              "year": v.experienceYear.toString()
                            }),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (v.languages != null &&
                        v.languages!.isNotEmpty) ...[
                      if (v.experienceYear != null) _dot(context),
                      Flexible(
                        child: Text(
                          (v.languages as List<String>).join(", "),
                          style: AppTextStyles.caption.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Text(
        "\u00B7",
        style: AppTextStyles.labelSmall.copyWith(
          color: context.ext.textLight,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
