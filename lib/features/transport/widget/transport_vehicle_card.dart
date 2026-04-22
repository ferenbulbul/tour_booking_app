import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
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

  String _formatPrice(num price) {
    final f = NumberFormat.currency(
        locale: 'tr_TR', symbol: '\u20BA', decimalDigits: 2);
    return f.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- IMAGE with overlays ----
            _buildImageSection(),

            // ---- CONTENT ----
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand + Model + Year
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
                      if (vehicle.modelYear != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            vehicle.modelYear!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Specs row
                  Row(
                    children: [
                      _specItem(Icons.event_seat_outlined,
                          '${vehicle.seatCount} Koltuk'),
                      const SizedBox(width: 16),
                      _specItem(Icons.straighten,
                          '${_formatPrice(vehicle.pricePerKm)}/km'),
                      const SizedBox(width: 16),
                      _specItem(Icons.payments_outlined,
                          _formatPrice(vehicle.baseFee)),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Divider
                  Divider(height: 1, color: Colors.grey.shade200),

                  const SizedBox(height: 14),

                  // Driver + Agency row
                  Row(
                    children: [
                      // Driver photo
                      _buildDriverAvatar(),
                      const SizedBox(width: 12),

                      // Driver info
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
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                if (vehicle.experienceYears != null) ...[
                                  Icon(Icons.workspace_premium,
                                      size: 13, color: Colors.amber.shade700),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${vehicle.experienceYears} yıl',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                  const SizedBox(width: 10),
                                ],
                                Icon(Icons.business,
                                    size: 13, color: AppColors.textLight),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    vehicle.agencyName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Arrow
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.arrow_forward_ios,
                            size: 14, color: AppColors.primary),
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

  Widget _buildImageSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
          child: (vehicle.vehicleImage != null &&
                  vehicle.vehicleImage!.isNotEmpty)
              ? CachedNetworkImage(
                  imageUrl: vehicle.vehicleImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child:
                        Container(height: 180, color: Colors.grey.shade300),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.directions_car,
                        size: 48, color: Colors.grey),
                  ),
                )
              : Container(
                  height: 180,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.directions_car,
                        size: 48, color: Colors.grey),
                  ),
                ),
        ),

        // Gradient overlay
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 60,
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Rating badge
        if (vehicle.avgRating > 0 && vehicle.ratingCount > 0)
          Positioned(
            left: 12,
            bottom: 10,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded,
                      size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    vehicle.avgRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${vehicle.ratingCount})',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Photo count badge
        if (vehicle.otherImages.isNotEmpty)
          Positioned(
            right: 12,
            bottom: 10,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.photo_library,
                      size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    '${vehicle.otherImages.length + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // License plate
        if (vehicle.licensePlate != null)
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text(
                vehicle.licensePlate!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDriverAvatar() {
    final hasPhoto =
        vehicle.driverPhoto != null && vehicle.driverPhoto!.isNotEmpty;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: hasPhoto
          ? CachedNetworkImage(
              imageUrl: vehicle.driverPhoto!,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              placeholder: (_, __) => _avatarPlaceholder(),
              errorWidget: (_, __, ___) => _avatarPlaceholder(),
            )
          : _avatarPlaceholder(),
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, size: 24, color: AppColors.primary),
    );
  }

  Widget _specItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
