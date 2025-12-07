import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/bottom_action_bar.dart';
import 'package:tour_booking/core/widgets/buttons/simple_icon_button.dart';
import 'package:tour_booking/features/detailed_search/flow/screen/full_screen_gallery_screen.dart';
import 'package:tour_booking/features/detailed_search/flow/tour_search_detail_viewmodel.dart';
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

  // Animasyon süresi ve eğrisi (Yumuşak ayarlar)
  static const Duration _animationDuration = Duration(milliseconds: 500);
  static const Curve _animationCurve = Curves.easeOutQuint;

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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    final v = vm.vehicle;
    if (v == null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Center(child: Text(vm.errorMessage ?? "Araç bulunamadı")),
      );
    }

    final images = [v.image, ...(v.otherImages ?? []).cast<String>()];

    final price = vm.setVehiclePrice;
    final media = MediaQuery.of(context);
    final expandedH = media.size.height * 0.43;
    final topPad = media.padding.top;

    // YENİ: Alt çubuğun görünen yüksekliğini ve safe area boşluğunu hesaplıyoruz.
    final bottomPadding = media.padding.bottom;
    // BottomActionBar'ın tahmini yüksekliği (iç paddingler dahil)
    const double barContentHeight = 60.0;
    final double fullBarHeight = barContentHeight + bottomPadding;

    return Scaffold(
      backgroundColor: AppColors.background,
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
                        color: Colors.white.withOpacity(
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
                          "Araç Seçimi",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: collapseT > 0.5
                                ? Colors.black
                                : Colors.transparent,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle("Araç Özellikleri"),

                  const SizedBox(height: 14),

                  // --- 3x2 GRID (araç özellikleri) ---
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _specTile(
                        Icons.directions_bus_outlined,
                        "Marka",
                        v.vehicleBrand,
                      ),
                      _specTile(
                        Icons.category_outlined,
                        "Sınıf",
                        v.vehicleClass,
                      ),
                      _specTile(
                        Icons.confirmation_number_outlined,
                        "Tip",
                        v.vehicleType,
                      ),
                      _specTile(
                        Icons.event_seat_outlined,
                        "Koltuk",
                        "${v.seatCount}",
                      ),
                      _specTile(
                        Icons.calendar_today_outlined,
                        "Model Yılı",
                        "${v.modelYear}",
                      ),
                      _specTile(
                        Icons.airline_seat_legroom_extra_outlined,
                        "Bacak Mesafesi",
                        v.legRoomSpace ?? "-",
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  // --- EK ÖZELLİKLER ---
                  if ((v.vehicleFeatures?.isNotEmpty ?? false)) ...[
                    _SectionTitle("Ek Özellikler"),
                    const SizedBox(height: 14),

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
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ],
      ),

      // ---------------------------------------------------------------------
      // KESKİNLİĞİ GİDEREN VE ALANI YÖNETEN BOTTOM NAVIGATION BAR
      // ---------------------------------------------------------------------
      bottomNavigationBar: AnimatedContainer(
        duration: _animationDuration,
        height: _showBottom ? fullBarHeight : 0.0,
        curve: _animationCurve,
        child: AnimatedSlide(
          duration: _animationDuration,
          curve: _animationCurve,
          offset: _showBottom ? Offset.zero : const Offset(0, 0.4),
          child: AnimatedOpacity(
            duration: _animationDuration,
            opacity: _showBottom ? 1 : 0,
            curve: _animationCurve,
            child: BottomActionBar(
              price: price,
              buttonText: "Devam Et",
              onPressed: () {
                context.push('/search-guide');
              },
            ),
          ),
        ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          Icon(icon, size: 22, color: Colors.black87),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // SECTION TITLE
  // -------------------------------------------------------------------------
  Widget _SectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }
}
