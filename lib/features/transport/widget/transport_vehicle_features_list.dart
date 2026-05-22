import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/models/transport/transport_vehicle/transport_vehicle.dart';

/// Displays the pricing breakdown and driver info sections
/// inside the vehicle detail bottom sheet.
class TransportVehicleFeaturesList extends StatelessWidget {
  final TransportVehicle vehicle;
  final String Function(num value) formatPrice;

  const TransportVehicleFeaturesList({
    super.key,
    required this.vehicle,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pricing section
        _sectionLabel(context, tr("transport_pricing")),
        const SizedBox(height: AppSpacing.ms),
        _pricingSection(context),

        // Driver section
        const SizedBox(height: AppSpacing.l + 2),
        _sectionLabel(context, tr("driver_info_title")),
        const SizedBox(height: AppSpacing.ms),
        _driverRow(context),
      ],
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: AppTextStyles.labelLarge,
    );
  }

  Widget _pricingSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: context.colors.outline),
      ),
      child: Column(
        children: [
          _priceRow(
            context,
            SolarIconsOutline.flag,
            tr("transport_base_fee"),
            formatPrice(vehicle.baseFee),
          ),
          const SizedBox(height: AppSpacing.ms),
          _priceRow(
            context,
            SolarIconsOutline.ruler,
            tr("transport_price_per_km"),
            '${formatPrice(vehicle.pricePerKm)}/km',
          ),
        ],
      ),
    );
  }

  Widget _priceRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: AppIconSize.ml, color: context.ext.textLight),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: context.colors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _driverRow(BuildContext context) {
    final hasPhoto =
        vehicle.driverPhoto != null && vehicle.driverPhoto!.isNotEmpty;

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
              child: hasPhoto
                  ? CachedNetworkImage(
                      imageUrl: vehicle.driverPhoto!,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _driverPlaceholder(context),
                      errorWidget: (_, __, ___) => _driverPlaceholder(context),
                    )
                  : _driverPlaceholder(context),
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.driverName,
                  style: AppTextStyles.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  children: [
                    if (vehicle.experienceYears != null) ...[
                      Text(
                        tr("driver_experience",
                            namedArgs: {"year": vehicle.experienceYears!}),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      _dot(context),
                    ],
                    Flexible(
                      child: Text(
                        vehicle.agencyName,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _driverPlaceholder(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: context.colors.outline,
        shape: BoxShape.circle,
      ),
      child: Icon(SolarIconsOutline.user,
          size: AppIconSize.l, color: context.ext.textLight, semanticLabel: 'Driver'),
    );
  }

  Widget _dot(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs + 1),
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
