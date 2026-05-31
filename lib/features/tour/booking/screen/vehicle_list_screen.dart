import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
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
      backgroundColor: context.colors.surfaceContainerHighest,
      appBar: CommonAppBar(title: tr("available_vehicles")),
      body: vm.isVehiclesLoading
          ? ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.l),
              itemCount: 3,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.m),
              itemBuilder: (_, __) => const VehicleCardSkeleton(),
            )
          : vm.vehicles.isEmpty
              ? _buildEmptyState(context)
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(SolarIconsOutline.routing, size: AppIconSize.huge, color: context.ext.textLight, semanticLabel: 'No vehicles'),
            const SizedBox(height: AppSpacing.l),
            Text(
              tr("vehicle_not_found"),
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.onSurfaceVariant,
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
    return Semantics(
      button: true,
      label: 'View vehicle details',
      child: GestureDetector(
        onTap: () => _openDetail(context),
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.ml),
            border: Border.all(color: context.colors.outline),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Semantics(
              image: true,
              label: 'Vehicle photo',
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.medium),
                ),
                child: CachedNetworkImage(
                  imageUrl: vehicle.image,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 160,
                    color: context.colors.outline.withValues(alpha: 0.4),
                  ),
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
                          color: context.colors.secondary,
                        ),
                      ),
                    ],
                  ),

                  // Company name
                  if (vehicle.companyName != null &&
                      vehicle.companyName!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Row(
                        children: [
                          Icon(SolarIconsOutline.buildings,
                              size: AppIconSize.s, color: context.colors.onSurfaceVariant, semanticLabel: 'Company'),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              vehicle.companyName!,
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
                  if (vehicle.avgRating != null && vehicle.avgRating! > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
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
                            return Icon(icon, size: AppIconSize.s, color: context.ext.warning, semanticLabel: 'Rating star');
                          }),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            "${vehicle.avgRating!.toStringAsFixed(1)} (${vehicle.ratingCount ?? 0})",
                            style: AppTextStyles.caption.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Specs — inline
                  Row(
                    children: [
                      Icon(SolarIconsOutline.usersGroupRounded, size: AppIconSize.s, color: context.ext.textLight, semanticLabel: 'Seat count'),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        "${vehicle.seatCount} ${tr('seat_count')}",
                        style: AppTextStyles.labelSmall.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      _dot(context),
                      Text(
                        vehicle.vehicleType,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      _dot(context),
                      Flexible(
                        child: Text(
                          vehicle.vehicleClass,
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
      symbol: '\u20BA',
      decimalDigits: 2,
    ).format(value);
  }
}
