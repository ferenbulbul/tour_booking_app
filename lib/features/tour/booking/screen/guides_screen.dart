import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/tour/booking/tour_detail_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_booking_selection_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_vehicle_guide_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/widget/guide_skeleton.dart';
import 'package:tour_booking/models/guide/guide.dart';

class GuidesScreen extends StatefulWidget {
  const GuidesScreen({super.key});

  @override
  State<GuidesScreen> createState() => _GuidesScreenState();
}

class _GuidesScreenState extends State<GuidesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final detailVm = context.read<TourDetailViewModel>();
      final selectionVm = context.read<TourBookingSelectionViewModel>();
      final vehicleGuideVm = context.read<TourVehicleGuideViewModel>();

      if (detailVm.selectedCityId != null &&
          detailVm.selectedDistrictId != null &&
          detailVm.selectedTourPointId != null &&
          selectionVm.selectedDate != null) {
        vehicleGuideVm.fetchGuides(
          cityId: detailVm.selectedCityId!,
          districtId: detailVm.selectedDistrictId!,
          tourPointId: detailVm.selectedTourPointId!,
          date: selectionVm.selectedDate!,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surfaceContainerHighest,
      appBar: CommonAppBar(title: tr("guide_selection_title")),
      body: Consumer<TourVehicleGuideViewModel>(
        builder: (context, vm, _) {
          if (vm.isGuidesLoading) {
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.l),
              itemCount: 4,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.m),
              itemBuilder: (_, __) => const GuideCardSkeleton(),
            );
          }

          final hasGuides = vm.guides.isNotEmpty;

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.l),
            physics: const BouncingScrollPhysics(),
            itemCount: hasGuides ? vm.guides.length + 1 : 2,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.m),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _WithoutGuideCard(
                  onTap: () {
                    vm.setSelectedGuide(null, 0);
                    context.push('/summary');
                  },
                );
              }

              if (!hasGuides && index == 1) {
                return const _NoGuideFoundCard();
              }

              final guide = vm.guides[index - 1];
              return _GuideCard(
                guide: guide,
                onTap: () {
                  vm.setSelectedGuide(guide.guideId, guide.price);
                  context.push('/summary');
                },
              );
            },
          );
        },
      ),
    );
  }
}

// -----
// Guide Card
// -----
class _GuideCard extends StatelessWidget {
  final Guide guide;
  final VoidCallback? onTap;

  const _GuideCard({required this.guide, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Select guide ${guide.firstName} ${guide.lastName}',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.ml),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.ml),
          border: Border.all(color: context.colors.outline),
        ),
        child: Row(
          children: [
            // Avatar
            Semantics(
              image: true,
              label: 'Profile photo',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xxl),
                child: CachedNetworkImage(
                  imageUrl: guide.image ?? "",
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: context.colors.outline,
                      shape: BoxShape.circle,
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: context.colors.outline,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      SolarIconsOutline.user,
                      color: context.ext.textLight,
                      size: AppIconSize.xl,
                      semanticLabel: 'Guide',
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.m),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + price
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${guide.firstName} ${guide.lastName}",
                          style: AppTextStyles.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatPrice(guide.price),
                        style: AppTextStyles.titleSmall.copyWith(
                          color: context.colors.secondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Rating
                  if (guide.avgRating != null && guide.avgRating! > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Row(
                        children: [
                          ...List.generate(5, (i) {
                            final r = guide.avgRating!;
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
                                size: AppIconSize.xsm, color: context.ext.warning, semanticLabel: 'Rating star');
                          }),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            "${guide.avgRating!.toStringAsFixed(1)} (${guide.ratingCount ?? 0})",
                            style: AppTextStyles.caption.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Languages inline
                  if (guide.languages.isNotEmpty)
                    Row(
                      children: [
                        Icon(SolarIconsOutline.globus,
                            size: AppIconSize.xsm, color: context.ext.textLight, semanticLabel: 'Languages'),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            guide.languages.join(", "),
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

            const SizedBox(width: AppSpacing.s),

            Icon(
              SolarIconsOutline.arrowRight,
              color: context.ext.textLight,
              size: AppIconSize.ml,
            ),
          ],
        ),
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

// -----
// Without Guide Card
// -----
class _WithoutGuideCard extends StatelessWidget {
  final VoidCallback? onTap;
  const _WithoutGuideCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Continue without guide',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.ml, vertical: AppSpacing.ml),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.ml),
            border: Border.all(color: context.colors.outline),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: context.colors.outline.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  SolarIconsOutline.userMinus,
                  size: AppIconSize.l,
                  color: context.colors.onSurfaceVariant,
                  semanticLabel: 'No guide',
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Text(
                  tr("continue_without_guide"),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: context.colors.onSurface,
                  ),
                ),
              ),
              Icon(
                SolarIconsOutline.arrowRight,
                size: AppIconSize.m,
                color: context.ext.textLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----
// No Guide Found
// -----
class _NoGuideFoundCard extends StatelessWidget {
  const _NoGuideFoundCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.ml),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.ml),
        border: Border.all(color: context.colors.outline),
      ),
      child: Row(
        children: [
          Icon(SolarIconsOutline.infoCircle,
              size: AppIconSize.ml, color: context.colors.onSurfaceVariant, semanticLabel: 'Information'),
          const SizedBox(width: AppSpacing.ms),
          Expanded(
            child: Text(
              tr("no_guide_available_message"),
              style: AppTextStyles.bodySmall.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
