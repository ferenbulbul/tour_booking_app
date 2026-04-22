import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/features/detailed_search/flow/screen/full_screen_gallery_screen.dart';
import 'package:tour_booking/models/transport/transport_vehicle/transport_vehicle.dart';

class TransportVehicleDetailScreen extends StatefulWidget {
  final TransportVehicle vehicle;
  final Map<String, dynamic> searchContext;

  const TransportVehicleDetailScreen({
    super.key,
    required this.vehicle,
    required this.searchContext,
  });

  @override
  State<TransportVehicleDetailScreen> createState() =>
      _TransportVehicleDetailScreenState();
}

class _TransportVehicleDetailScreenState
    extends State<TransportVehicleDetailScreen> {
  late PageController _pageController;
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

  String _formatPrice(num price) {
    final f = NumberFormat.currency(
        locale: 'tr_TR', symbol: '\u20BA', decimalDigits: 2);
    return f.format(price);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToSummary() {
    context.push('/transport-summary', extra: {
      'vehicle': v,
      'pickupAddress': widget.searchContext['pickupAddress'],
      'pickupLat': widget.searchContext['pickupLat'],
      'pickupLng': widget.searchContext['pickupLng'],
      'dropoffAddress': widget.searchContext['dropoffAddress'],
      'dropoffLat': widget.searchContext['dropoffLat'],
      'dropoffLng': widget.searchContext['dropoffLng'],
      'date': widget.searchContext['date'],
      'time': widget.searchContext['time'],
      'clientDistanceKm': widget.searchContext['clientDistanceKm'],
      'clientDurationMinutes': widget.searchContext['clientDurationMinutes'],
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final expandedH = MediaQuery.of(context).size.height * 0.40;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ---- IMAGE HEADER ----
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
                final collapseT =
                    1 - ((h - minH) / (expandedH - minH)).clamp(0.0, 1.0);

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image gallery
                    if (_images.isNotEmpty)
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PremiumFullScreenGallery(
                              images: _images,
                              initialIndex: _currentPage,
                            ),
                          ),
                        ),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _images.length,
                          onPageChanged: (i) =>
                              setState(() => _currentPage = i),
                          itemBuilder: (_, i) => CachedNetworkImage(
                            imageUrl: _images[i],
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.directions_car,
                                  size: 64, color: Colors.grey),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.directions_car,
                              size: 64, color: Colors.grey),
                        ),
                      ),

                    // Gradient
                    IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.45),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Photo counter
                    if (_images.length > 1)
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_currentPage + 1}/${_images.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                    // Rating
                    if (v.avgRating > 0 && v.ratingCount > 0)
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                v.avgRating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${v.ratingCount})',
                                style: TextStyle(
                                  color:
                                      Colors.white.withValues(alpha: 0.85),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Appbar background
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: topPad + kToolbarHeight,
                      child: Container(
                        color: AppColors.background
                            .withValues(alpha: collapseT),
                      ),
                    ),

                    // Back button
                    Positioned(
                      left: 12,
                      top: topPad + 6,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.black.withValues(alpha: 0.15),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back, size: 20),
                        ),
                      ),
                    ),

                    // Title when collapsed
                    Positioned(
                      top: topPad + 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          '${v.brandName} ${v.className}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: collapseT > 0.5
                                ? AppColors.textPrimary
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

          // ---- BODY ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle name
                  Text(
                    '${v.brandName} ${v.className}',
                    style: AppTextStyles.titleLarge,
                  ),
                  if (v.licensePlate != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      v.licensePlate!,
                      style: AppTextStyles.bodySmall.copyWith(
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Specs grid
                  _sectionTitle('transport_vehicle_specs'.tr()),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (_, c) {
                      final itemW = (c.maxWidth - 12) / 2;
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _specTile(Icons.directions_bus_outlined,
                              'transport_brand'.tr(), v.brandName, itemW),
                          _specTile(Icons.category_outlined,
                              'transport_class'.tr(), v.className, itemW),
                          _specTile(
                              Icons.event_seat_outlined,
                              'transport_seats'.tr(),
                              '${v.seatCount}',
                              itemW),
                          if (v.modelYear != null)
                            _specTile(Icons.calendar_today_outlined,
                                'transport_model_year'.tr(), v.modelYear!, itemW),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Pricing
                  _sectionTitle('transport_pricing'.tr()),
                  const SizedBox(height: 12),
                  _pricingCard(),

                  const SizedBox(height: 24),

                  // Driver
                  _sectionTitle('transport_driver_info'.tr()),
                  const SizedBox(height: 12),
                  _driverCard(),

                  const SizedBox(height: 32),

                  // Continue button
                  PrimaryButton(
                    text: 'transport_continue_to_summary'.tr(),
                    icon: Icons.arrow_forward,
                    onPressed: _goToSummary,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.titleSmall,
    );
  }

  Widget _specTile(
      IconData icon, String label, String value, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.textPrimary),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.labelSmall),
          const SizedBox(height: 3),
          Text(
            value,
            style: AppTextStyles.bodyMedium
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _pricingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _priceRow(
            Icons.flag_outlined,
            'transport_base_fee'.tr(),
            _formatPrice(v.baseFee),
          ),
          const SizedBox(height: 12),
          _priceRow(
            Icons.straighten,
            'transport_price_per_km'.tr(),
            '${_formatPrice(v.pricePerKm)}/km',
          ),
        ],
      ),
    );
  }

  Widget _priceRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: AppTextStyles.bodyMedium),
        ),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _driverCard() {
    final hasPhoto =
        v.driverPhoto != null && v.driverPhoto!.isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: hasPhoto
                ? CachedNetworkImage(
                    imageUrl: v.driverPhoto!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => _driverAvatarPlaceholder(),
                  )
                : _driverAvatarPlaceholder(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(v.driverName, style: AppTextStyles.titleSmall),
                const SizedBox(height: 4),
                if (v.experienceYears != null)
                  Row(
                    children: [
                      Icon(Icons.workspace_premium,
                          size: 14, color: Colors.amber.shade700),
                      const SizedBox(width: 4),
                      Text(
                        '${v.experienceYears} ${'transport_years_exp'.tr()}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.business,
                        size: 14, color: AppColors.textLight),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        v.agencyName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall,
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

  Widget _driverAvatarPlaceholder() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, size: 28, color: AppColors.primary),
    );
  }
}
