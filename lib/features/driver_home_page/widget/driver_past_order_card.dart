import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/bookings/utils/booking_utils.dart';
import 'package:tour_booking/features/driver_home_page/widget/driver_past_order_detail_sheet.dart';
import 'package:tour_booking/models/driver_past_booking/driver_past_booking.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class DriverPastOrderCard extends StatelessWidget {
  const DriverPastOrderCard({super.key, required this.item});

  final DriverPastBooking item;

  bool get _isTransport => item.bookingType == 1;
  bool get _isCancelled => item.status.toLowerCase() == 'cancelled';

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    final rawDate = item.departureDate;
    final departureDate = rawDate.isNotEmpty
        ? DateTime.tryParse(rawDate)
        : null;
    final formattedDate = departureDate != null
        ? DateFormat('dd MMM yyyy', 'tr_TR').format(departureDate)
        : rawDate.isNotEmpty
            ? rawDate
            : '-';

    final statusColor = bookingStatusColor(context, item.status);
    final statusText = bookingStatusLabel(
        item.status, departureDate ?? DateTime.now());

    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.ml),
      child: InkWell(
        onTap: () => showDriverPastOrderDetailSheet(context, item: item),
        borderRadius: BorderRadius.circular(AppRadius.ml),
        child: Container(
      padding: const EdgeInsets.all(AppSpacing.ml),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.ml),
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.4),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW: thumbnail + info + status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (_isCancelled
                          ? context.ext.textLight
                          : scheme.primary)
                      .withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Icon(
                  _isTransport
                      ? SolarIconsOutline.routing
                      : SolarIconsOutline.map,
                  color: _isCancelled
                      ? context.ext.textLight
                      : scheme.primary,
                  size: AppIconSize.lm,
                ),
              ),
              const SizedBox(width: AppSpacing.m),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      _isTransport
                          ? tr('transport_title')
                          : item.tourPointName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: _isCancelled
                            ? scheme.onSurfaceVariant
                            : scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Date + time
                    Row(
                      children: [
                        Icon(
                          SolarIconsOutline.calendarDate,
                          size: AppIconSize.s,
                          color: context.ext.textLight,
                        ),
                        const SizedBox(width: AppSpacing.xsm),
                        Text(
                          formattedDate,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: context.ext.textLight,
                          ),
                        ),
                        if (item.departureTime.isNotEmpty) ...[
                          Container(
                            width: 3,
                            height: 3,
                            margin: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.s),
                            decoration: BoxDecoration(
                              color: context.ext.textLight,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Icon(
                            SolarIconsOutline.clockCircle,
                            size: AppIconSize.s,
                            color: context.ext.textLight,
                          ),
                          const SizedBox(width: AppSpacing.xsm),
                          Text(
                            item.departureTime,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: context.ext.textLight,
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

          // CUSTOMER + ROUTE
          Padding(
            padding: const EdgeInsets.only(
              left: 48 + AppSpacing.m,
              top: AppSpacing.s,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer
                Row(
                  children: [
                    Icon(
                      SolarIconsOutline.user,
                      size: AppIconSize.s,
                      color: context.ext.textLight,
                    ),
                    const SizedBox(width: AppSpacing.xsm),
                    Flexible(
                      child: Text(
                        item.customerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),

                // Transport route
                if (_isTransport &&
                    item.pickupAddress != null &&
                    item.dropoffAddress != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        SolarIconsOutline.route,
                        size: AppIconSize.s,
                        color: context.ext.textLight,
                      ),
                      const SizedBox(width: AppSpacing.xsm),
                      Flexible(
                        child: Text(
                          '${item.pickupAddress} → ${item.dropoffAddress}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.ms),

          // DIVIDER
          Divider(
            height: 1,
            color: scheme.outline.withValues(alpha: 0.12),
          ),

          const SizedBox(height: AppSpacing.ms),

          // BOTTOM ROW: status + rating
          Row(
            children: [
              // Rating badge
              if (item.rating != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s,
                    vertical: AppSpacing.xxxs,
                  ),
                  decoration: BoxDecoration(
                    color: context.ext.star.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: context.ext.star,
                      ),
                      const SizedBox(width: AppSpacing.xxxs),
                      Text(
                        item.rating!.toStringAsFixed(1),
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.ext.star,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
              ],

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s,
                  vertical: AppSpacing.xxxs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: Text(
                  statusText,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),

              const Spacer(),

              Icon(
                SolarIconsOutline.altArrowRight,
                size: AppIconSize.ml,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),

          // Rating comment
          if (item.ratingComment != null &&
              item.ratingComment!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s),
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xxs),
              child: Row(
                children: [
                  Icon(
                    SolarIconsOutline.chatRound,
                    size: AppIconSize.s,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xsm),
                  Flexible(
                    child: Text(
                      '"${item.ratingComment}"',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontStyle: FontStyle.italic,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
      ),
    );
  }
}
