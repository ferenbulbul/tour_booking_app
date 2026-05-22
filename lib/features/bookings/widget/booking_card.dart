import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_elevation.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/bookings/utils/booking_utils.dart';
import 'package:tour_booking/models/booking/booking_dto.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

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
    final statusColor = bookingStatusColor(context, item.status);
    final statusText = bookingStatusLabel(item.status, departureDate);
    final effectiveTime = _isTransport
        ? (item.pickupTime ?? item.departureTime)
        : item.departureTime;
    final formattedDate =
        DateFormat('dd MMM yyyy', 'tr_TR').format(departureDate);

    return Semantics(
      label: 'View booking details',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(
              color: context.colors.outline.withValues(alpha: 0.4),
              width: 0.5,
            ),
            boxShadow: AppElevation.shadowMd,
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
                        const BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
                    child: _tourImage(context),
                  ),
                  if (countdown.isNotEmpty)
                    Positioned(
                      bottom: AppSpacing.ms,
                      left: AppSpacing.m,
                      child: _countdownBadge(context, countdown),
                    ),
                  Positioned(
                    bottom: AppSpacing.ms,
                    right: AppSpacing.m,
                    child: _statusBadge(statusText, statusColor),
                  ),
                ],
              ),

            // CONTENT
            Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BADGES (compact layout — no image)
                  if (!_hasImage)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.ms),
                      child: Row(
                        children: [
                          // TRANSPORT / TOUR ICON
                          Container(
                            width: AppSpacing.xxxxl,
                            height: AppSpacing.xxxxl,
                            decoration: BoxDecoration(
                              color: context.colors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(AppRadius.medium),
                            ),
                            child: Icon(
                              _isTransport ? SolarIconsOutline.routing : SolarIconsOutline.map,
                              color: context.colors.primary,
                              size: AppIconSize.l,
                              semanticLabel: _isTransport ? 'Transport' : 'Tour',
                            ),
                          ),
                          const SizedBox(width: AppSpacing.ms),
                          if (countdown.isNotEmpty) ...[
                            _countdownBadge(context, countdown),
                            const SizedBox(width: AppSpacing.s),
                          ],
                          _statusBadge(statusText, statusColor),
                        ],
                      ),
                    ),

                  // TITLE
                  Text(
                    _isTransport ? tr('transport_title') : item.tourPointName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  // ROUTE (transport only)
                  if (_isTransport) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(SolarIconsOutline.route,
                            size: AppIconSize.s, color: context.ext.textLight, semanticLabel: 'Route'),
                        const SizedBox(width: AppSpacing.xsm),
                        Flexible(
                          child: Text(
                            '${item.pickupAddress ?? ''} → ${item.dropoffAddress ?? ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: AppSpacing.s),

                  // DATE + TIME
                  Row(
                    children: [
                      Icon(SolarIconsOutline.calendarDate,
                          size: AppIconSize.s, color: context.ext.textLight, semanticLabel: 'Date'),
                      const SizedBox(width: AppSpacing.xsm),
                      Text(
                        formattedDate,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      if (effectiveTime.isNotEmpty) ...[
                        Container(
                          width: 3,
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
                          decoration: BoxDecoration(
                            color: context.ext.textLight,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Icon(SolarIconsOutline.clockCircle,
                            size: AppIconSize.s, color: context.ext.textLight, semanticLabel: 'Time'),
                        const SizedBox(width: AppSpacing.xsm),
                        Text(
                          effectiveTime,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // LOCATION (tour only)
                  if (!_isTransport && item.tourPointCity.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(SolarIconsOutline.mapPoint,
                            size: AppIconSize.s, color: context.ext.textLight, semanticLabel: 'Location'),
                        const SizedBox(width: AppSpacing.xsm),
                        Flexible(
                          child: Text(
                            item.tourPointCity,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: AppSpacing.ml),

                  // PRICE + DETAILS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency(item.totalPrice),
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.colors.secondary,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'booking_details'.tr(),
                            style: AppTextStyles.labelMedium.copyWith(
                              color: context.colors.primary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Icon(SolarIconsOutline.arrowRight,
                              size: AppIconSize.m, color: context.colors.primary),
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
      ),
    );
  }

  Widget _countdownBadge(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.ms, vertical: AppSpacing.xsm),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.small),
        boxShadow: AppElevation.shadowSm,
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: context.colors.secondary,
        ),
      ),
    );
  }

  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.ms, vertical: AppSpacing.xsm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _tourImage(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final screenWidth = MediaQuery.of(context).size.width;
    final targetWidth = ((screenWidth - 40) * dpr).round();

    return Semantics(
      image: true,
      label: item.tourPointName,
      child: CachedNetworkImage(
        imageUrl: item.image,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        memCacheWidth: targetWidth,
        fadeInDuration: const Duration(milliseconds: 150),
        placeholder: (_, __) => Container(
          height: 160,
          color: context.colors.surfaceContainerHighest,
        ),
        errorWidget: (_, __, ___) => Container(
          height: 160,
          color: context.colors.surfaceContainerHighest,
          child: Center(
            child: Icon(SolarIconsOutline.galleryRemove,
                size: AppIconSize.xxlm, color: context.ext.textLight, semanticLabel: 'Image not available'),
          ),
        ),
      ),
    );
  }
}
