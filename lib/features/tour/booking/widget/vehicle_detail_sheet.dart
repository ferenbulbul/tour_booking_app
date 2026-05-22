import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/features/tour/booking/screen/full_screen_gallery_screen.dart';
import 'package:tour_booking/features/tour/booking/tour_vehicle_guide_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/widget/vehicle_info_header.dart';
import 'package:tour_booking/features/tour/booking/widget/vehicle_specs_section.dart';
import 'package:tour_booking/models/vehicle_detail_request/vehicle_detail_request.dart';

class VehicleDetailSheet extends StatefulWidget {
  final VehicleDetailRequest request;
  final String heroImage;

  const VehicleDetailSheet({
    super.key,
    required this.request,
    required this.heroImage,
  });

  @override
  State<VehicleDetailSheet> createState() => _VehicleDetailSheetState();
}

class _VehicleDetailSheetState extends State<VehicleDetailSheet> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    final vm = context.read<TourVehicleGuideViewModel>();
    Future.microtask(() {
      vm.fetchVehicle(widget.request);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final screenH = MediaQuery.of(context).size.height;
    final vm = context.watch<TourVehicleGuideViewModel>();

    return Container(
      height: screenH * 0.75,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.ms, bottom: AppSpacing.sm),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.outline,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
            ),
          ),

          // Scrollable content
          Expanded(
            child: vm.isVehicleLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: context.colors.secondary,
                      strokeWidth: 2.5,
                    ),
                  )
                : vm.vehicle == null
                    ? Center(
                        child: Text(
                          vm.errorMessage ?? tr("vehicle_not_found"),
                          style: AppTextStyles.bodyMedium,
                        ),
                      )
                    : _buildContent(vm),
          ),

          // Sticky bottom button
          if (!vm.isVehicleLoading && vm.vehicle != null)
            _buildBottomBar(vm, bottomPad),
        ],
      ),
    );
  }

  Widget _buildContent(TourVehicleGuideViewModel vm) {
    final v = vm.vehicle!;
    final images = [v.image, ...(v.otherImages ?? []).cast<String>()];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      children: [
        VehicleInfoHeader(
          images: images,
          currentPage: _currentPage,
          pageController: _pageController,
          onPageChanged: (i) => setState(() => _currentPage = i),
          vehicleBrand: v.vehicleBrand,
          formattedPrice: _formatPrice(vm.vehiclePrice ?? v.price ?? 0),
          companyName: v.companyName,
          avgRating: v.avgRating,
          ratingCount: v.ratingCount,
          onOpenGallery: _openGallery,
          onClose: () => Navigator.pop(context),
        ),

        const SizedBox(height: AppSpacing.l),

        VehicleSpecsSection(vehicle: v),
      ],
    );
  }

  void _openGallery(List<String> images, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PremiumFullScreenGallery(
          images: images,
          initialIndex: index,
        ),
      ),
    );
  }

  Widget _buildBottomBar(TourVehicleGuideViewModel vm, double bottomPad) {
    final price = vm.vehiclePrice ?? vm.vehicle?.price ?? 0;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.ms,
        AppSpacing.l,
        bottomPad > 0 ? bottomPad : AppSpacing.m,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        border:
            Border(top: BorderSide(color: context.colors.outline, width: 0.5)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tr("summary_price"),
                style: AppTextStyles.caption.copyWith(
                  color: context.ext.textLight,
                ),
              ),
              Text(
                _formatPrice(price),
                style: AppTextStyles.titleSmall.copyWith(
                  color: context.colors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.l),
          Expanded(
            child: Semantics(
              button: true,
              label: 'Continue to guide selection',
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  context.push('/search-guide');
                },
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: context.colors.secondary,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tr("continue"),
                    style: AppTextStyles.labelLarge.copyWith(
                      color: context.colors.onSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
