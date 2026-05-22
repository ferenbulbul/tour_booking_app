import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_elevation.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/widgets/section_title.dart';

/// The scrollable body content of the vehicle detail screen.
///
/// Displays vehicle specifications grid, extra features, and driver section.
class VehicleDetailBody extends StatelessWidget {
  final dynamic vehicle;

  const VehicleDetailBody({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    final v = vehicle;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
        ).copyWith(top: AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SectionTitle(title: tr("vehicle_features_title")),

            const SizedBox(height: AppSpacing.l),

            // --- 3x2 GRID (vehicle specifications) ---
            LayoutBuilder(
              builder: (_, c) {
                final maxW = c.maxWidth;
                final itemW = (maxW - AppSpacing.m) / 2;
                return Wrap(
                  spacing: AppSpacing.m,
                  runSpacing: AppSpacing.m,
                  children: [
                    _specTile(
                      context,
                      SolarIconsOutline.routing,
                      tr("vehicle_brand"),
                      v.vehicleBrand,
                      itemW,
                    ),
                    _specTile(
                      context,
                      SolarIconsOutline.settings,
                      tr("vehicle_class"),
                      v.vehicleClass,
                      itemW,
                    ),
                    _specTile(
                      context,
                      SolarIconsOutline.ticket,
                      tr("vehicle_type"),
                      v.vehicleType,
                      itemW,
                    ),
                    _specTile(
                      context,
                      SolarIconsOutline.usersGroupRounded,
                      tr("seat_count"),
                      "${v.seatCount}",
                      itemW,
                    ),
                    _specTile(
                      context,
                      SolarIconsOutline.calendarDate,
                      tr("model_year"),
                      "${v.modelYear}",
                      itemW,
                    ),
                    _specTile(
                      context,
                      SolarIconsOutline.routing,
                      tr("legroom"),
                      v.legRoomSpace ?? "-",
                      itemW,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: AppSpacing.xxl),

            // --- EXTRA FEATURES ---
            if ((v.vehicleFeatures?.isNotEmpty ?? false)) ...[
              SectionTitle(title: tr("extra_features")),
              const SizedBox(height: AppSpacing.l),

              LayoutBuilder(
                builder: (_, constraints) {
                  double maxW = constraints.maxWidth;
                  double itemW = (maxW - AppSpacing.m) / 2;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: v.vehicleFeatures!.map<Widget>((f) {
                      return _featureItem(context, f, itemW);
                    }).toList(),
                  );
                },
              ),
            ],

            // Spacing
            const SizedBox(height: AppSpacing.xxl),

            SectionTitle(
              title: tr("driver_info_title"),
              subtitle: tr("driver_info_subtitle"),
            ),
            const SizedBox(height: AppSpacing.l),

            _driverSection(
              context: context,
              name: v.nameSurname,
              experience: v.experienceYear,
              photoUrl: v.photoUrl,
              languages: v.languages,
            ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // SPEC TILE (6 item grid)
  // -------------------------------------------------------------------------
  Widget _specTile(
      BuildContext context, IconData icon, String label, String value, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.ml, vertical: AppSpacing.ml),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: context.colors.outline),
        boxShadow: AppElevation.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: AppIconSize.xxl,
              color: context.colors.onSurface),
          const SizedBox(height: AppSpacing.s),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // FEATURE ITEM (2 column)
  // -------------------------------------------------------------------------
  Widget _featureItem(BuildContext context, String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.ml, vertical: AppSpacing.ms),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: context.colors.outline),
      ),
      child: Row(
        children: [
          Icon(SolarIconsOutline.checkCircle,
              color: context.ext.success,
              size: AppIconSize.m,
              semanticLabel: 'Included'),
          const SizedBox(width: AppSpacing.s),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }
}

Widget _driverSection({
  required BuildContext context,
  required String? name,
  required String? experience,
  required String? photoUrl,
  required List<String>? languages,
}) {
  return Container(
    margin: EdgeInsets.all(AppSpacing.xs),
    padding: const EdgeInsets.all(AppSpacing.l),
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      border: Border.all(color: context.colors.outline),
      boxShadow: AppElevation.shadowMd,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Semantics(
              image: true,
              label: 'Profile photo',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.circular),
                child: CachedNetworkImage(
                  imageUrl: photoUrl ?? "",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: context.colors.outline,
                      shape: BoxShape.circle,
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: context.colors.outline,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(SolarIconsOutline.user,
                        color: context.ext.textLight,
                        semanticLabel: 'Driver'),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name ?? "", style: AppTextStyles.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    tr(
                      "driver_experience",
                      namedArgs: {
                        "year": experience?.toString() ?? "\u2014"
                      },
                    ),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        if (languages != null && languages.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          Text(tr("driver_languages"), style: AppTextStyles.labelLarge),
          const SizedBox(height: AppSpacing.ms),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: languages.map((lang) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.ms,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: Text(lang, style: AppTextStyles.bodySmall),
              );
            }).toList(),
          ),
        ],
      ],
    ),
  );
}
