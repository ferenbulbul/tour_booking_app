import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/bookings/utils/booking_utils.dart';
import 'package:tour_booking/models/booking/booking_dto.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

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
    final statusColor = bookingStatusColor(context, item.status);
    final statusText = bookingStatusLabel(item.status, departureDate);
    final formattedDate =
        DateFormat('dd MMM yyyy', 'tr_TR').format(departureDate);
    final isCancelled = item.status.toLowerCase() == "cancelled";

    return Semantics(
      button: true,
      label: item.tourPointName,
      child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.ml),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.ml),
          border: Border.all(
            color: context.colors.outline.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            // THUMBNAIL
            _buildThumbnail(context, isTransport, isCancelled),
            const SizedBox(width: AppSpacing.m),

            // INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    isTransport ? tr('transport_title') : item.tourPointName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: isCancelled
                          ? context.colors.onSurfaceVariant
                          : context.colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // DATE
                  Text(
                    formattedDate,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: context.ext.textLight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // PRICE + STATUS
                  Row(
                    children: [
                      Text(
                        formatCurrency(item.totalPrice),
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isCancelled
                              ? context.ext.textLight
                              : context.colors.secondary,
                          decoration: isCancelled
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s, vertical: AppSpacing.xxxs),
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
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.s),

            // CHEVRON
            Icon(
              SolarIconsOutline.arrowRight,
              size: AppIconSize.m,
              color: context.ext.textLight,
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildThumbnail(BuildContext context, bool isTransport, bool isCancelled) {
    if (isTransport) {
      return Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: (isCancelled ? context.ext.textLight : context.colors.primary)
              .withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Icon(
          SolarIconsOutline.routing,
          color: isCancelled ? context.ext.textLight : context.colors.primary,
          size: AppIconSize.lm,
          semanticLabel: 'Transport',
        ),
      );
    }

    if (item.image.isEmpty) {
      return Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Icon(
          SolarIconsOutline.galleryRemove,
          color: context.ext.textLight,
          size: AppIconSize.ml,
          semanticLabel: 'Image not available',
        ),
      );
    }

    return Semantics(
      image: true,
      label: item.tourPointName,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: SizedBox(
          width: 52,
          height: 52,
          child: Opacity(
            opacity: isCancelled ? 0.5 : 1.0,
            child: CachedNetworkImage(
              imageUrl: item.image,
              fit: BoxFit.cover,
              memCacheWidth: 150,
              placeholder: (_, __) => Container(color: context.colors.surfaceContainerHighest),
              errorWidget: (_, __, ___) => Container(
                color: context.colors.surfaceContainerHighest,
                child: Icon(
                  SolarIconsOutline.galleryRemove,
                  color: context.ext.textLight,
                  size: AppIconSize.ml,
                  semanticLabel: 'Image not available',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
