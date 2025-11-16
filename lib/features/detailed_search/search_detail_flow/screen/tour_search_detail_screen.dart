import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/detailed_search/search_detail_flow/screen/city_badget.dart';
import 'package:tour_booking/features/detailed_search/search_detail_flow/screen/difficulty_badge.dart';
import 'package:tour_booking/features/detailed_search/search_detail_flow/screen/tour_type_badge.dart';
import 'package:tour_booking/features/detailed_search/search_detail_flow/tour_search_detail_viewmodel.dart';
import 'package:tour_booking/features/detailed_search/search_detail_flow/widget/full_screen_gallery.dart';
import 'package:tour_booking/features/detailed_search/search_detail_flow/widget/tour_detail_skeleton.dart';
import 'package:tour_booking/models/place_section/place_section.dart';

class TourSearchDetailScreen extends StatefulWidget {
  final String tourPointId;
  final String? initialImage; // 🔹 Liste ekranından hero için gelebilir

  const TourSearchDetailScreen({
    super.key,
    required this.tourPointId,
    this.initialImage,
  });

  @override
  State<TourSearchDetailScreen> createState() => _TourSearchDetailScreenState();
}

class _TourSearchDetailScreenState extends State<TourSearchDetailScreen> {
  late List<String> times;
  String? selectedTime;

  @override
  void initState() {
    super.initState();

    // 🔹 API çağrısı – Hero animasyonuna karışmaması için microtask
    Future.microtask(() {
      final vm = Provider.of<TourSearchDetailViewModel>(context, listen: false);
      vm.fetchTourPointDetail(widget.tourPointId);
    });

    times = _generateTimes();
    selectedTime = times.first;
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TourSearchDetailViewModel>();
    final detail = vm.detail;

    // 🔹 Hero için kullanılacak image:
    // 1) initialImage (listeden gelen)
    // 2) yoksa detail.mainImage
    String heroImage = '';

    if (widget.initialImage != null && widget.initialImage!.isNotEmpty) {
      heroImage = widget.initialImage!;
    } else if (detail?.mainImage.isNotEmpty == true) {
      heroImage = detail!.mainImage;
    }

    // 🔹 Galeri için resimler – sadece detail doluyken
    final List<String> galleryImages = detail == null
        ? (heroImage.isNotEmpty ? [heroImage] : <String>[])
        : <String>[detail.mainImage, ...detail.otherImages];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // 🔵 Asıl UI (her zaman çiziliyor — skeleton yok)
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // -------------------------------------------------------
                  // 🟦 1) HEADER HERO (Hero animasyonu burada)
                  // -------------------------------------------------------
                  _HeaderHero(
                    title: detail?.title ?? '',
                    city: detail?.cityName ?? '',
                    district: detail?.districtName ?? '',
                    mainImage: heroImage,
                    tourPointId: widget.tourPointId,
                    isFavorite: vm.isFavorite,
                    onBack: () => Navigator.of(context).pop(),
                    onFav: detail == null
                        ? () {}
                        : () => vm.toggleFavorite(detail.isFavorites),
                    onOpenGallery: () {
                      if (galleryImages.isNotEmpty) {
                        _openGallery(context, galleryImages, 0);
                      }
                    },
                  ),

                  // -------------------------------------------------------
                  // Detail yoksa sadece header göster – alt kısım boş
                  // -------------------------------------------------------
                  if (detail == null) ...[
                    const TourDetailSkeleton(),
                    const SizedBox(height: 24),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Loading details...",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ),
                  ] else ...[
                    // ---------------------------------------------------
                    // 🟨 2) THUMBNAIL STRIP (Sadece otherImages)
                    // ---------------------------------------------------
                    if (detail.otherImages.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 8),
                        child: _ThumbStrip(
                          images: detail.otherImages,
                          onTap: (index) {
                            _openGallery(context, galleryImages, index + 1);
                          },
                        ),
                      ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          CityDistrictBadge(
                            city: detail.cityName,
                            district: detail.districtName,
                          ),
                          TourTypeBadge(type: detail.tourTypeName),
                          DifficultyBadge(
                            difficulty: detail.tourDifficultyName,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // ---------------------------------------------------
                    // 🟩 3) BADGES + DESCRIPTION
                    // ---------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _DescriptionSection(detail: detail),
                    ),

                    const SizedBox(height: 28),

                    // ---------------------------------------------------
                    // 🟦 4) FORM (CITY / DISTRICT / PLACE / DATE / TIME)
                    // ---------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Your Departure Details",
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // CITY
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildCityPicker(vm),
                    ),
                    const SizedBox(height: 12),

                    // DISTRICT
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildDistrictPicker(vm),
                    ),
                    const SizedBox(height: 12),

