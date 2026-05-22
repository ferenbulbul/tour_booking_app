import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:intl/intl.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/models/transport/transport_vehicle/transport_vehicle.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class TransportVehicleCard extends StatelessWidget {
  final TransportVehicle vehicle;
  final VoidCallback onTap;

  const TransportVehicleCard({
    super.key,
    required this.vehicle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${vehicle.brandName} ${vehicle.className}',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.large),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with gradient overlay + class badge
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.large - 1),
              ),
              child: Stack(
                children: [
                  // Image
                  (vehicle.vehicleImage != null &&
                          vehicle.vehicleImage!.isNotEmpty)
                      ? Semantics(
                          image: true,
                          label: 'Vehicle photo',
                          child: CachedNetworkImage(
                            imageUrl: vehicle.vehicleImage!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              height: 160,
                              color: context.colors.outline.withValues(alpha: 0.4),
                            ),
                          ),
                        )
                      : Container(
                          height: 160,
                          color: context.colors.outline.withValues(alpha: 0.4),
                          child: Center(
                            child: Icon(SolarIconsOutline.routing,
                                size: AppIconSize.huge, color: context.ext.textLight, semanticLabel: 'Vehicle'),
                          ),
                        ),

                  // Gradient overlay (bottom)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 60,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.35),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Class badge (top-left)
                  if (vehicle.className.isNotEmpty)
                    Positioned(
                      left: AppSpacing.ms,
                      top: AppSpacing.ms,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.ms,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.85),
                          borderRadius:
                              BorderRadius.circular(AppRadius.small),
                        ),
                        child: Text(
                          vehicle.className,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand + price
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${vehicle.brandName} ${vehicle.className}',
                          style: AppTextStyles.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatPrice(vehicle.baseFee),
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
                            size: AppIconSize.s, color: context.colors.onSurfaceVariant, semanticLabel: 'Agency'),
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

                  const SizedBox(height: AppSpacing.sm),

                  // Rating
                  if (vehicle.avgRating > 0 && vehicle.ratingCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Row(
                        children: [
                          ...List.generate(5, (i) {
                            final r = vehicle.avgRating;
                            IconData icon;
                            if (i < r.floor()) {
                              icon = Icons.star_rounded;
                            } else if (i < r.ceil() &&
                                r - r.floor() >= 0.5) {
                              icon = Icons.star_half_rounded;
                            } else {
                              icon = Icons.star_outline_rounded;
                            }
                            return Icon(icon,
                                size: AppIconSize.s, color: context.ext.warning, semanticLabel: 'Rating star');
                          }),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            "${vehicle.avgRating.toStringAsFixed(1)} (${vehicle.ratingCount})",
                            style: AppTextStyles.caption.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Specs + chevron
                  Row(
                    children: [
                      Icon(SolarIconsOutline.usersGroupRounded,
                          size: AppIconSize.s, color: context.ext.textLight, semanticLabel: 'Seat count'),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        "${vehicle.seatCount} Koltuk",
                        style: AppTextStyles.labelSmall.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      _dot(context),
                      Text(
                        '${_formatPrice(vehicle.pricePerKm)}/km',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        SolarIconsOutline.altArrowRight,
                        size: AppIconSize.m,
                        color: context.ext.textLight,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _dot(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Text(
        "\u00B7",
        style: AppTextStyles.labelSmall.copyWith(
          color: context.ext.textLight,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  String _formatPrice(num value) {
    return NumberFormat.currency(
      locale: 'tr_TR',
      symbol: '\u20BA',
      decimalDigits: 2,
    ).format(value);
  }
}
