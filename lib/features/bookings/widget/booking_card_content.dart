import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/bookings/utils/booking_utils.dart';
import 'package:tour_booking/features/bookings/widget/cancel_booking_dialog.dart';
import 'package:tour_booking/features/bookings/widget/rating_dialog.dart';
import 'package:tour_booking/models/booking/booking_dto.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

/// Shows booking detail bottom sheet.
Future<void> showBookingDetailSheet(
  BuildContext context, {
  required BookingDto item,
  required Future<void> Function(String) onCancel,
  VoidCallback? onRated,
  VoidCallback? onCancelled,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) => _BookingDetailSheet(
        item: item,
        onCancel: onCancel,
        onRated: onRated,
        onCancelled: onCancelled,
        scrollController: scrollController,
      ),
    ),
  );
}

class _BookingDetailSheet extends StatefulWidget {
  final BookingDto item;
  final Future<void> Function(String) onCancel;
  final VoidCallback? onRated;
  final VoidCallback? onCancelled;
  final ScrollController scrollController;

  const _BookingDetailSheet({
    required this.item,
    required this.onCancel,
    this.onRated,
    this.onCancelled,
    required this.scrollController,
  });

  @override
  State<_BookingDetailSheet> createState() => _BookingDetailSheetState();
}

class _BookingDetailSheetState extends State<_BookingDetailSheet> {
  bool _isCancelling = false;
  late bool _canRate;

