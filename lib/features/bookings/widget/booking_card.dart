import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/bookings/utils/booking_utils.dart';
import 'package:tour_booking/models/booking/booking_dto.dart';

/// Large, prominent card for upcoming bookings.
/// Shows image banner, countdown badge, title, date, price.
class UpcomingBookingCard extends StatelessWidget {
  final BookingDto item;
  final VoidCallback onTap;

  const UpcomingBookingCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  bool get _hasImage => !_isTransport && item.image.isNotEmpty;
  bool get _isTransport => item.bookingType == 1;

  @override
  Widget build(BuildContext context) {
    final departureDate = item.departureDate.isNotEmpty
        ? DateTime.parse(item.departureDate)
        : DateTime.now();
    final countdown = getCountdownText(departureDate);
    final statusColor = bookingStatusColor(item.status);
    final statusText = bookingStatusLabel(item.status, departureDate);
    final effectiveTime = _isTransport
        ? (item.pickupTime ?? item.departureTime)
        : item.departureTime;
    final formattedDate =
        DateFormat('dd MMM yyyy', 'tr_TR').format(departureDate);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.4),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE BANNER (only tours with image)
            if (_hasImage)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: _tourImage(context),
                  ),
                  if (countdown.isNotEmpty)
                    Positioned(
                      bottom: 10,
                      left: 12,
                      child: _countdownBadge(countdown),
                    ),
                  Positioned(
                    bottom: 10,
                    right: 12,
                    child: _statusBadge(statusText, statusColor),
                  ),
                ],
              ),

            // CONTENT
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BADGES (compact layout — no image)
                  if (!_hasImage)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          // TRANSPORT / TOUR ICON
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _isTransport ? SolarIconsOutline.routing : SolarIconsOutline.map,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (countdown.isNotEmpty) ...[
                            _countdownBadge(countdown),
                            const SizedBox(width: 8),
                          ],
                          _statusBadge(statusText, statusColor),
                        ],
                      ),
                    ),

                  // TITLE
                  Text(
                    _isTransport ? 'Transfer' : item.tourPointName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  // ROUTE (transport only)
                  if (_isTransport) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(SolarIconsOutline.route,
                            size: 14, color: AppColors.textLight),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            '${item.pickupAddress ?? ''} → ${item.dropoffAddress ?? ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 8),

                  // DATE + TIME
                  Row(
                    children: [
                      const Icon(SolarIconsOutline.calendarDate,
                          size: 14, color: AppColors.textLight),
                      const SizedBox(width: 5),
                      Text(
                        formattedDate,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (effectiveTime.isNotEmpty) ...[
                        Container(
                          width: 3,
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: const BoxDecoration(
                            color: AppColors.textLight,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Icon(SolarIconsOutline.clockCircle,
                            size: 14, color: AppColors.textLight),
                        const SizedBox(width: 5),
                        Text(
                          effectiveTime,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // LOCATION (tour only)
                  if (!_isTransport && item.tourPointCity.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(SolarIconsOutline.mapPoint,
                            size: 14, color: AppColors.textLight),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            item.tourPointCity,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 14),

                  // PRICE + DETAILS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency(item.totalPrice),
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'booking_details'.tr(),
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(SolarIconsOutline.arrowRight,
                              size: 16, color: AppColors.primary),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _countdownBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
          ),
        ],
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.accent,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _tourImage(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final screenWidth = MediaQuery.of(context).size.width;
    final targetWidth = ((screenWidth - 40) * dpr).round();

    return CachedNetworkImage(
      imageUrl: item.image,
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
      memCacheWidth: targetWidth,
      fadeInDuration: const Duration(milliseconds: 150),
      placeholder: (_, __) => Container(
        height: 160,
        color: AppColors.background,
      ),
      errorWidget: (_, __, ___) => Container(
        height: 160,
        color: AppColors.background,
        child: const Center(
          child: Icon(SolarIconsOutline.galleryRemove,
              size: 32, color: AppColors.textLight),
        ),
      ),
    );
  }
}
