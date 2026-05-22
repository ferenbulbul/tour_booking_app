import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/features/transport/models/place_picker_models.dart';
import 'package:tour_booking/features/transport/transport_place_picker_viewmodel.dart';

/// Bottom panel of the place picker screen showing location slots,
/// route option cards, and the confirm button.
class RouteOptionsPanel extends StatelessWidget {
  final TransportPlacePickerViewModel vm;
  final VoidCallback onPickupTap;
  final VoidCallback onDropoffTap;
  final VoidCallback? onConfirm;

  const RouteOptionsPanel({
    super.key,
    required this.vm,
    required this.onPickupTap,
    required this.onDropoffTap,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.xl, AppSpacing.l, AppSpacing.m),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Location slots + Swap
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _locationSlot(
                        context: context,
                        color: context.ext.success,
                        address: vm.pickupAddr,
                        placeholder: tr('transport_search_pickup'),
                        isActive: vm.isPickupMode,
                        onTap: onPickupTap,
                        onClear: () => vm.clearPickup(),
                      ),
                      const SizedBox(height: AppSpacing.ml),
                      _locationSlot(
                        context: context,
                        color: context.colors.error,
                        address: vm.dropoffAddr,
                        placeholder: tr('transport_search_dropoff'),
                        isActive: !vm.isPickupMode,
                        onTap: onDropoffTap,
                        onClear: () => vm.clearDropoff(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Semantics(
                  button: true,
                  label: 'Swap pickup and dropoff locations',
                  child: GestureDetector(
                    onTap: (vm.pickupPos != null ||
                            vm.dropoffPos != null)
                        ? vm.swapLocations
                        : null,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: context.colors.secondary
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(SolarIconsOutline.roundArrowLeftDown,
                          size: AppIconSize.l, color: context.colors.secondary, semanticLabel: 'Swap locations'),
                    ),
                  ),
                ),
              ],
            ),

            // Route cards
            if (vm.routes.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.m),
              SizedBox(
                height: 64,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: vm.routes.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.s),
                  itemBuilder: (_, i) =>
                      _routeCard(context, vm.routes[i], i, vm),
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.m),

            PrimaryButton(
              text: tr('continue'),
              icon: SolarIconsOutline.altArrowRight,
              onPressed: onConfirm,
            ),
          ],
        ),
      ),
    );
  }

  Widget _routeCard(
      BuildContext context, ParsedRoute route, int index, TransportPlacePickerViewModel vm) {
    final isSelected = index == vm.selectedRouteIndex;
    return Semantics(
      button: true,
      label: 'Select route ${index + 1}',
      child: GestureDetector(
        onTap: () => vm.selectRoute(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.ml, vertical: AppSpacing.s),
          decoration: BoxDecoration(
            color: isSelected ? context.colors.secondary : context.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(
              color: isSelected ? context.colors.secondary : context.colors.outline,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: context.colors.secondary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                route.summary.isNotEmpty
                    ? route.summary
                    : tr('transport_route_number', namedArgs: {'number': '${index + 1}'}),
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? context.colors.onSecondary : context.colors.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${route.distanceText} \u2022 ${route.durationText}',
                style: AppTextStyles.caption.copyWith(
                  color:
                      isSelected ? context.colors.onSecondary.withValues(alpha: 0.7) : context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationSlot({
    required BuildContext context,
    required Color color,
    required String? address,
    required String placeholder,
    required bool isActive,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    final hasAddr = address != null && address.isNotEmpty;
    return Semantics(
      button: true,
      label: placeholder,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.ms),
          decoration: BoxDecoration(
            border: Border.all(
              color: isActive
                  ? color.withValues(alpha: 0.5)
                  : context.colors.outline,
              width: isActive ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppRadius.ms),
          ),
          child: Row(
            children: [
              Icon(Icons.circle, size: AppSpacing.ms, color: color),
              const SizedBox(width: AppSpacing.ms),
              Expanded(
                child: Text(
                  hasAddr ? address : placeholder,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight:
                        hasAddr ? FontWeight.w600 : FontWeight.w400,
                    color: hasAddr
                        ? context.colors.onSurface
                        : context.ext.textLight,
                  ),
                ),
              ),
              if (hasAddr)
                Semantics(
                  button: true,
                  label: 'Clear address',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onClear,
                    child: Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.s),
                      child: Icon(SolarIconsOutline.closeCircle,
                          size: AppIconSize.m, color: context.ext.textLight, semanticLabel: 'Clear'),
                    ),
                  ),
                )
              else
                Icon(SolarIconsOutline.magnifier, size: AppIconSize.ml, color: context.ext.textLight, semanticLabel: 'Search'),
            ],
          ),
        ),
      ),
    );
  }
}
