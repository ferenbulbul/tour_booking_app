import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/bookings/utils/booking_utils.dart';
import 'package:tour_booking/models/booking/booking_dto.dart';

/// Compact tile for past bookings (completed + cancelled).
class PastBookingTile extends StatelessWidget {
  final BookingDto item;
  final VoidCallback onTap;

  const PastBookingTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTransport = item.bookingType == 1;
    final departureDate = item.departureDate.isNotEmpty
        ? DateTime.parse(item.departureDate)
        : DateTime.now();
    final statusColor = bookingStatusColor(item.status);
    final statusText = bookingStatusLabel(item.status, departureDate);
    final formattedDate =
        DateFormat('dd MMM yyyy', 'tr_TR').format(departureDate);
    final isCancelled = item.status.toLowerCase() == "cancelled";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            // THUMBNAIL
            _buildThumbnail(isTransport, isCancelled),
            const SizedBox(width: 12),

            // INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    isTransport ? 'Transfer' : item.tourPointName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isCancelled
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // DATE
                  Text(
                    formattedDate,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // PRICE + STATUS
                  Row(
                    children: [
                      Text(
                        formatCurrency(item.totalPrice),
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: isCancelled
                              ? AppColors.textLight
                              : AppColors.accent,
                          decoration: isCancelled
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusText,
                          style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // CHEVRON
            const Icon(
              SolarIconsOutline.arrowRight,
              size: 16,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(bool isTransport, bool isCancelled) {
    if (isTransport) {
      return Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: (isCancelled ? AppColors.textLight : AppColors.primary)
              .withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          SolarIconsOutline.routing,
          color: isCancelled ? AppColors.textLight : AppColors.primary,
          size: 22,
        ),
      );
    }

    if (item.image.isEmpty) {
      return Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          SolarIconsOutline.galleryRemove,
          color: AppColors.textLight,
          size: 18,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 52,
        height: 52,
        child: Opacity(
          opacity: isCancelled ? 0.5 : 1.0,
          child: CachedNetworkImage(
            imageUrl: item.image,
            fit: BoxFit.cover,
            memCacheWidth: 150,
            placeholder: (_, __) => Container(color: AppColors.background),
            errorWidget: (_, __, ___) => Container(
              color: AppColors.background,
              child: const Icon(
                SolarIconsOutline.galleryRemove,
                color: AppColors.textLight,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
