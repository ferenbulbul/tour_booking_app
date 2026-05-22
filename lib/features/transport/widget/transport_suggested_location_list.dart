import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/models/transport/suggested_location/suggested_location.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class TransportSuggestedLocationList extends StatelessWidget {
  final List<TransportSuggestedLocation> locations;
  final void Function(TransportSuggestedLocation) onPickup;
  final void Function(TransportSuggestedLocation) onDropoff;

  const TransportSuggestedLocationList({
    super.key,
    required this.locations,
    required this.onPickup,
    required this.onDropoff,
  });

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: locations.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s),
        itemBuilder: (context, index) {
          final loc = locations[index];
          return Semantics(
            button: true,
            label: 'Select location ${loc.name}',
            child: GestureDetector(
              onTap: () => _showOptions(context, loc),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.ml, vertical: AppSpacing.ms),
              decoration: BoxDecoration(
                color: context.colors.secondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.xlm),
                border: Border.all(
                  color: context.colors.secondary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(SolarIconsOutline.mapPoint, size: AppIconSize.m, color: context.colors.secondary, semanticLabel: 'Location'),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    loc.name,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            ),
          );
        },
      ),
    );
  }

  void _showOptions(BuildContext context, TransportSuggestedLocation loc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.s),
                child: Text(
                  loc.name,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (loc.description != null && loc.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  child: Text(
                    loc.description!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.m),
              ListTile(
                leading: Icon(Icons.circle, color: context.ext.success, size: AppIconSize.m, semanticLabel: 'Pickup'),
                title: Text(tr('transport_select_as_pickup')),
                onTap: () {
                  Navigator.pop(context);
                  onPickup(loc);
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, color: context.colors.error, size: AppIconSize.m, semanticLabel: 'Dropoff'),
                title: Text(tr('transport_select_as_dropoff')),
                onTap: () {
                  Navigator.pop(context);
                  onDropoff(loc);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
