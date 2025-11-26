import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/models/option_item.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/badgets/app_badge.dart';
import 'package:tour_booking/core/widgets/badgets/difficulty_badge.dart';
import 'package:tour_booking/core/widgets/buttons/simple_icon_button.dart';
import 'package:tour_booking/core/widgets/section_title.dart';
import 'package:tour_booking/features/detailed_search/flow/tour_search_detail_viewmodel.dart';
import 'package:tour_booking/features/detailed_search/flow/widget/departure_form_section.dart';
import 'package:tour_booking/features/detailed_search/flow/widget/description_section.dart';
import 'package:tour_booking/features/detailed_search/flow/widget/tour_detail_header_hero.dart';
import 'package:tour_booking/features/detailed_search/flow/widget/tour_detail_skeleton.dart';
import 'package:tour_booking/features/detailed_search/flow/widget/option_picker_sheet.dart';
import 'package:tour_booking/features/detailed_search/flow/widget/time_picker_sheet.dart';

import 'package:tour_booking/features/detailed_search/flow/screen/full_screen_gallery_screen.dart';
import 'package:tour_booking/models/place_section/place_section.dart';

class TourSearchDetailScreen extends StatefulWidget {
  final String tourPointId;
  final String initialImage;

  const TourSearchDetailScreen({
    super.key,
    required this.tourPointId,
    required this.initialImage,
  });

  @override
  State<TourSearchDetailScreen> createState() => _TourSearchDetailScreenState();
}

