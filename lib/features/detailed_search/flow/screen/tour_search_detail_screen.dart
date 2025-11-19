import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/models/option_item.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/widgets/badgets/app_badge.dart';
import 'package:tour_booking/core/widgets/badgets/difficulty_badge.dart';
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
    print("favorite main image ${widget.initialImage}");
    ;
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

    // Eğer VM’deki detail başka tura aitse (önceki sayfadan kalmışsa) yok say
    final detail = (rawDetail != null && rawDetail.id == widget.tourPointId)
        ? rawDetail
        : null;

    // ---------- HERO / GALLERY İÇİN GÖRSELLER ----------
    final List<String> galleryImages = [];

    // 0. index HER ZAMAN karttan gelen image
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        color: AppColors.background,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 🧨 HERO HER ZAMAN VAR (detail null olsa bile)
              TourDetailHeaderHero(
                title: detail?.title ?? '',
                city: detail?.cityName ?? '',
                district: detail?.districtName ?? '',
                tourPointId: widget.tourPointId,
                isFavorite: vm.isFavorite,
                images: galleryImages,
                onBack: () => Navigator.pop(context),
                onFav: detail == null
                    ? () {} // detail gelmeden fav çalışmasın
                    : () => vm.toggleFavorite(detail.isFavorites),
                onOpenGallery: (index) => _openGallery(galleryImages, index),
              ),

              const SizedBox(height: 12),

              if (detail == null) ...[
                // 🔄 Detay yüklenene kadar altta skeleton göster
                const TourDetailSkeleton(),
              ] else ...[
                /// BADGES
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  child: Wrap(
                    spacing: AppSpacing.s,
                    children: [
                      AppBadge("${detail.cityName}, ${detail.districtName}"),
                      AppBadge(detail.tourTypeName),
                      DifficultyBadge(detail.tourDifficultyName),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  child: DescriptionSection(detail: detail),
                ),

                const SizedBox(height: 32),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  child: SectionTitle(
                    title: "Your Departure Details",
                    subtitle: "Choose the details for your pickup",
                  ),
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
                ),

                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
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
