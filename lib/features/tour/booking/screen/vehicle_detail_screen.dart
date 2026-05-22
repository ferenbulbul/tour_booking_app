import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/widgets/buttons/simple_icon_button.dart';
import 'package:tour_booking/features/tour/booking/screen/full_screen_gallery_screen.dart';
import 'package:tour_booking/features/tour/booking/tour_vehicle_guide_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/widget/vehicle_detail_body.dart';
import 'package:tour_booking/features/tour/booking/widget/vehicle_detail_bottom_bar.dart';
import 'package:tour_booking/features/tour/booking/widget/vehicle_detail_skeleton.dart';
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
        if (_showBottom) setState(() => _showBottom = false);
      } else {
        if (!_showBottom) setState(() => _showBottom = true);
      }
    });
    Future.microtask(() {
      context.read<TourVehicleGuideViewModel>().fetchVehicle(widget.args);
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
    final vm = context.watch<TourVehicleGuideViewModel>();

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

    final price = vm.vehiclePrice;
    final media = MediaQuery.of(context);
    final expandedH = media.size.height * 0.43;
    final topPad = media.padding.top;

    final scheme = context.colors;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // -----------------------------------------------------------------
          // HEADER -- Minimal Sliver Hero
          // -----------------------------------------------------------------
          _buildSliverAppBar(
            context,
            images: images,
            expandedH: expandedH,
            topPad: topPad,
            avgRating: v.avgRating,
            ratingCount: v.ratingCount,
          ),

          // -----------------------------------------------------------------
          // BODY
          // -----------------------------------------------------------------
          VehicleDetailBody(vehicle: v),
        ],
      ),

      // ---------------------------------------------------------------------
      // BOTTOM NAVIGATION BAR
      // ---------------------------------------------------------------------
      bottomNavigationBar: VehicleDetailBottomBar(price: price),
    );
  }

  // -------------------------------------------------------------------------
  // SLIVER APP BAR
  // -------------------------------------------------------------------------
  Widget _buildSliverAppBar(
    BuildContext context, {
    required List<String> images,
    required double expandedH,
    required double topPad,
    required double? avgRating,
    required int? ratingCount,
  }) {
    return SliverAppBar(
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
              Semantics(
                button: true,
                label: 'Open image gallery',
                child: GestureDetector(
                  onTap: () => _openGallery(images, _current),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (i) => setState(() => _current = i),
                    itemBuilder: (_, i) {
                      return Semantics(
                        image: true,
                        label: 'Vehicle photo',
                        child: CachedNetworkImage(
                          imageUrl: images[i],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // GRADIENT overlay
              IgnorePointer(
                ignoring: true,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0),
                        Colors.black.withValues(alpha: 0.45),
                      ],
                    ),
                  ),
                ),
              ),

              // PHOTO COUNTER (1/6)
              Positioned(
                right: AppSpacing.xl,
                bottom: AppSpacing.xl,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.ms,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(AppRadius.circular),
                  ),
                  child: Text(
                    "${_current + 1}/${images.length}",
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: AppSpacing.xl,
                bottom: AppSpacing.xl,
                child: _ratingOverlay(context, avgRating, ratingCount),
              ),

              // APPBAR BACKGROUND BLUR
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: topPad + kToolbarHeight,
                child: Container(
                  color: context.colors.surfaceContainerHighest.withValues(
                    alpha: lerpDouble(0.0, 1.0, collapseT) ?? 0,
                  ),
                ),
              ),

              // BACK BUTTON
              Positioned(
                left: AppSpacing.ms,
                top: topPad + AppSpacing.xs,
                child: SimpleIconButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: () => Navigator.pop(context),
                  fillColor: Colors.white,
                  iconColor: Colors.black,
                  borderColor: Colors.white,
                  borderWidth: 1.2,
                  tooltip: 'Back',
                ),
              ),

              // TITLE -- Fixed (no scroll animation)
              Positioned(
                top: topPad + AppSpacing.ms,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    tr("vehicle_selection_title"),
                    style: AppTextStyles.titleMedium.copyWith(
                      color: collapseT > 0.5
                          ? Colors.black
                          : Colors.black.withValues(alpha: 0),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _ratingOverlay(BuildContext context, double? avg, int? count) {
  if (avg == null || count == null || count == 0) {
    return const SizedBox.shrink();
  }

  return Container(
    padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.ml, vertical: AppSpacing.sm),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(AppRadius.circular),
      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded,
            size: AppIconSize.ml,
            color: context.ext.star,
            semanticLabel: 'Rating star'),
        const SizedBox(width: AppSpacing.sm),
        Text(
          "${avg.toStringAsFixed(1)}",
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          "($count)",
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    ),
  );
}
