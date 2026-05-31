import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/features/bookings/utils/booking_utils.dart';
import 'package:tour_booking/models/driver_past_booking/driver_past_booking.dart';

Future<void> showDriverPastOrderDetailSheet(
  BuildContext context, {
  required DriverPastBooking item,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      builder: (context, scrollController) => _DriverPastOrderDetailSheet(
        item: item,
        scrollController: scrollController,
      ),
    ),
  );
}

class _DriverPastOrderDetailSheet extends StatelessWidget {
  const _DriverPastOrderDetailSheet({
    required this.item,
    required this.scrollController,
  });

  final DriverPastBooking item;
  final ScrollController scrollController;

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

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xxl),
        children: [
          // DRAG HANDLE
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: AppSpacing.m, bottom: AppSpacing.m),
              child: Container(
                width: AppSpacing.xxxxl,
                height: AppSpacing.xs,
                decoration: BoxDecoration(
                  color: scheme.outline,
                  borderRadius: BorderRadius.circular(AppSpacing.xxs),
                ),
              ),
            ),
          ),

          // HEADER: icon + title + status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  color:
                      _isCancelled ? context.ext.textLight : scheme.primary,
                  size: AppIconSize.lm,
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Text(
                  _isTransport
                      ? tr('transport_title')
                      : item.tourPointName,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.ms,
                  vertical: AppSpacing.xsm,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: Text(
                  statusText,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // DIVIDER
          Divider(
            height: 1,
            color: scheme.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.l),

          // INFO ROWS
          _infoRow(
            context,
            SolarIconsOutline.calendarDate,
            tr('booking_label_time'),
            item.departureTime.isNotEmpty
                ? '$formattedDate  •  ${item.departureTime}'
                : formattedDate,
          ),
          _infoRow(
            context,
            SolarIconsOutline.user,
            tr('driver_customer'),
            item.customerName,
          ),

          if (_isTransport) ...[
            _infoRow(
              context,
              SolarIconsOutline.mapPoint,
              tr('transport_pickup'),
              item.pickupAddress ?? '-',
            ),
            _infoRow(
              context,
              SolarIconsOutline.mapPointWave,
              tr('transport_dropoff'),
              item.dropoffAddress ?? '-',
            ),
          ] else
            _infoRow(
              context,
              SolarIconsOutline.mapPoint,
              tr('booking_label_departure_location'),
              item.tourPointName,
            ),

          const SizedBox(height: AppSpacing.l),

          // RATING SECTION
          if (item.rating != null)
            _ratingSection(context)
          else
            _noRatingMessage(context),
        ],
      ),
    );
  }

  Widget _infoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.ml),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppIconSize.xxxl,
            height: AppIconSize.xxxl,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.ms),
            ),
            child: Icon(icon,
                size: AppIconSize.ml,
                color: context.colors.onSurfaceVariant),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: context.ext.textLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  value,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: context.colors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.ml),
      decoration: BoxDecoration(
        color: context.ext.warning.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: context.ext.warning.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...List.generate(5, (i) {
                return Icon(
                  i < item.rating!.round()
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: AppIconSize.l,
                  color: context.ext.warning,
                );
              }),
              const SizedBox(width: AppSpacing.s),
              Text(
                item.rating!.toStringAsFixed(1),
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.ext.warning,
                ),
              ),
            ],
          ),
          if (item.ratingComment != null &&
              item.ratingComment!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.ms),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  SolarIconsOutline.chatRound,
                  size: AppIconSize.s,
                  color: context.colors.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xsm),
                Flexible(
                  child: Text(
                    '"${item.ratingComment}"',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontStyle: FontStyle.italic,
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _noRatingMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
      decoration: BoxDecoration(
        color:
            context.colors.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            SolarIconsOutline.starFallMinimalistic2,
            size: AppIconSize.ml,
            color: context.ext.textLight,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            tr('driver_no_rating_yet'),
            style: AppTextStyles.labelLarge.copyWith(
              color: context.ext.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