                    // PLACE
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ModernField(
                        label: "📍 Add Exact Location",
                        value: vm.selectedPlaceDesc,
                        icon: Icons.map_outlined,
                        onTap: () async {
                          final selection = await context
                              .pushNamed<PlaceSelection>("placePicker");
                          if (selection != null) vm.setSelectedPlace(selection);
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // DATE + TIME
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(child: _buildDatePicker(vm)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildTimePicker(vm)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ---------------------------------------------------
                    // 🟥 BUTTON — FETCH VEHICLES
                    // ---------------------------------------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
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
                        },
                        child: const Text("Araçları Gör"),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  // 🔵 GALLERY PUSH
  // ---------------------------------------------------------------
  void _openGallery(BuildContext ctx, List<String> images, int index) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) =>
            PremiumFullScreenGallery(images: images, initialIndex: index),
      ),
    );
  }

  // ---------------------------------------------------------------
  // 🔵 TIME UTILS
  // ---------------------------------------------------------------
  List<String> _generateTimes() {
    final List<String> out = [];
    for (int h = 6; h <= 12; h++) {
      out.add("${h.toString().padLeft(2, '0')}:00");
      if (h != 12) out.add("${h.toString().padLeft(2, '0')}:30");
    }
    return out;
  }

  // ---------------------------------------------------------------
  // 🔵 DATE PICKER
  // ---------------------------------------------------------------
  Widget _buildDatePicker(TourSearchDetailViewModel vm) {
    return ModernField(
      label: "Select Date",
      value: vm.selectedDate != null
          ? "${vm.selectedDate!.day}.${vm.selectedDate!.month}.${vm.selectedDate!.year}"
          : null,
      icon: Icons.calendar_month_rounded,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: vm.selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF3E7BFA),
                  onPrimary: Colors.white,
                  onSurface: Colors.black87,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFF3E7BFA),
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        if (picked != null) vm.setSelectedDate(picked);
      },
    );
  }

  // ---------------------------------------------------------------
  // 🔵 TIME PICKER
  // ---------------------------------------------------------------
  Widget _buildTimePicker(TourSearchDetailViewModel vm) {
    return ModernField(
      label: "Select Time",
      value: vm.selectedTime,
      icon: Icons.access_time,
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => _TimePickerSheet(
            times: times,
            initial: selectedTime ?? times.first,
            onSelected: (v) {
              setState(() => selectedTime = v);
              vm.setSelectedTime(v);
            },
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------
  // 🔵 CITY PICKER
  // ---------------------------------------------------------------
  Widget _buildCityPicker(TourSearchDetailViewModel vm) {
    final cities = vm.detail?.cities ?? [];

    return ModernField(
      label: "Departure City",
      value: vm.selectedCityId != null
          ? cities.firstWhere((c) => c.id == vm.selectedCityId).name
          : null,
      icon: Icons.location_city,
      onTap: () async {
        final selected = await _openOptionPicker(
          title: "Select City",
          options: cities.map((e) => _Option(id: e.id, name: e.name)).toList(),
          initialId: vm.selectedCityId,
        );
        if (selected != null) vm.setSelectedCity(selected);
      },
    );
  }

  // ---------------------------------------------------------------
  // 🔵 DISTRICT PICKER
  // ---------------------------------------------------------------
  Widget _buildDistrictPicker(TourSearchDetailViewModel vm) {
    final districts = (vm.detail?.districts ?? [])
        .where((d) => d.cityId == vm.selectedCityId)
        .toList();

    return ModernField(
      label: "Departure District",
      value: vm.selectedDistrictId != null
          ? districts.firstWhere((d) => d.id == vm.selectedDistrictId).name
          : null,
      icon: Icons.location_on_outlined,
      onTap: () async {
        final selected = await _openOptionPicker(
          title: "Select District",
          options: districts
              .map((e) => _Option(id: e.id, name: e.name))
              .toList(),
          initialId: vm.selectedDistrictId,
        );
        if (selected != null) vm.setSelectedDistrict(selected);
      },
    );
  }

  // ---------------------------------------------------------------
  // 🔵 OPTION PICKER MODAL
  // ---------------------------------------------------------------
  Future<String?> _openOptionPicker({
    required String title,
    required List<_Option> options,
    required String? initialId,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _OptionPickerSheet(
        title: title,
        options: options,
        initialId: initialId,
      ),
    );
  }
}

//
// ----------------------------------------------------------------------
// 🔷 HEADER HERO (PREMIUM + HERO)
// ----------------------------------------------------------------------
class _HeaderHero extends StatelessWidget {
  final String title;
  final String mainImage;
  final String city;
  final String district;
  final String tourPointId;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFav;
  final VoidCallback onOpenGallery;

  const _HeaderHero({
    super.key,
    required this.title,
    required this.mainImage,
    required this.city,
    required this.district,
    required this.tourPointId,
    required this.isFavorite,
    required this.onBack,
    required this.onFav,
    required this.onOpenGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onOpenGallery,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Container(
              height: 330,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.15),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Hero(
                    tag: "tourImage_$tourPointId",
                    flightShuttleBuilder:
                        (
                          BuildContext flightContext,
                          Animation<double> animation,
                          HeroFlightDirection flightDirection,
                          BuildContext fromHeroContext,
                          BuildContext toHeroContext,
                        ) {
                          // Uçarken: tam yuvarlak köşeli
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image(
                              image: CachedNetworkImageProvider(
                                mainImage,
                                cacheKey: "featured_$tourPointId",
                              ),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                    child: Image(
                      image: CachedNetworkImageProvider(
                        mainImage,
                        cacheKey: "featured_$tourPointId",
                      ),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded || frame != null)
                              return child;
                            return Container(color: Colors.grey.shade300);
                          },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors.grey.shade300);
                      },
                    ),
                  ),

                  // GRADIENT
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(.65),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),

                  // TITLE
                  Positioned(
                    left: 20,
                    bottom: 28,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title.isNotEmpty)
                          Text(
                            title,
                            style: AppTextStyles.displaySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 28,
                            ),
                          ),
                        const SizedBox(height: 4),
                        if (city.isNotEmpty || district.isNotEmpty)
                          Text(
                            city.isNotEmpty
                                ? "$city, $district"
                                : district.isNotEmpty
                                ? district
                                : "",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // BACK BUTTON
        Positioned(
          left: 14,
          top: MediaQuery.of(context).padding.top + 10,
          child: _blurButton(Icons.arrow_back_ios_new_rounded, onBack),
        ),

        // FAVORITE BUTTON
        Positioned(
          right: 14,
          top: MediaQuery.of(context).padding.top + 10,
          child: _blurButton(
            Icons.favorite,
            onFav,
            color: isFavorite ? Colors.red : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _blurButton(
    IconData icon,
    VoidCallback onTap, {
    Color color = Colors.white,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: Colors.black.withOpacity(.30),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(icon, size: 22, color: color),
            ),
          ),
        ),
      ),
    );
  }
}

