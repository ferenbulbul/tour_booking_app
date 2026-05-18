import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tour_booking/core/theme/app_bar_styles.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/accordion_section.dart';
import 'package:tour_booking/core/widgets/bottom_action_bar.dart';
import 'package:tour_booking/core/widgets/buttons/simple_icon_button.dart';
import 'package:tour_booking/core/widgets/picker_sheet.dart';
import 'package:tour_booking/features/tour/booking/screen/full_screen_map.dart';
import 'package:tour_booking/features/tour/booking/tour_detail_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_booking_selection_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_vehicle_guide_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/widget/date_picker_sheet.dart';
import 'package:tour_booking/features/tour/booking/widget/departure_form_section.dart';
import 'package:tour_booking/features/tour/booking/widget/highlights_section.dart';
import 'package:tour_booking/features/tour/booking/widget/important_info_section.dart';
import 'package:tour_booking/features/tour/booking/widget/inclusions_section.dart';
import 'package:tour_booking/features/tour/booking/widget/route_timeline_section.dart';
import 'package:tour_booking/features/tour/booking/widget/general_info_banner.dart';
import 'package:tour_booking/features/tour/booking/widget/tour_detail_header_hero.dart';
import 'package:tour_booking/features/tour/booking/widget/tour_detail_skeleton.dart';
import 'package:tour_booking/core/widgets/time_picker_sheet.dart';
import 'package:tour_booking/features/tour/booking/screen/full_screen_gallery_screen.dart';
import 'package:tour_booking/features/favorite/favorite_viewmodel.dart';
import 'package:tour_booking/models/place_section/place_section.dart';

class TourSearchDetailScreen extends StatefulWidget {
  final String tourPointId;
  final String? initialImage;
  final String? heroTag;

  const TourSearchDetailScreen({
    super.key,
    required this.tourPointId,
    this.initialImage,
    this.heroTag,
  });

  @override
  State<TourSearchDetailScreen> createState() => _TourSearchDetailScreenState();
}

