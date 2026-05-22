import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/picker_sheet.dart';
import 'package:tour_booking/features/tour/booking/screen/full_screen_map.dart';
import 'package:tour_booking/features/tour/booking/full_screen_map_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_detail_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_booking_selection_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_vehicle_guide_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/widget/date_picker_sheet.dart';
import 'package:tour_booking/features/tour/booking/widget/departure_form_section.dart';
import 'package:tour_booking/features/tour/booking/widget/tour_detail_body.dart';
import 'package:tour_booking/features/tour/booking/widget/tour_detail_bottom_bar.dart';
import 'package:tour_booking/features/tour/booking/widget/tour_detail_sliver_app_bar.dart';
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
  late String heroImage;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _departureKey = GlobalKey();
  final _departureFormKey = GlobalKey<DepartureFormSectionState>();
  bool _showErrors = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    heroImage = widget.initialImage ?? "";

    // Runs after the frame is drawn
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

    // HERO / GALLERY — memoized inside the ViewModel
    final galleryImages = detailVm.buildGalleryImages(heroImage);

    final media = MediaQuery.of(context);
    final expandedHeight = media.size.height * 0.45;
    final topPadding = media.padding.top;

    return Scaffold(
      backgroundColor: context.colors.surface,
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          TourDetailSliverAppBar(
            tourPointId: widget.tourPointId,
            detail: detail,
            detailVm: detailVm,
            favVm: favVm,
            galleryImages: galleryImages,
            heroTag: widget.heroTag,
            expandedHeight: expandedHeight,
            topPadding: topPadding,
            onBack: () => Navigator.pop(context),
            onShare: _onShareTap,
            onGalleryTap: () => _openGallery(galleryImages, 0),
          ),

          // ---- CONTENT ----
          TourDetailBody(
            tourPointId: widget.tourPointId,
            showErrors: _showErrors,
            departureKey: _departureKey,
            departureFormKey: _departureFormKey,
            onSelectCity: _selectCity,
            onSelectDistrict: _selectDistrict,
            onSelectPlace: _selectPlace,
            onSelectDate: _selectDate,
            onSelectTime: _selectTime,
            onSubmit: _submit,
            onOpenMap: _openFullMap,
          ),
        ],
      ),
      bottomNavigationBar: TourDetailBottomBar(onPressed: _submit),
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
        builder: (_) => ChangeNotifierProvider(
          create: (_) => FullScreenMapViewModel(),
          child: FullMapView(
            lat: lat,
            lng: lng,
            city: cityName,
            district: districtName,
          ),
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

    // 1. IMPORTANT: Check whether the map was already visible before making
    // a new selection. If lat/lng are non-null the map is already on screen.
    bool isMapAlreadyVisible = selectionVm.selectedPlaceLat != null;

    final result = await context.pushNamed<PlaceSelection>(
      "placePicker",
      extra: {'city': city, 'district': districts},
    );

    if (result != null) {
      selectionVm.setSelectedPlace(result);

      // 2. Do not scroll if the map is ALREADY VISIBLE.
      // Only scroll when the map becomes visible for the first time.
      if (!isMapAlreadyVisible) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.offset + 300, // Scroll by roughly the map area height
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
    final times = TourBookingSelectionViewModel.availableTimes;
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
}
