import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:intl/intl.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/models/transport/transport_vehicle/transport_vehicle.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
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
                      ? CachedNetworkImage(
                          imageUrl: vehicle.vehicleImage!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            height: 160,
                            color: AppColors.border.withValues(alpha: 0.4),
                          ),
                        )
                      : Container(
                          height: 160,
                          color: AppColors.border.withValues(alpha: 0.4),
                          child: const Center(
                            child: Icon(SolarIconsOutline.routing,
                                size: 48, color: Colors.grey),
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
                      left: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.85),
                          borderRadius:
                              BorderRadius.circular(AppRadius.small),
                        ),
                        child: Text(
                          vehicle.className,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
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
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),

                  // Agency name
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Icon(SolarIconsOutline.buildings,
                            size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            vehicle.agencyName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Rating
                  if (vehicle.avgRating > 0 && vehicle.ratingCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
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
                                size: 14, color: AppColors.warning);
                          }),
                          const SizedBox(width: 4),
                          Text(
                            "${vehicle.avgRating.toStringAsFixed(1)} (${vehicle.ratingCount})",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Specs + chevron
                  Row(
                    children: [
                      Icon(SolarIconsOutline.usersGroupRounded,
                          size: 14, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(
                        "${vehicle.seatCount} Koltuk",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      _dot(),
                      Text(
                        '${_formatPrice(vehicle.pricePerKm)}/km',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        SolarIconsOutline.altArrowRight,
                        size: 16,
                        color: AppColors.textLight,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        "\u00B7",
        style: TextStyle(
          color: AppColors.textLight,
          fontWeight: FontWeight.w900,
          fontSize: 12,
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