class _TourSearchDetailScreenState extends State<TourSearchDetailScreen>
    with AutomaticKeepAliveClientMixin {
  late List<String> times;
  late String heroImage;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _departureKey = GlobalKey();
  final _departureFormKey = GlobalKey<DepartureFormSectionState>();
  bool _showErrors = false;

  // Memoized gallery images
  List<String> _cachedGalleryImages = [];
  String? _cachedDetailId;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    heroImage = widget.initialImage ?? "";
    times = _generateTimes();

    // ⚡ Frame çizildikten sonra çalışır
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final detailVm = context.read<TourDetailViewModel>();
      final selectionVm = context.read<TourBookingSelectionViewModel>();
      final vehicleGuideVm = context.read<TourVehicleGuideViewModel>();

      // Silent resets — no rebuild triggered (detail==null already shows skeleton)
      detailVm.resetSilent();
      selectionVm.resetSilent();
      vehicleGuideVm.resetSilent();

      // Fetch triggers single notifyListeners at the end
      await detailVm.fetchTourPointDetail(widget.tourPointId);

      // autoSelectPlace runs in background — doesn't block UI
      final cityName = detailVm.selectedCityName;
      final districtName = detailVm.selectedDistrictName;
      if (cityName != null && districtName != null) {
        selectionVm.autoSelectPlace(cityName, districtName);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final favVm = context.watch<FavoriteViewModel>();
    final detailVm = context.watch<TourDetailViewModel>();
    final rawDetail = detailVm.detail;

    final detail = (rawDetail != null && rawDetail.id == widget.tourPointId)
        ? rawDetail
        : null;

    // HERO / GALLERY — memoized to avoid list recreation on every build
    if (_cachedDetailId != detail?.id) {
      _cachedDetailId = detail?.id;
      final images = <String>[];
      if (heroImage.isNotEmpty) {
        images.add(heroImage);
      }
      if (detail != null) {
        if (detail.mainImage.isNotEmpty &&
            detail.mainImage != heroImage &&
            !images.contains(detail.mainImage)) {
          images.add(detail.mainImage);
        }
        for (final img in detail.otherImages) {
          if (img.isNotEmpty && !images.contains(img)) {
            images.add(img);
          }
        }
      }
      _cachedGalleryImages = images;
    }
    final galleryImages = _cachedGalleryImages;

    final media = MediaQuery.of(context);
    final expandedHeight = media.size.height * 0.45;
    final topPadding = media.padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            expandedHeight: expandedHeight,
            backgroundColor: Colors.white,

            title: null,

            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final currentHeight = constraints.biggest.height;
                final minHeight = kToolbarHeight + topPadding;
                final maxHeight = expandedHeight;

                double t = 1.0;
                if (maxHeight > minHeight) {
                  t = ((currentHeight - minHeight) / (maxHeight - minHeight))
                      .clamp(0.0, 1.0);
                }

                final collapseT = 1 - t;

                final double appBarBgOpacity =
                    lerpDouble(0.0, 1.0, collapseT.clamp(0.0, 1.0)) ?? 0.0;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Hero image
                    GestureDetector(
                      onTap: () => _openGallery(galleryImages, 0),
                      child: TourDetailHeaderHero(
                        tourPointId: widget.tourPointId,
                        images: galleryImages,
                        heroTag: widget.heroTag,
                      ),
                    ),

                    // Top band background
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: topPadding + kToolbarHeight,
                      child: IgnorePointer(
                        child: Container(
                          color: AppColors.background.withValues(
                            alpha: appBarBgOpacity,
                          ),
                        ),
                      ),
                    ),

                    // Icon bar + collapsed title
                    Positioned(
                      top: topPadding,
                      left: 0,
                      right: 0,
                      height: kToolbarHeight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SimpleIconButton(
                              icon: Icons.arrow_back_ios_new,
                              onTap: () => Navigator.pop(context),
                              fillColor: const Color.fromARGB(
                                255, 249, 250, 251,
                              ),
                              iconColor: Colors.black,
                            ),

                            // Collapsed title (fade in)
                            if (detail != null && collapseT >= 0.75)
                              Expanded(
                                child: Opacity(
                                  opacity: ((collapseT - 0.75) / 0.25)
                                      .clamp(0.0, 1.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      detail.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          AppBarStyles.title(context).copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            else
                              const Spacer(),

                            SimpleIconButton(
                              icon: SolarIconsOutline.export,
                              onTap: _onShareTap,
                              fillColor: const Color.fromARGB(
                                255, 249, 250, 251,
                              ),
                              iconColor: Colors.black,
                            ),

                            const SizedBox(width: 8),

                            SimpleIconButton(
                              icon: detailVm.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              onTap: () {
                                if (detail == null) return;
                                favVm.toggleFavorite(detail.id);
                                detailVm.toggleFavorite();
                              },
                              iconColor: detailVm.isFavorite
                                  ? Colors.red
                                  : Colors.black,
                              fillColor: const Color.fromARGB(
                                255, 249, 250, 251,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // ---- İÇERİK ----
          if (detail == null)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.l),
                child: TourDetailSkeleton(),
              ),
            )
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.l,
                ).copyWith(top: 16, bottom: 24),
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
                              size: 16,
                              color: AppColors.warning,
                            );
                          }),
                          const SizedBox(width: 4),
                          Text(
                            "${(detail.avgRating ?? 0.0).toStringAsFixed(1)} (${detail.ratingCount ?? 0})",
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textSecondary,
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
                            color: AppColors.textSecondary,
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
                          color: AppColors.textSecondary,
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
                      key: _departureKey,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(16),
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
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.l,
                            ),
                            child: Text(
                              tr("departure_details_subtitle"),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
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
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: AppSpacing.s),
                                  Expanded(
                                    child: Text(
                                      tr("no_departure_added"),
                                      style:
                                          AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
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
                                  key: _departureFormKey,
                                  showErrors: _showErrors,
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
                                  onSelectCity: _selectCity,
                                  onSelectDistrict: _selectDistrict,
                                  onSelectPlace: _selectPlace,
                                  onSelectDate: _selectDate,
                                  onSelectTime: _selectTime,
                                  onSubmit: _submit,
                                  onOpenMap: _openFullMap,
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
            ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        buttonText: tr("view_vehicles"),
        onPressed: _submit,
      ),
    );
  }

  // -------------------------- NAVIGATION --------------------------

  void _selectCity() async {
    final detailVm = context.read<TourDetailViewModel>();
    final selectionVm = context.read<TourBookingSelectionViewModel>();
    if (detailVm.detail == null) return;
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (_) => PickerSheet(
        title: tr("select_city"),
        icon: SolarIconsOutline.buildings_3,
        options: detailVm.detail!.cities
            .map((e) => PickerOption(e.id, e.name))
            .toList(),
        initialId: detailVm.selectedCityId,
      ),
    );

    if (selected != null) {
      detailVm.setSelectedCity(selected);
      selectionVm.resetPlaceSelection();
      final cityName = detailVm.selectedCityName;
      final districtName = detailVm.selectedDistrictName;
      if (cityName != null && districtName != null) {
        selectionVm.autoSelectPlace(cityName, districtName, triggeredByUser: true);
      }
    }
  }

  void _selectDistrict() async {
    final detailVm = context.read<TourDetailViewModel>();
    final selectionVm = context.read<TourBookingSelectionViewModel>();
    if (detailVm.detail == null) return;
    final districts = detailVm.detail!.districts
        .where((d) => d.cityId == detailVm.selectedCityId)
        .toList();

    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (_) => PickerSheet(
        title: tr("select_district"),
        icon: SolarIconsOutline.mapPoint,
        options: districts.map((e) => PickerOption(e.id, e.name)).toList(),
        initialId: detailVm.selectedDistrictId,
      ),
    );

    if (selected != null) {
      detailVm.setSelectedDistrict(selected);
      selectionVm.resetPlaceSelection();
      final cityName = detailVm.selectedCityName;
      final districtName = detailVm.selectedDistrictName;
      if (cityName != null && districtName != null) {
        selectionVm.autoSelectPlace(cityName, districtName, triggeredByUser: true);
      }
    }
  }

  void _openFullMap() async {
    final detailVm = context.read<TourDetailViewModel>();
    final selectionVm = context.read<TourBookingSelectionViewModel>();
    final lat = selectionVm.selectedPlaceLat;
    final lng = selectionVm.selectedPlaceLng;
    final cityName = detailVm.selectedCityName;
    final districtName = detailVm.selectedDistrictName;
    if (lat == null || lng == null || cityName == null || districtName == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullMapView(
          lat: lat,
          lng: lng,
          city: cityName,
          district: districtName,
        ),
      ),
    );

    if (result is PlaceSelection) {
      selectionVm.setSelectedPlace(result);
    }
  }

  void _selectPlace() async {
    final detailVm = context.read<TourDetailViewModel>();
    final selectionVm = context.read<TourBookingSelectionViewModel>();
    final city = detailVm.selectedCityName;
    final districts = detailVm.selectedDistrictName;

    // 1. ÖNEMLİ: Yeni seçim yapmadan önce harita zaten açık mıydı kontrol et.
    // Eğer lat/lng null değilse, harita zaten ekranda demektir.
    bool isMapAlreadyVisible = selectionVm.selectedPlaceLat != null;

    final result = await context.pushNamed<PlaceSelection>(
      "placePicker",
      extra: {'city': city, 'district': districts},
    );

    if (result != null) {
      selectionVm.setSelectedPlace(result);

      // 2. Eğer harita ZATEN AÇIKSA scroll yapma.
      // Sadece harita ilk defa görünür hale geliyorsa scroll yap.
      if (!isMapAlreadyVisible) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.offset + 300, // Harita alanı kadar kaydır
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
      }
    }
  }

  void _onShareTap() {
    final url = "https://tourrentai.com/tour/${widget.tourPointId}";

    final text = tr("share_tour_text", namedArgs: {"url": url});

    SharePlus.instance.share(
      ShareParams(text: text, subject: tr("share_tour_subject")),
    );
  }

  void _selectDate() async {
    final selectionVm = context.read<TourBookingSelectionViewModel>();
    final now = DateTime.now();
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DatePickerSheet(
        initialDate: selectionVm.selectedDate ?? now,
        firstDate: now,
        lastDate: now.add(const Duration(days: 365)),
      ),
    );
    if (picked != null) selectionVm.setSelectedDate(picked);
  }

  void _selectTime() {
    final selectionVm = context.read<TourBookingSelectionViewModel>();
    showModalBottomSheet(
      context: context,
      builder: (_) => TimePickerSheet(
        times: times,
        initial: selectionVm.selectedTime ?? times.first,
        onSelected: (v) => selectionVm.setSelectedTime(v),
      ),
    );
  }

  void _scrollToDeparture() {
    final ctx = _departureKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        alignment: 0.1,
      );
    }
  }

  void _submit() async {
    final detailVm = context.read<TourDetailViewModel>();
    final selectionVm = context.read<TourBookingSelectionViewModel>();
    final vehicleGuideVm = context.read<TourVehicleGuideViewModel>();

    if (detailVm.selectedCityId == null ||
        detailVm.selectedDistrictId == null ||
        selectionVm.selectedDate == null ||
        selectionVm.selectedPlaceDesc == null) {
      setState(() => _showErrors = true);
      _departureFormKey.currentState?.shakeEmptyFields();
      UIHelper.showWarning(context, tr("fill_all_fields_warning"));
      _scrollToDeparture();
      return;
    }

    await vehicleGuideVm.fetchVehicles(
      cityId: detailVm.selectedCityId!,
      districtId: detailVm.selectedDistrictId!,
      tourPointId: widget.tourPointId,
      date: selectionVm.selectedDate!,
    );

    if (vehicleGuideVm.vehicles.isEmpty) {
      UIHelper.showWarning(context, tr("no_available_vehicle_date"));
      return;
    }

    context.pushNamed(
      "vehicleList",
      queryParameters: {
        "cityId": detailVm.selectedCityId!,
        "districtId": detailVm.selectedDistrictId!,
        "tourPointId": widget.tourPointId,
        "date": selectionVm.selectedDate!.toIso8601String(),
      },
    );
  }

  // -------------------------- UTILS --------------------------

  void _openGallery(List<String> images, [int start = 0]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PremiumFullScreenGallery(images: images, initialIndex: start),
      ),
    );
  }

  List<String> _generateTimes() {
    final out = <String>[];
    for (int h = 6; h <= 12; h++) {
      out.add("${h.toString().padLeft(2, '0')}:00");
      if (h != 12) out.add("${h.toString().padLeft(2, '0')}:30");
    }
    return out;
  }
}
