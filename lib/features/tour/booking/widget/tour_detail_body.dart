import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/widgets/accordion_section.dart';
import 'package:tour_booking/features/tour/booking/tour_booking_selection_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_detail_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/widget/departure_form_section.dart';
import 'package:tour_booking/features/tour/booking/widget/general_info_banner.dart';
import 'package:tour_booking/features/tour/booking/widget/highlights_section.dart';
import 'package:tour_booking/features/tour/booking/widget/important_info_section.dart';
import 'package:tour_booking/features/tour/booking/widget/inclusions_section.dart';
import 'package:tour_booking/features/tour/booking/widget/route_timeline_section.dart';
import 'package:tour_booking/features/tour/booking/widget/tour_detail_skeleton.dart';

/// The main scrollable content body of the tour detail screen.
///
/// Renders either a skeleton placeholder (when [detail] is null) or the full
/// tour detail content including title, rating, description, accordion
/// sections, and the departure-form card.
class TourDetailBody extends StatelessWidget {
  final String tourPointId;
  final bool showErrors;
  final GlobalKey departureKey;
  final GlobalKey<DepartureFormSectionState> departureFormKey;
  final VoidCallback onSelectCity;
  final VoidCallback onSelectDistrict;
  final VoidCallback onSelectPlace;
  final VoidCallback onSelectDate;
  final VoidCallback onSelectTime;
  final VoidCallback onSubmit;
  final VoidCallback onOpenMap;

  const TourDetailBody({
    super.key,
    required this.tourPointId,
    required this.showErrors,
    required this.departureKey,
    required this.departureFormKey,
    required this.onSelectCity,
    required this.onSelectDistrict,
    required this.onSelectPlace,
    required this.onSelectDate,
    required this.onSelectTime,
    required this.onSubmit,
    required this.onOpenMap,
  });

  @override
  Widget build(BuildContext context) {
    final detailVm = context.watch<TourDetailViewModel>();
    final rawDetail = detailVm.detail;

    final detail = (rawDetail != null && rawDetail.id == tourPointId)
        ? rawDetail
        : null;

    if (detail == null) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.l),
          child: TourDetailSkeleton(),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
        ).copyWith(top: AppSpacing.l, bottom: AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              detail.title,
              style: AppTextStyles.titleMedium,
            ),

            // Rating — 5 stars (always visible)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Row(
                children: [
                  ...List.generate(5, (i) {
                    final rating = detail.avgRating ?? 0.0;
                    IconData icon;
                    if (i < rating.floor()) {
                      icon = Icons.star_rounded;
                    } else if (i < rating.ceil() &&
                        rating - rating.floor() >= 0.5) {
                      icon = Icons.star_half_rounded;
                    } else {
                      icon = Icons.star_outline_rounded;
                    }
                    return Icon(
                      icon,
                      size: AppIconSize.m,
                      color: context.ext.warning,
                      semanticLabel: 'Rating star',
                    );
                  }),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    "${(detail.avgRating ?? 0.0).toStringAsFixed(1)} (${detail.ratingCount ?? 0})",
                    style: AppTextStyles.labelSmall.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Short description
            if (detail.shortDescription != null &&
                detail.shortDescription!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  detail.shortDescription!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.colors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),

            const SizedBox(height: AppSpacing.l),

            // General Info (non-collapsible accordion)
            AccordionSection(
              title: tr("general_info_title"),
              collapsible: false,
              content: GeneralInfoBanner(
                cityDistrict:
                    "${detail.cityName}, ${detail.districtName}",
                tourType: detail.tourTypeName,
                durationHours: detail.durationHours,
                durationMinutes: detail.durationMinutes,
              ),
            ),

            // Accordion Sections
            if (detail.routePoints.isNotEmpty)
              AccordionSection(
                title: tr("route_title"),
                content: RouteTimelineSection(
                  routePoints: detail.routePoints,
                  showTitle: false,
                  showCard: false,
                ),
              ),

            if (detail.highlights.isNotEmpty)
              AccordionSection(
                title: tr("highlights_title"),
                content: HighlightsSection(
                  highlights: detail.highlights,
                  showTitle: false,
                  showCard: false,
                ),
              ),

            AccordionSection(
              title: tr("full_description_title"),
              content: Text(
                detail.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  height: 1.45,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),

            if (detail.inclusions.isNotEmpty)
              AccordionSection(
                title: tr("inclusions_title"),
                content: InclusionsSection(
                  inclusions: detail.inclusions,
                  showCard: false,
                ),
              ),

            if (detail.importantInfos.isNotEmpty)
              AccordionSection(
                title: tr("important_info_title"),
                content: ImportantInfoSection(
                  items: detail.importantInfos,
                  showTitle: false,
                ),
              ),

            const SizedBox(height: AppSpacing.xxl),

            // Departure Details — bordered card
            Container(
              key: departureKey,
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.outline),
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              padding: const EdgeInsets.only(top: AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.l,
                    ),
                    child: Text(
                      tr("departure_details_title"),
                      style: AppTextStyles.titleSmall,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.l,
                    ),
                    child: Text(
                      tr("departure_details_subtitle"),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (detail.cities.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.l),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: AppIconSize.m,
                            color: context.colors.onSurfaceVariant,
                            semanticLabel: 'Information',
                          ),
                          const SizedBox(width: AppSpacing.s),
                          Expanded(
                            child: Text(
                              tr("no_departure_added"),
                              style:
                                  AppTextStyles.bodyMedium.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Consumer<TourBookingSelectionViewModel>(
                      builder: (context, selectionVm, _) {
                        return DepartureFormSection(
                          key: departureFormKey,
                          showErrors: showErrors,
                          cityName: detailVm.selectedCityId != null
                              ? detail.cities
                                    .firstWhere(
                                      (c) =>
                                          c.id ==
                                          detailVm.selectedCityId,
                                      orElse: () => detail.cities.first,
                                    )
                                    .name
                              : null,
                          districtName:
                              detailVm.selectedDistrictId != null
                                  ? detail.districts
                                        .firstWhere(
                                          (d) =>
                                              d.id ==
                                              detailVm
                                                  .selectedDistrictId,
                                          orElse: () =>
                                              detail.districts.first,
                                        )
                                        .name
                                  : null,
                          placeDescription:
                              selectionVm.selectedPlaceDesc,
                          dateText: selectionVm.selectedDate != null
                              ? "${selectionVm.selectedDate!.day}.${selectionVm.selectedDate!.month}.${selectionVm.selectedDate!.year}"
                              : null,
                          timeText: selectionVm.selectedTime,
                          onSelectCity: onSelectCity,
                          onSelectDistrict: onSelectDistrict,
                          onSelectPlace: onSelectPlace,
                          onSelectDate: onSelectDate,
                          onSelectTime: onSelectTime,
                          onSubmit: onSubmit,
                          onOpenMap: onOpenMap,
                          placeLat: selectionVm.selectedPlaceLat,
                          placeLng: selectionVm.selectedPlaceLng,
                        );
                      },
                    ),
                  const SizedBox(height: AppSpacing.s),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