class _TourSearchDetailScreenState extends State<TourSearchDetailScreen>
    with AutomaticKeepAliveClientMixin {
  late List<String> times;
  late String heroImage;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    heroImage = widget.initialImage;

    Future.microtask(() {
      context.read<TourSearchDetailViewModel>().fetchTourPointDetail(
        widget.tourPointId,
      );
    });

    times = _generateTimes();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final vm = context.watch<TourSearchDetailViewModel>();
    final rawDetail = vm.detail;

    final detail = (rawDetail != null && rawDetail.id == widget.tourPointId)
        ? rawDetail
        : null;

    // HERO / GALLERY
    final List<String> galleryImages = [];
    if (heroImage.isNotEmpty) {
      galleryImages.add(heroImage);
    }
    if (detail != null) {
      if (detail.mainImage.isNotEmpty &&
          detail.mainImage != heroImage &&
          !galleryImages.contains(detail.mainImage)) {
        galleryImages.add(detail.mainImage);
      }
      for (final img in detail.otherImages) {
        if (img.isNotEmpty && !galleryImages.contains(img)) {
          galleryImages.add(img);
        }
      }
    }

    final media = MediaQuery.of(context);
    final expandedHeight = media.size.height * 0.55;
    final topPadding = media.padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            expandedHeight: expandedHeight,
            backgroundColor: Colors.transparent,

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
                final bool onHero =
                    collapseT < 0.85; // 0.85’ten sonra “appbar modu” gibi düşün
                // Title hareketi (senin değerlerini aynen bırakıyorum)
                final double moveT = ((collapseT - 0.45) / 0.65).clamp(
                  0.0,
                  1.0,
                );

                const Alignment startAlign = Alignment(-0.9, 0.85);
                const Alignment endAlign = Alignment(0.0, 0.55);

                final Alignment titleAlignment = Alignment.lerp(
                  startAlign,
                  endAlign,
                  moveT,
                )!;

                final double fontSize = lerpDouble(26, 18, moveT) ?? 22;
                final double scale = lerpDouble(1.0, 0.95, moveT) ?? 1.0;

                // Appbar band opacity
                final double appBarBgOpacity =
                    lerpDouble(0.0, 1.0, collapseT.clamp(0.0, 1.0)) ?? 0.0;

                // 🔥 İkonlar için opacity: en üstte 0, collapse oldukça 1
                final double iconOpacity =
                    lerpDouble(0.0, 1.0, collapseT.clamp(0.90, 1.0)) ?? 0.0;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // 🖼 ARKA PLAN HERO
                    GestureDetector(
                      onTap: () => _openGallery(galleryImages, 0),
                      child: TourDetailHeaderHero(
                        tourPointId: widget.tourPointId,
                        images: galleryImages,
                      ),
                    ),

                    // 🔳 ÜST BANT
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: topPadding + kToolbarHeight,
                      child: Container(
                        color: AppColors.background.withOpacity(
                          appBarBgOpacity,
                        ),
                      ),
                    ),

                    Positioned(
                      left: 10,
                      top: topPadding + 4,
                      child: Opacity(
                        opacity: iconOpacity,
                        child: SimpleIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.pop(context),
                          fillColor: const Color.fromARGB(
                            255,
                            249,
                            250,
                            251,
                          ), // içi beyaz
                          iconColor: Colors.black, // ikon siyah
                          borderColor: Color.fromARGB(
                            255,
                            249,
                            250,
                            251,
                          ), // hafif beyaz çember
                          borderWidth: 1.2,
                        ),
                      ),
                    ),

                    Positioned(
                      right: 10,
                      top: topPadding + 4,
                      child: Opacity(
                        opacity: iconOpacity,
                        child: SimpleIconButton(
                          icon: vm.isFavorite
                              ? Icons
                                    .favorite // dolu kalp
                              : Icons.favorite_border, // boş kalp
                          onTap: () => vm.toggleFavorite(detail!.isFavorites),

                          // 🔥 SİHİR BURADA
                          iconColor: vm.isFavorite ? Colors.red : Colors.black,

                          fillColor: const Color.fromARGB(255, 249, 250, 251),
                          borderColor: const Color.fromARGB(255, 249, 250, 251),
                          borderWidth: 1.0,
                          size: 22,
                          padding: 10,
                        ),
                      ),
                    ),

                    // ✨ HAREKET EDEN TITLE
                    if (detail != null && detail.title.isNotEmpty)
                      Align(
                        alignment: titleAlignment,
                        child: Transform.scale(
                          scale: scale,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: lerpDouble(20, 72, moveT) ?? 20,
                              right: lerpDouble(40, 72, moveT) ?? 40,
                            ),
                            child: Text(
                              detail.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: moveT < 0.5
                                  ? TextAlign.left
                                  : TextAlign.center,
                              style: AppTextStyles.displaySmall.copyWith(
                                color: onHero
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: fontSize,
                                shadows: onHero
                                    ? [
                                        Shadow(
                                          offset: const Offset(0, 2),
                                          blurRadius: 8,
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ]
                                    : [],
                              ),
                            ),
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
                    Wrap(
                      spacing: AppSpacing.s,
                      children: [
                        AppBadge("${detail.cityName}, ${detail.districtName}"),
                        AppBadge(detail.tourTypeName),
                        DifficultyBadge(detail.tourDifficultyName),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DescriptionSection(detail: detail),
                    const SizedBox(height: 16),
                    const SectionTitle(
                      title: "Your Departure Details",
                      subtitle: "Choose the details for your pickup",
                    ),
                    const SizedBox(height: 16),
                    DepartureFormSection(
                      cityName: vm.selectedCityId != null
                          ? detail.cities
                                .firstWhere(
                                  (c) => c.id == vm.selectedCityId,
                                  orElse: () => detail.cities.first,
                                )
                                .name
                          : null,
                      districtName: vm.selectedDistrictId != null
                          ? detail.districts
                                .firstWhere(
                                  (d) => d.id == vm.selectedDistrictId,
                                  orElse: () => detail.districts.first,
                                )
                                .name
                          : null,
                      placeDescription: vm.selectedPlaceDesc,
                      dateText: vm.selectedDate != null
                          ? "${vm.selectedDate!.day}.${vm.selectedDate!.month}.${vm.selectedDate!.year}"
                          : null,
                      timeText: vm.selectedTime,
                      onSelectCity: () => _selectCity(vm),
                      onSelectDistrict: () => _selectDistrict(vm),
                      onSelectPlace: () => _selectPlace(vm),
                      onSelectDate: () => _selectDate(vm),
                      onSelectTime: () => _selectTime(vm),
                      onSubmit: () => _submit(vm),
                      placeLat: vm.selectedPlaceLat,
                      placeLng: vm.selectedPlaceLng,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // -------------------------- NAVIGATION --------------------------

  void _selectCity(TourSearchDetailViewModel vm) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => OptionPickerSheet(
        title: "Select City",
        options: vm.detail!.cities
            .map((e) => OptionItem(id: e.id, name: e.name))
            .toList(),
        initialId: vm.selectedCityId,
      ),
    );
    if (selected != null) vm.setSelectedCity(selected);
  }

  void _selectDistrict(TourSearchDetailViewModel vm) async {
    final districts = vm.detail!.districts
        .where((d) => d.cityId == vm.selectedCityId)
        .toList();

    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => OptionPickerSheet(
        title: "Select District",
        options: districts
            .map((e) => OptionItem(id: e.id, name: e.name))
            .toList(),
        initialId: vm.selectedDistrictId,
      ),
    );

    if (selected != null) vm.setSelectedDistrict(selected);
  }

  void _selectPlace(TourSearchDetailViewModel vm) async {
    final result = await context.pushNamed<PlaceSelection>("placePicker");
    if (result != null) vm.setSelectedPlace(result);
  }

  void _selectDate(TourSearchDetailViewModel vm) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: vm.selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) vm.setSelectedDate(picked);
  }

  void _selectTime(TourSearchDetailViewModel vm) {
    showModalBottomSheet(
      context: context,
      builder: (_) => TimePickerSheet(
        times: times,
        initial: vm.selectedTime ?? times.first,
        onSelected: (v) => vm.setSelectedTime(v),
      ),
    );
  }

  void _submit(TourSearchDetailViewModel vm) async {
    if (vm.selectedCityId == null ||
        vm.selectedDistrictId == null ||
        vm.selectedDate == null ||
        vm.selectedPlaceDesc == null) {
      _showSnack("Lütfen tüm alanları doldurun");
      return;
    }

    await vm.fetchVehicles();

    if (vm.vehicles.isEmpty) {
      _showSnack("Bu tarihte müsait araç bulunamadı");
      return;
    }

    context.pushNamed(
      "vehicleList",
      queryParameters: {
        "cityId": vm.selectedCityId!,
        "districtId": vm.selectedDistrictId!,
        "tourPointId": widget.tourPointId,
        "date": vm.selectedDate!.toIso8601String(),
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

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