  @override
  void initState() {
    super.initState();
    _canRate = widget.item.canRate == true;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isTransport = item.bookingType == 1;
    final departureDate = item.departureDate.isNotEmpty
        ? DateTime.parse(item.departureDate)
        : DateTime.now();
    final statusColor = bookingStatusColor(context, item.status);
    final statusText = bookingStatusLabel(item.status, departureDate);
    final effectiveTime = isTransport
        ? (item.pickupTime ?? item.departureTime)
        : item.departureTime;
    final formattedDate =
        DateFormat('dd MMMM yyyy', 'tr_TR').format(departureDate);
    final canCancel = isCancelableStatus(item.status);
    final canCancelByTime = canCancelWithTimeLimit(
      item.departureDate,
      effectiveTime,
    );
    final isCompleted = item.status.toLowerCase() == "completed";

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      child: ListView(
        controller: widget.scrollController,
        padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xxl),
        children: [
          // DRAG HANDLE
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.m, bottom: AppSpacing.m),
              child: Container(
                width: AppSpacing.xxxxl,
                height: AppSpacing.xs,
                decoration: BoxDecoration(
                  color: context.colors.outline,
                  borderRadius: BorderRadius.circular(AppSpacing.xxs),
                ),
              ),
            ),
          ),

          // IMAGE (only tours with image)
          if (!isTransport && item.image.isNotEmpty) ...[
            _tourImageBanner(context),
            const SizedBox(height: AppSpacing.l),
          ],

          // TITLE + STATUS
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  isTransport ? tr('transport_title') : item.tourPointName,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.ms, vertical: AppSpacing.xsm),
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
            color: context.colors.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.l),

          // INFO ROWS
          if (isTransport) ...[
            _infoRow(SolarIconsOutline.mapPoint, 'transport_pickup'.tr(),
                item.pickupAddress ?? '-'),
            _infoRow(SolarIconsOutline.mapPointWave, 'transport_dropoff'.tr(),
                item.dropoffAddress ?? '-'),
            if (item.distanceKm != null)
              _infoRow(SolarIconsOutline.ruler, 'transport_distance'.tr(),
                  '${item.distanceKm!.toStringAsFixed(1)} km'),
            _infoRow(SolarIconsOutline.calendarDate, 'booking_label_time'.tr(),
                '$formattedDate • $effectiveTime'),
            _infoRow(
                SolarIconsOutline.user, 'booking_label_driver'.tr(), item.driverName),
          ] else ...[
            _infoRow(SolarIconsOutline.mapPoint, 'booking_label_departure_location'.tr(),
                item.departureLocationDescription),
            _infoRow(SolarIconsOutline.calendarDate, 'booking_label_time'.tr(),
                '$formattedDate • ${item.departureTime}'),
            _infoRow(SolarIconsOutline.routing, 'booking_label_vehicle'.tr(),
                tr('booking_vehicle_seats', namedArgs: {'brand': item.vehicleBrand, 'seats': item.seatCount.toString()})),
            _infoRow(
                SolarIconsOutline.user, 'booking_label_driver'.tr(), item.driverName),
          ],

          const SizedBox(height: AppSpacing.l),

          // PRICE ROW
          Container(
            padding: const EdgeInsets.all(AppSpacing.ml),
            decoration: BoxDecoration(
              color: context.colors.secondary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(
                color: context.colors.secondary.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'booking_total_price'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: context.colors.onSurface,
                  ),
                ),
                Text(
                  formatCurrency(item.totalPrice),
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colors.secondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.l),

          // ACTIONS
          if (isCompleted && _canRate) _rateButton(),
          if (isCompleted && !_canRate) _ratedBadge(),
          if (canCancel && canCancelByTime) _cancelButton(),
          if (canCancel && !canCancelByTime) _cancelNotAllowedInfo(),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
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
            child: Icon(icon, size: AppIconSize.ml, color: context.colors.onSurfaceVariant),
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

  Widget _tourImageBanner(BuildContext context) {
    if (widget.item.image.isEmpty) {
      return Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Center(
          child:
              Icon(SolarIconsOutline.galleryRemove, size: AppIconSize.xxxl, color: context.ext.textLight, semanticLabel: 'Image not available'),
        ),
      );
    }

    return Semantics(
      image: true,
      label: widget.item.tourPointName,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: CachedNetworkImage(
          imageUrl: widget.item.image,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 150),
          placeholder: (_, __) => Container(
            height: 180,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
          ),
          errorWidget: (_, __, ___) => Container(
            height: 180,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
            child: Center(
              child: Icon(SolarIconsOutline.galleryRemove,
                  size: AppIconSize.xxxl, color: context.ext.textLight, semanticLabel: 'Image not available'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _rateButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _handleRate,
        icon: const Icon(Icons.star_rounded, size: AppIconSize.l, semanticLabel: 'Rate'),
        label: Text('booking_rate'.tr()),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: context.colors.secondary,
          foregroundColor: context.colors.onSecondary,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _ratedBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
      decoration: BoxDecoration(
        color: context.ext.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(SolarIconsOutline.checkCircle, size: AppIconSize.ml, color: context.ext.success, semanticLabel: 'Rated'),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'booking_rated'.tr(),
            style: AppTextStyles.labelLarge.copyWith(
              color: context.ext.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cancelButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: _isCancelling ? null : _handleCancel,
        style: OutlinedButton.styleFrom(
          foregroundColor: context.colors.error,
          side: BorderSide(color: context.colors.error.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        child: _isCancelling
            ? SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.colors.error,
                ),
              )
            : Text('booking_cancel_request'.tr()),
      ),
    );
  }

  Widget _cancelNotAllowedInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.m, horizontal: AppSpacing.ml),
      decoration: BoxDecoration(
        color: context.ext.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: context.ext.warning.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(SolarIconsOutline.infoCircle, size: AppIconSize.ml, color: context.ext.warning, semanticLabel: 'Information'),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              'booking_cancel_time_limit'.tr(),
              style: AppTextStyles.labelMedium.copyWith(
                color: context.ext.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRate() async {
    if (widget.item.ratingToken == null) return;

    final rated = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RatingDialog(token: widget.item.ratingToken!),
    );

    if (rated == true && mounted) {
      setState(() => _canRate = false);
      widget.onRated?.call();
    }
  }

  Future<void> _handleCancel() async {
    final confirmed = await showCancelBookingDialog(context);
    if (confirmed != true) return;

    setState(() => _isCancelling = true);
    try {
      await widget.onCancel(widget.item.id);
      if (mounted) {
        Navigator.pop(context);
        widget.onCancelled?.call();
      }
    } finally {
      if (mounted) setState(() => _isCancelling = false);
    }
  }
}