//
// ----------------------------------------------------------------------
// 🔶 THUMB STRIP (SADECE OTHER IMAGES)
// ----------------------------------------------------------------------
class _ThumbStrip extends StatelessWidget {
  final List<String> images;
  final Function(int index) onTap;

  const _ThumbStrip({super.key, required this.images, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: images.length,
        itemBuilder: (_, i) {
          return GestureDetector(
            onTap: () => onTap(i),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: images[i],
                width: 120,
                height: 82,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

//
// ----------------------------------------------------------------------
// 🔷 DESCRIPTION SECTION (BADGES + DESC)
// ----------------------------------------------------------------------
class _DescriptionSection extends StatelessWidget {
  final dynamic detail;

  const _DescriptionSection({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        detail.description,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          height: 1.45,
        ),
      ),
    );
  }
}

//
// ----------------------------------------------------------------------
// 🔵 TIME PICKER SHEET
// ----------------------------------------------------------------------
class _TimePickerSheet extends StatelessWidget {
  final List<String> times;
  final String initial;
  final Function(String) onSelected;

  const _TimePickerSheet({
    super.key,
    required this.times,
    required this.initial,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final controller = FixedExtentScrollController(
      initialItem: times.indexOf(initial),
    );

    return SizedBox(
      height: 320,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "Select Time",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: CupertinoPicker(
              scrollController: controller,
              backgroundColor: Colors.white,
              itemExtent: 44,
              onSelectedItemChanged: (i) => onSelected(times[i]),
              children: times
                  .map(
                    (e) => Center(
                      child: Text(e, style: const TextStyle(fontSize: 18)),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

//
// ----------------------------------------------------------------------
// 🔵 OPTION PICKER SHEET
// ----------------------------------------------------------------------
class _OptionPickerSheet extends StatefulWidget {
  final String title;
  final List<_Option> options;
  final String? initialId;

  const _OptionPickerSheet({
    super.key,
    required this.title,
    required this.options,
    required this.initialId,
  });

  @override
  State<_OptionPickerSheet> createState() => _OptionPickerSheetState();
}

class _OptionPickerSheetState extends State<_OptionPickerSheet> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final filtered = widget.options
        .where((o) => o.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          left: 16,
          right: 16,
          bottom: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // DRAG BAR
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            TextField(
              autofocus: true,
              onChanged: (v) => setState(() => query = v),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Ara...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 380),
              child: ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final item = filtered[i];
                  final selected = item.id == widget.initialId;

                  return ListTile(
                    title: Text(item.name),
                    trailing: selected
                        ? const Icon(Icons.check, size: 18)
                        : null,
                    onTap: () => Navigator.pop(context, item.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ----------------------------------------------------------------------
// 🔵 COMMON
// ----------------------------------------------------------------------
class _Option {
  final String id;
  final String name;
  const _Option({required this.id, required this.name});
}

class ModernField extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;

  const ModernField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = value == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black54),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isEmpty ? label : value!,
                style: TextStyle(
                  fontSize: 15,
                  color: isEmpty ? Colors.black45 : Colors.black87,
                  fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
