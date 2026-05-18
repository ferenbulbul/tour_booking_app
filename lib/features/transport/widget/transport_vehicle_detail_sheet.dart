import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:intl/intl.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/tour/booking/screen/full_screen_gallery_screen.dart';
import 'package:tour_booking/models/transport/transport_vehicle/transport_vehicle.dart';

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
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
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
        const SizedBox(height: 6),

        // Swipeable photo carousel with counter + close button
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
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
                        itemBuilder: (_, i) => GestureDetector(
                          onTap: () => _openGallery(images, i),
                          child: CachedNetworkImage(
                            imageUrl: images[i],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              height: 200,
                              color: AppColors.border.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 200,
                        color: AppColors.border.withValues(alpha: 0.3),
                        child: const Center(
                          child: Icon(SolarIconsOutline.routing,
                              size: 48, color: Colors.grey),
                        ),
                      ),
              ),
              // Close button — top right
              Positioned(
                right: 8,
                top: 8,
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
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Photo counter badge
              if (images.length > 1)
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${_currentPage + 1}/${images.length}",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Brand + price row
        Row(
          children: [
            Expanded(
              child: Text(
                '${v.brandName} ${v.className}',
                style: AppTextStyles.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              _formatPrice(v.baseFee),
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.accent,
              ),
            ),
          ],
        ),

        // Agency name
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(SolarIconsOutline.buildings,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  v.agencyName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Rating
        if (v.avgRating > 0 && v.ratingCount > 0) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              ...List.generate(5, (i) {
                final r = v.avgRating;
                IconData icon;
                if (i < r.floor()) {
                  icon = Icons.star_rounded;
                } else if (i < r.ceil() && r - r.floor() >= 0.5) {
                  icon = Icons.star_half_rounded;
                } else {
                  icon = Icons.star_outline_rounded;
                }
                return Icon(icon, size: 14, color: AppColors.warning);
              }),
              const SizedBox(width: 4),
              Text(
                "${v.avgRating.toStringAsFixed(1)} (${v.ratingCount})",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 16),

        // Specs grid
        _sectionLabel(tr("vehicle_features_title")),
        const SizedBox(height: 10),
        _specsGrid(),

        // Pricing section
        const SizedBox(height: 18),
        _sectionLabel(tr("transport_pricing")),
        const SizedBox(height: 10),
        _pricingSection(),

        // Driver section
        const SizedBox(height: 18),
        _sectionLabel(tr("driver_info_title")),
        const SizedBox(height: 10),
        _driverRow(),

        const SizedBox(height: 20),
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

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.labelLarge.copyWith(fontSize: 13),
    );
  }

  Widget _specsGrid() {
    final specs = <_SpecItem>[
      _SpecItem(
          SolarIconsOutline.routing, tr("vehicle_brand"), v.brandName),
      _SpecItem(
          SolarIconsOutline.settings, tr("vehicle_class"), v.className),
      _SpecItem(SolarIconsOutline.usersGroupRounded, tr("seat_count"),
          "${v.seatCount}"),
      if (v.modelYear != null)
        _SpecItem(SolarIconsOutline.calendarDate, tr("model_year"),
            v.modelYear!),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: specs.map((s) {
        return SizedBox(
          width:
              (MediaQuery.of(context).size.width - AppSpacing.l * 2 - 8) / 2,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(s.icon, size: 16, color: AppColors.textLight),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.label,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                          color: AppColors.textLight,
                        ),
                      ),
                      Text(
                        s.value,
                        style: AppTextStyles.labelSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _pricingSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _priceRow(
            SolarIconsOutline.flag,
            tr("transport_base_fee"),
            _formatPrice(v.baseFee),
          ),
          const SizedBox(height: 10),
          _priceRow(
            SolarIconsOutline.ruler,
            tr("transport_price_per_km"),
            '${_formatPrice(v.pricePerKm)}/km',
          ),
        ],
      ),
    );
  }

  Widget _priceRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textLight),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.accent,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _driverRow() {
    final hasPhoto =
        v.driverPhoto != null && v.driverPhoto!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: hasPhoto
                ? CachedNetworkImage(
                    imageUrl: v.driverPhoto!,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _driverPlaceholder(),
                    errorWidget: (_, __, ___) => _driverPlaceholder(),
                  )
                : _driverPlaceholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  v.driverName,
                  style: AppTextStyles.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (v.experienceYears != null) ...[
                      Text(
                        tr("driver_experience",
                            namedArgs: {"year": v.experienceYears!}),
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      _dot(),
                    ],
                    Flexible(
                      child: Text(
                        v.agencyName,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _driverPlaceholder() {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.border,
        shape: BoxShape.circle,
      ),
      child: const Icon(SolarIconsOutline.user,
          size: 20, color: AppColors.textLight),
    );
  }

  Widget _dot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Text(
        "\u00B7",
        style: TextStyle(
          color: AppColors.textLight,
          fontWeight: FontWeight.w900,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildBottomBar(double bottomPad) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.l,
        10,
        AppSpacing.l,
        bottomPad > 0 ? bottomPad : 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: const Border(
            top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tr("summary_price"),
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 11,
                  color: AppColors.textLight,
                ),
              ),
              Text(
                _formatPrice(v.baseFee),
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
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
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  tr("continue"),
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontSize: 14,
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

class _SpecItem {
  final IconData icon;
  final String label;
  final String value;
  const _SpecItem(this.icon, this.label, this.value);
}
