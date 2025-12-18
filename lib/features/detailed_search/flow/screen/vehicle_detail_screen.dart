import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_bar_styles.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/bottom_action_bar.dart';
import 'package:tour_booking/core/widgets/buttons/simple_icon_button.dart';
import 'package:tour_booking/core/widgets/section_title.dart';
import 'package:tour_booking/features/detailed_search/flow/screen/full_screen_gallery_screen.dart';
import 'package:tour_booking/features/detailed_search/flow/tour_search_detail_viewmodel.dart';
import 'package:tour_booking/features/detailed_search/flow/widget/vehicle_detail_skelaton.dart';
import 'package:tour_booking/models/vehicle_detail_request/vehicle_detail_request.dart';

class VehicleDetailScreen extends StatefulWidget {
  final VehicleDetailRequest args;
  const VehicleDetailScreen({super.key, required this.args});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  late PageController _pageController;
  int _current = 0;
  late ScrollController _scrollController;
  bool _showBottom = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        // aşağı kaydı — bar gizlensin
        if (_showBottom) setState(() => _showBottom = false);
      } else {
        // yukarı kaydı — bar geri gelsin
        if (!_showBottom) setState(() => _showBottom = true);
      }
    });
    Future.microtask(() {
      context.read<TourSearchDetailViewModel>().fetchVehicle(widget.args);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _openGallery(List<String> images, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PremiumFullScreenGallery(images: images, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TourSearchDetailViewModel>();

    if (vm.isVehicleLoading) {
      return const Scaffold(body: Center(child: VehicleDetailSkeleton()));
    }

    final v = vm.vehicle;
    if (v == null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(child: Text(vm.errorMessage ?? tr("vehicle_not_found"))),
      );
    }

    final images = [v.image, ...(v.otherImages ?? []).cast<String>()];

    final price = vm.setVehiclePrice;
    final media = MediaQuery.of(context);
    final expandedH = media.size.height * 0.43;
    final topPad = media.padding.top;

    // YENİ: Alt çubuğun görünen yüksekliğini ve safe area boşluğunu hesaplıyoruz.
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // -----------------------------------------------------------------
          // HEADER – Minimal Sliver Hero
          // -----------------------------------------------------------------
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            elevation: 0,
            stretch: true,
            expandedHeight: expandedH,
            backgroundColor: Colors.transparent,
            flexibleSpace: LayoutBuilder(
              builder: (context, c) {
                final h = c.biggest.height;
                final minH = kToolbarHeight + topPad;
                final t = ((h - minH) / (expandedH - minH)).clamp(0.0, 1.0);
                final collapseT = 1 - t;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // SWIPE HERO
                    GestureDetector(
                      onTap: () => _openGallery(images, _current),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: images.length,
                        onPageChanged: (i) => setState(() => _current = i),
                        itemBuilder: (_, i) {
                          final img = CachedNetworkImage(
                            imageUrl: images[i],
                            fit: BoxFit.cover,
                          );
                          return img;
                        },
                      ),
                    ),

                    // GRADIENT overlay (gesture engellemesin)
                    IgnorePointer(
                      ignoring: true,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.45),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // 🔥 FOTO SAYACI (1/6)
                    Positioned(
                      right: 20,
                      bottom: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          "${_current + 1}/${images.length}",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // APPBAR BACKGROUND BLUR
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: topPad + kToolbarHeight,
                      child: Container(
                        color: AppColors.background.withOpacity(
                          lerpDouble(0.0, 1.0, collapseT) ?? 0,
                        ),
                      ),
                    ),

                    // BACK BUTTON
                    Positioned(
                      left: 10,
                      top: topPad + 4,
                      child: SimpleIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                        fillColor: Colors.white,
                        iconColor: Colors.black,
                        borderColor: Colors.white,
                        borderWidth: 1.2,
                      ),
                    ),

                    // TITLE – Sabit (scroll animasyonu yok)
                    Positioned(
                      top: topPad + 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          tr("vehicle_selection_title"),
                          style: AppBarStyles.title(context).copyWith(
                            color: collapseT > 0.5
                                ? Colors.black
                                : Colors.transparent,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // -----------------------------------------------------------------
          // BODY
          // -----------------------------------------------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ).copyWith(top: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SectionTitle(title: tr("vehicle_features_title")),

                  const SizedBox(height: 16),

                  // --- 3x2 GRID (araç özellikleri) ---
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _specTile(
                        Icons.directions_bus_outlined,
                        tr("vehicle_brand"),
                        v.vehicleBrand,
                      ),
                      _specTile(
                        Icons.category_outlined,
                        tr("vehicle_class"),
                        v.vehicleClass,
                      ),
                      _specTile(
                        Icons.confirmation_number_outlined,
                        tr("vehicle_type"),
                        v.vehicleType,
                      ),
                      _specTile(
                        Icons.event_seat_outlined,
                        tr("seat_count"),
                        "${v.seatCount}",
                      ),
                      _specTile(
                        Icons.calendar_today_outlined,
                        tr("model_year"),
                        "${v.modelYear}",
                      ),
                      _specTile(
                        Icons.airline_seat_legroom_extra_outlined,
                        tr("legroom"),
                        v.legRoomSpace ?? "-",
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  // --- EK ÖZELLİKLER ---
                  if ((v.vehicleFeatures?.isNotEmpty ?? false)) ...[
                    SectionTitle(title: tr("extra_features")),
                    const SizedBox(height: 16),

                    LayoutBuilder(
                      builder: (_, constraints) {
                        double maxW = constraints.maxWidth;
                        double itemW = (maxW - 12) / 2;

                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: v.vehicleFeatures!.map((f) {
                            return _featureItem(f, itemW);
                          }).toList(),
                        );
                      },
                    ),
                  ],

                  // Boşluk ayarı
                  const SizedBox(height: 26),

                  SectionTitle(
                    title: tr("driver_info_title"),
                    subtitle: tr("driver_info_subtitle"),
                  ),
                  const SizedBox(height: 16),

                  _driverSection(
                    name: v.nameSurname,
                    experience: v.experienceYear,
                    photoUrl: v.photoUrl,
                    languages: v.languages,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),

      // ---------------------------------------------------------------------
      // KESKİNLİĞİ GİDEREN VE ALANI YÖNETEN BOTTOM NAVIGATION BAR
      // ---------------------------------------------------------------------
      bottomNavigationBar: BottomActionBar(
        price: price,
        buttonText: tr("continue"),
        onPressed: () {
          context.push('/search-guide');
        },
      ),
    );
  }

  // -------------------------------------------------------------------------
  // SPEC TILE (6'lık grid)
  // -------------------------------------------------------------------------
  Widget _specTile(IconData icon, String label, String value) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.textPrimary),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 3),
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
  // FEATURE ITEM (2 sütun)
  // -------------------------------------------------------------------------
  Widget _featureItem(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }
}

Widget _driverSection({
  required String? name,
  required String? experience,
  required String? photoUrl,
  required List<String>? languages,
}) {
  return Container(
    margin: EdgeInsets.all(AppSpacing.xs),
    padding: const EdgeInsets.all(AppSpacing.l),
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: photoUrl ?? "",
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    shape: BoxShape.circle,
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: AppColors.textLight),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name ?? "", style: AppTextStyles.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    tr("driver_experience", args: ["${experience ?? '—'}"]),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        if (languages != null && languages.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(tr("driver_languages"), style: AppTextStyles.labelLarge),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: languages.map((lang) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
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
