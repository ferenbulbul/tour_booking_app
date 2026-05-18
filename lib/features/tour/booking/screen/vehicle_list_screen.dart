import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/tour/booking/tour_vehicle_guide_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/widget/vehicle_detail_sheet.dart';
import 'package:tour_booking/features/tour/booking/widget/vehicle_skeleton.dart';
import 'package:tour_booking/models/vehicle/vehicle.dart';
import 'package:tour_booking/models/vehicle_detail_request/vehicle_detail_request.dart';

class TourVehicleListScreen extends StatelessWidget {
  const TourVehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TourVehicleGuideViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(title: tr("available_vehicles")),
      body: vm.isVehiclesLoading
          ? const Center(child: VehicleCardSkeleton())
          : vm.vehicles.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  physics: const BouncingScrollPhysics(),
                  itemCount: vm.vehicles.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.m),
                  itemBuilder: (_, i) => _VehicleCard(
                    vehicle: vm.vehicles[i],
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(SolarIconsOutline.routing, size: 48, color: AppColors.textLight),
            const SizedBox(height: AppSpacing.l),
            Text(
              tr("vehicle_not_found"),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const _VehicleCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(13),
              ),
              child: CachedNetworkImage(
                imageUrl: vehicle.image,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 160,
                  color: AppColors.border.withValues(alpha: 0.4),
                ),
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
                          vehicle.vehicleBrand,
                          style: AppTextStyles.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatPrice(vehicle.price),
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),

                  // Şirket adı
                  if (vehicle.companyName != null &&
                      vehicle.companyName!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(SolarIconsOutline.buildings,
                              size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              vehicle.companyName!,
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
                  if (vehicle.avgRating != null && vehicle.avgRating! > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          ...List.generate(5, (i) {
                            final r = vehicle.avgRating!;
                            IconData icon;
                            if (i < r.floor()) {
                              icon = Icons.star_rounded;
                            } else if (i < r.ceil() &&
                                r - r.floor() >= 0.5) {
                              icon = Icons.star_half_rounded;
                            } else {
                              icon = Icons.star_outline_rounded;
                            }
                            return Icon(icon, size: 14, color: AppColors.warning);
                          }),
                          const SizedBox(width: 4),
                          Text(
                            "${vehicle.avgRating!.toStringAsFixed(1)} (${vehicle.ratingCount ?? 0})",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Specs — inline
                  Row(
                    children: [
                      Icon(SolarIconsOutline.usersGroupRounded, size: 14, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(
                        "${vehicle.seatCount} ${tr('seat_count')}",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      _dot(),
                      Text(
                        vehicle.vehicleType,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      _dot(),
                      Flexible(
                        child: Text(
                          vehicle.vehicleClass,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
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
      ),
    );
  }

  Widget _dot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        "·",
        style: TextStyle(
          color: AppColors.textLight,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    final vm = context.read<TourVehicleGuideViewModel>();
    vm.setSelectedPrice(vehicle.price);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: vm,
        child: VehicleDetailSheet(
          request: VehicleDetailRequest(
            vehicleId: vehicle.vehicleId,
            tourRouteId: vehicle.tourRouteId,
          ),
          heroImage: vehicle.image,
        ),
      ),
    );
  }

  String _formatPrice(num value) {
    return NumberFormat.currency(
      locale: 'tr_TR',
      symbol: '₺',
      decimalDigits: 2,
    ).format(value);
  }
}
