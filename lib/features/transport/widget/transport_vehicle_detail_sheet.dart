import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:intl/intl.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/tour/booking/screen/full_screen_gallery_screen.dart';
import 'package:tour_booking/features/transport/widget/transport_vehicle_info_section.dart';
import 'package:tour_booking/features/transport/widget/transport_vehicle_features_list.dart';
import 'package:tour_booking/models/transport/transport_vehicle/transport_vehicle.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class TransportVehicleDetailSheet extends StatefulWidget {
  final TransportVehicle vehicle;
  final Map<String, dynamic> searchContext;
  final BuildContext navigatorContext;

  const TransportVehicleDetailSheet({
    super.key,
    required this.vehicle,
    required this.searchContext,
    required this.navigatorContext,
  });

  @override
  State<TransportVehicleDetailSheet> createState() =>
      _TransportVehicleDetailSheetState();
}

class _TransportVehicleDetailSheetState
    extends State<TransportVehicleDetailSheet> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  TransportVehicle get v => widget.vehicle;

  List<String> get _images {
    final list = <String>[];
    if (v.vehicleImage != null && v.vehicleImage!.isNotEmpty) {
      list.add(v.vehicleImage!);
    }
    list.addAll(v.otherImages);
    return list;
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

    return Container(
      height: screenH * 0.75,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
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
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
            ),
          ),

          // Scrollable content
          Expanded(child: _buildContent()),

          // Sticky bottom button
          _buildBottomBar(bottomPad),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final images = _images;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      children: [
        const SizedBox(height: AppSpacing.sm),

        // Swipeable photo carousel with counter + close button
        _buildPhotoCarousel(images),

        const SizedBox(height: AppSpacing.ml),

        // Vehicle info: brand, agency, rating, specs grid
        TransportVehicleInfoSection(
          vehicle: v,
          formattedPrice: _formatPrice(v.baseFee),
        ),

        // Pricing + Driver
        const SizedBox(height: AppSpacing.l + 2),
        TransportVehicleFeaturesList(
          vehicle: v,
          formatPrice: _formatPrice,
        ),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildPhotoCarousel(List<String> images) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.ml),
      child: Stack(
        children: [
          SizedBox(
            height: 200,
            child: images.isNotEmpty
                ? PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (i) =>
                        setState(() => _currentPage = i),
                    itemBuilder: (_, i) => Semantics(
                      button: true,
                      label: 'View photo ${i + 1} in gallery',
                      child: GestureDetector(
                        onTap: () => _openGallery(images, i),
                        child: Semantics(
                          image: true,
                          label: 'Vehicle photo',
                          child: CachedNetworkImage(
                            imageUrl: images[i],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              height: 200,
                              color: context.colors.outline.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 200,
                    color: context.colors.outline.withValues(alpha: 0.3),
                    child: Center(
                      child: Icon(SolarIconsOutline.routing,
                          size: AppIconSize.huge, color: context.ext.textLight, semanticLabel: 'Vehicle'),
                    ),
                  ),
          ),
          // Close button -- top right
          Positioned(
            right: AppSpacing.s,
            top: AppSpacing.s,
            child: Semantics(
              button: true,
              label: 'Close vehicle details',
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: AppIconSize.ml,
                    color: Colors.white,
                    semanticLabel: 'Close',
                  ),
                ),
              ),
            ),
          ),
          // Photo counter badge
          if (images.length > 1)
            Positioned(
              left: AppSpacing.s,
              bottom: AppSpacing.s,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Text(
                  "${_currentPage + 1}/${images.length}",
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
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

  Widget _buildBottomBar(double bottomPad) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.ms,
        AppSpacing.l,
        bottomPad > 0 ? bottomPad : AppSpacing.m,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        border: Border(
            top: BorderSide(color: context.colors.outline, width: 0.5)),
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
                _formatPrice(v.baseFee),
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
              label: 'Continue to transport summary',
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  widget.navigatorContext.push('/transport-summary', extra: {
                    'vehicle': v,
                    'pickupAddress': widget.searchContext['pickupAddress'],
                    'pickupLat': widget.searchContext['pickupLat'],
                    'pickupLng': widget.searchContext['pickupLng'],
                    'dropoffAddress': widget.searchContext['dropoffAddress'],
                    'dropoffLat': widget.searchContext['dropoffLat'],
                    'dropoffLng': widget.searchContext['dropoffLng'],
                    'date': widget.searchContext['date'],
                    'time': widget.searchContext['time'],
                    'clientDistanceKm':
                        widget.searchContext['clientDistanceKm'],
                    'clientDurationMinutes':
                        widget.searchContext['clientDurationMinutes'],
                  });
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
