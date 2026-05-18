import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/tour/booking/screen/full_screen_gallery_screen.dart';
import 'package:tour_booking/features/tour/booking/tour_vehicle_guide_viewmodel.dart';
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
          Expanded(
            child: vm.isVehicleLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accent,
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
        const SizedBox(height: 6),

        // Swipeable photo carousel with counter + close button
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                v.vehicleBrand,
                style: AppTextStyles.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              _formatPrice(vm.vehiclePrice ?? v.price ?? 0),
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.accent,
              ),
            ),
          ],
        ),

        // Şirket adı
        if (v.companyName != null && v.companyName!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Icon(SolarIconsOutline.buildings,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    v.companyName!,
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
        if (v.avgRating != null && v.avgRating! > 0) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              ...List.generate(5, (i) {
                final r = v.avgRating!;
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
                "${v.avgRating!.toStringAsFixed(1)} (${v.ratingCount ?? 0})",
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
        _specsGrid(v),

        // Extra features
        if (v.vehicleFeatures != null && v.vehicleFeatures!.isNotEmpty) ...[
          const SizedBox(height: 18),
          _sectionLabel(tr("extra_features")),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: v.vehicleFeatures!.map((f) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(SolarIconsOutline.checkCircle,
                        size: 13, color: AppColors.success),
                    const SizedBox(width: 5),
                    Text(
                      f,
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],

        // Driver section
        if (v.nameSurname != null && v.nameSurname!.isNotEmpty) ...[
          const SizedBox(height: 18),
          _sectionLabel(tr("driver_info_title")),
          const SizedBox(height: 10),
          _driverRow(v),
        ],

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

  Widget _specsGrid(dynamic v) {
    final specs = <_SpecItem>[
      _SpecItem(SolarIconsOutline.routing, tr("vehicle_brand"), v.vehicleBrand),
      _SpecItem(SolarIconsOutline.settings, tr("vehicle_class"), v.vehicleClass),
      _SpecItem(SolarIconsOutline.ticket, tr("vehicle_type"), v.vehicleType),
      _SpecItem(SolarIconsOutline.usersGroupRounded, tr("seat_count"), "${v.seatCount}"),
      if (v.modelYear != null)
        _SpecItem(SolarIconsOutline.calendarDate, tr("model_year"), "${v.modelYear}"),
      if (v.legRoomSpace != null)
        _SpecItem(SolarIconsOutline.routing, tr("legroom"), v.legRoomSpace!),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: specs.map((s) {
        return SizedBox(
          width:
              (MediaQuery.of(context).size.width - AppSpacing.l * 2 - 8) / 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

  Widget _driverRow(dynamic v) {
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
            child: CachedNetworkImage(
              imageUrl: v.photoUrl ?? "",
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.border,
                  shape: BoxShape.circle,
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.border,
                  shape: BoxShape.circle,
                ),
                child: const Icon(SolarIconsOutline.user,
                    size: 20, color: AppColors.textLight),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  v.nameSurname ?? "",
                  style: AppTextStyles.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (v.experienceYear != null) ...[
                      Text(
                        tr("driver_experience",
                            namedArgs: {"year": v.experienceYear.toString()}),
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    if (v.languages != null && v.languages!.isNotEmpty) ...[
                      if (v.experienceYear != null) _dot(),
                      Flexible(
                        child: Text(
                          (v.languages as List<String>).join(", "),
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildBottomBar(TourVehicleGuideViewModel vm, double bottomPad) {
    final price = vm.vehiclePrice ?? vm.vehicle?.price ?? 0;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.l,
        10,
        AppSpacing.l,
        bottomPad > 0 ? bottomPad : 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border:
            const Border(top: BorderSide(color: AppColors.border, width: 0.5)),
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
                _formatPrice(price),
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
                context.push('/search-guide');
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
