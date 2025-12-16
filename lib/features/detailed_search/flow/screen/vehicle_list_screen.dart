import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/detailed_search/flow/tour_search_detail_viewmodel.dart';
import 'package:tour_booking/features/detailed_search/flow/widget/vehicle_skelaton.dart';
import 'package:tour_booking/models/vehicle/vehicle.dart';
import 'package:tour_booking/models/vehicle_detail_request/vehicle_detail_request.dart';

class TourVehicleListScreen extends StatelessWidget {
  const TourVehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TourSearchDetailViewModel>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: const CommonAppBar(title: "Müsait Araçlar"),
      body: vm.isVehiclesLoading
          ? const Center(child: VehicleCardSkeleton())
          : vm.vehicles == null || vm.vehicles!.isEmpty
          ? _buildEmptyState(context)
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              physics: const BouncingScrollPhysics(),
              itemCount: vm.vehicles!.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.l),
              itemBuilder: (_, i) => VehicleCard(vehicle: vm.vehicles![i]),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: scheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.06),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.no_crash_outlined,
                size: 48,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              "Bu kriterlere uygun araç bulunamadı",
              style: AppTextStyles.bodyMedium.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// VEHICLE CARD
// ============================================================================
class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        final vm = context.read<TourSearchDetailViewModel>();
        vm.setSelectedPrice(vehicle.price);

        context.pushNamed(
          'vehicleDetail',
          extra: VehicleDetailRequest(
            vehicleId: vehicle.vehicleId,
            tourRouteId: vehicle.tourRouteId,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.large),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE + PRICE ---------------------------------------------------
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.large),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: vehicle.image,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: AppColors.border.withOpacity(.4)),
                  ),
                ),
                Positioned(
                  top: AppSpacing.m,
                  right: AppSpacing.m,
                  child: _PriceBadge(price: vehicle.price),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.m),

            // BRAND ----------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Text(
                vehicle.vehicleBrand,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.s),

            // FEATURES -------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: [
                  _FeatureChip(
                    icon: Icons.event_seat,
                    label: "${vehicle.seatCount} Koltuk",
                  ),
                  _FeatureChip(
                    icon: Icons.directions_car_filled_rounded,
                    label: vehicle.vehicleType,
                  ),
                  _FeatureChip(
                    icon: Icons.directions_car_filled_rounded,
                    label: vehicle.vehicleClass,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.l),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// PRICE BADGE
// ============================================================================
class _PriceBadge extends StatelessWidget {
  final num price;
  const _PriceBadge({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        "$price ₺",
        style: AppTextStyles.labelLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ============================================================================
// FEATURE CHIP
// ============================================================================
class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
