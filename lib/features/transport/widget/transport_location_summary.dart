import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_elevation.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/widgets/picker_field.dart';
import 'package:tour_booking/core/widgets/shake_widget.dart';
import 'package:tour_booking/features/transport/transport_viewmodel.dart';
import 'package:tour_booking/features/transport/widget/transport_location_input.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/transport/transport_route_map_viewmodel.dart';
import 'package:tour_booking/features/transport/widget/transport_route_map.dart';

/// Displays the route section of the transport booking screen:
/// city picker, connected pickup/dropoff inputs, and the route map preview.
class TransportLocationSummary extends StatelessWidget {
  final TransportViewModel vm;
  final bool showErrors;
  final GlobalKey<ShakeWidgetState> cityShakeKey;
  final GlobalKey<ShakeWidgetState> pickupShakeKey;
  final GlobalKey<ShakeWidgetState> dropoffShakeKey;
  final VoidCallback onPickCity;
  final VoidCallback onPickupTap;
  final VoidCallback onDropoffTap;
  final void Function(RouteInfo info) onRouteSelected;

  const TransportLocationSummary({
    super.key,
    required this.vm,
    required this.showErrors,
    required this.cityShakeKey,
    required this.pickupShakeKey,
    required this.dropoffShakeKey,
    required this.onPickCity,
    required this.onPickupTap,
    required this.onDropoffTap,
    required this.onRouteSelected,
  });

  @override
  Widget build(BuildContext context) {
    final hasRoute = vm.pickupLat != null && vm.dropoffLat != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(
          context,
          SolarIconsOutline.routing,
          tr("transport_route_section"),
        ),
        _sectionCard(
          context,
          child: Column(
            children: [
              // City
              ShakeWidget(
                key: cityShakeKey,
                child: CompactPickerField(
                  icon: SolarIconsOutline.buildings_3,
                  label: tr("transport_select_city"),
                  value: vm.selectedCityName,
                  showError: showErrors && vm.selectedCityId == null,
                  onTap: onPickCity,
                ),
              ),

              const SizedBox(height: AppSpacing.m),

              // Connected pickup + dropoff
              ConnectedLocationInputs(
                pickupLabel: 'transport_select_pickup'.tr(),
                pickupAddress: vm.pickupAddress,
                dropoffLabel: 'transport_select_dropoff'.tr(),
                dropoffAddress: vm.dropoffAddress,
                onPickupTap: onPickupTap,
                onDropoffTap: onDropoffTap,
                onSwap: (vm.pickupLat != null || vm.dropoffLat != null)
                    ? () => vm.swapLocations()
                    : null,
                showPickupError: showErrors && vm.pickupLat == null,
                showDropoffError: showErrors && vm.dropoffLat == null,
                pickupShakeKey: pickupShakeKey,
                dropoffShakeKey: dropoffShakeKey,
              ),

              // Route map (conditional)
              if (hasRoute) ...[
                const SizedBox(height: AppSpacing.m),
                Semantics(
                  button: true,
                  label: 'Edit route on map',
                  child: GestureDetector(
                    onTap: onPickupTap,
                    child: ChangeNotifierProvider(
                      create: (_) => TransportRouteMapViewModel(),
                      child: TransportRouteMap(
                        key: ValueKey(
                            '${vm.pickupLat}_${vm.pickupLng}_${vm.dropoffLat}_${vm.dropoffLng}'),
                        pickupLat: vm.pickupLat!,
                        pickupLng: vm.pickupLng!,
                        dropoffLat: vm.dropoffLat!,
                        dropoffLng: vm.dropoffLng!,
                        height: 160,
                        initialDistanceKm: vm.selectedRouteDistanceKm,
                        onRouteSelected: onRouteSelected,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.l),
      child: Row(
        children: [
          Icon(icon, size: AppIconSize.xl - 2, color: context.colors.secondary),
          const SizedBox(width: AppSpacing.s),
          Text(
            text,
            style: AppTextStyles.titleSmall.copyWith(
              color: context.colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppElevation.shadowSm,
      ),
      child: child,
    );
  }
}
