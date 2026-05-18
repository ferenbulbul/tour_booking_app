import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/bookings/utils/booking_utils.dart';
import 'package:tour_booking/features/bookings/widget/cancel_booking_dialog.dart';
import 'package:tour_booking/features/bookings/widget/rating_dialog.dart';
import 'package:tour_booking/models/booking/booking_dto.dart';

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
    final statusColor = bookingStatusColor(item.status);
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
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView(
        controller: widget.scrollController,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          // DRAG HANDLE
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // IMAGE (only tours with image)
          if (!isTransport && item.image.isNotEmpty) ...[
            _tourImageBanner(context),
            const SizedBox(height: 16),
          ],

          // TITLE + STATUS
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  isTransport ? 'Transfer' : item.tourPointName,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // DIVIDER
          Divider(
            height: 1,
            color: AppColors.border.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),

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
                '${item.vehicleBrand} • ${item.seatCount} kişilik'),
            _infoRow(
                SolarIconsOutline.user, 'booking_label_driver'.tr(), item.driverName),
          ],

          const SizedBox(height: 16),

          // PRICE ROW
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'booking_total_price'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  formatCurrency(item.totalPrice),
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

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
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 11,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 14,
                    color: AppColors.textPrimary,
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
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child:
              Icon(SolarIconsOutline.galleryRemove, size: 36, color: AppColors.textLight),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: widget.item.image,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 150),
        placeholder: (_, __) => Container(
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        errorWidget: (_, __, ___) => Container(
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Icon(SolarIconsOutline.galleryRemove,
                size: 36, color: AppColors.textLight),
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
        icon: const Icon(Icons.star_rounded, size: 20),
        label: Text('booking_rate'.tr()),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(SolarIconsOutline.checkCircle, size: 18, color: AppColors.success),
          const SizedBox(width: 6),
          Text(
            'booking_rated'.tr(),
            style: AppTextStyles.labelLarge.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
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
          foregroundColor: AppColors.error,
          side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
                  color: AppColors.error,
                ),
              )
            : Text('booking_cancel_request'.tr()),
      ),
    );
  }

  Widget _cancelNotAllowedInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(SolarIconsOutline.infoCircle, size: 18, color: AppColors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'booking_cancel_time_limit'.tr(),
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 13,
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
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
