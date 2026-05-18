import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/bottom_action_bar.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/tour/booking/tour_detail_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_booking_selection_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_vehicle_guide_viewmodel.dart';
import 'package:tour_booking/models/guide/guide.dart';
import 'package:tour_booking/models/vehicle/vehicle.dart';
import 'package:tour_booking/models/vehicle_detail/vehicle_detail.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final detailVm = context.watch<TourDetailViewModel>();
    final selectionVm = context.watch<TourBookingSelectionViewModel>();
    final vehicleGuideVm = context.watch<TourVehicleGuideViewModel>();

    final selectedVehicle = _getSelectedVehicle(vehicleGuideVm);
    final vehicleDetail = vehicleGuideVm.vehicle;
    final selectedGuide = _getSelectedGuide(vehicleGuideVm);

    final date = selectionVm.selectedDate;

    final vehiclePrice =
        vehicleGuideVm.vehiclePrice ??
        selectedVehicle?.price ??
        vehicleDetail?.price;

    final guidePrice = selectedGuide?.price;
    final totalPrice = (vehiclePrice ?? 0) + (guidePrice ?? 0);

    final canConfirm = date != null && selectedVehicle != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(title: tr('summary_title')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.l),
        children: [
          // ── Trip Info ──
          _sectionLabel(tr('summary_trip_info')),
          const SizedBox(height: 10),
          _card(
            headerImage: detailVm.tourpointImage,
            children: [
              _row(tr('summary_date'),
                  _formatDate(date, selectionVm.selectedTime)),
              _row(tr('summary_departure_city'),
                  detailVm.selectedCityName ?? "\u2014"),
              _row(tr('summary_district'),
                  detailVm.selectedDistrictName ?? "\u2014"),
              _row(tr('summary_exact_location'),
                  selectionVm.selectedPlaceDesc ?? "\u2014",
                  multiline: true),
              _row(tr('summary_tour_point'),
                  detailVm.selectedTourPointName ?? "\u2014"),
            ],
          ),

          const SizedBox(height: 20),

          // ── Vehicle Info ──
          _sectionLabel(tr('summary_vehicle_info')),
          const SizedBox(height: 10),
          _card(
            headerImage: selectedVehicle?.image,
            children: [
              _row(tr('summary_vehicle'),
                  _vehicleTitle(selectedVehicle, vehicleDetail)),
              _row(tr('summary_vehicle_class'),
                  vehicleDetail?.vehicleClass ?? "\u2014"),
              _row(tr('summary_vehicle_type'),
                  vehicleDetail?.vehicleType ?? "\u2014"),
              _row(tr('summary_seat'),
                  "${vehicleDetail?.seatCount ?? "\u2014"}"),
              _row(tr('summary_price'), _formatCurrency(vehiclePrice)),
            ],
          ),

          // ── Guide Info ──
          if (selectedGuide != null) ...[
            const SizedBox(height: 20),
            _sectionLabel(tr('summary_guide_info')),
            const SizedBox(height: 10),
            _card(
              children: [
                // Guide avatar + name
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: selectedGuide.image != null
                          ? CachedNetworkImage(
                              imageUrl: selectedGuide.image!,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => _avatarPlaceholder(),
                              errorWidget: (_, __, ___) =>
                                  _avatarPlaceholder(),
                            )
                          : _avatarPlaceholder(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "${selectedGuide.firstName} ${selectedGuide.lastName}",
                        style: AppTextStyles.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _row(tr('summary_languages'),
                    selectedGuide.languages.join(", ")),
                _row(tr('summary_guide_price'),
                    _formatCurrency(guidePrice)),
              ],
            ),
          ],

          const SizedBox(height: 20),

          // ── Payment Summary ──
          _sectionLabel(tr('summary_payment_info')),
          const SizedBox(height: 10),
          _paymentCard(
            vehiclePrice: vehiclePrice,
            guidePrice: guidePrice,
            totalPrice: totalPrice,
          ),

          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        price: totalPrice,
        buttonText: tr("summary_confirm"),
        onPressed: canConfirm
            ? () {
                context.push('/checkout/contact-info', extra: 'tour');
              }
            : () {
                UIHelper.showError(context, tr("error_generic"));
              },
      ),
    );
  }

  // ─── Widgets ───────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.labelLarge.copyWith(fontSize: 13),
    );
  }

  Widget _card({String? headerImage, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          if (headerImage != null && headerImage.isNotEmpty)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(13)),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: headerImage,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 140,
                    color: AppColors.border.withValues(alpha: 0.3),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 140,
                    color: AppColors.border.withValues(alpha: 0.3),
                    child: const Icon(SolarIconsOutline.galleryRemove,
                        color: AppColors.textLight, size: 28),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment:
            multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textLight,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: multiline ? 3 : 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.border,
        shape: BoxShape.circle,
      ),
      child: const Icon(SolarIconsOutline.user, size: 20, color: AppColors.textLight),
    );
  }

  Widget _paymentCard({
    num? vehiclePrice,
    num? guidePrice,
    required num totalPrice,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _paymentRow(tr("summary_vehicle"), _formatCurrency(vehiclePrice)),
          if (guidePrice != null && guidePrice > 0)
            _paymentRow(
                tr("summary_guide_info"), _formatCurrency(guidePrice)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Divider(
              height: 1,
              color: AppColors.border,
            ),
          ),
          _paymentRow(
            tr("summary_total"),
            _formatCurrency(totalPrice),
            bold: true,
            accent: true,
          ),
        ],
      ),
    );
  }

  Widget _paymentRow(
    String label,
    String value, {
    bool bold = false,
    bool accent = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: bold ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: accent ? AppColors.accent : AppColors.textPrimary,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              fontSize: accent ? 15 : 13,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  Vehicle? _getSelectedVehicle(TourVehicleGuideViewModel vm) {
    final id = vm.selectedVehicleId;
    return id == null
        ? null
        : vm.vehicles.firstWhereOrNull((v) => v.vehicleId == id);
  }

  Guide? _getSelectedGuide(TourVehicleGuideViewModel vm) {
    final id = vm.selectedGuideId;
    return id == null
        ? null
        : vm.guides.firstWhereOrNull((g) => g.guideId == id);
  }

  String _vehicleTitle(Vehicle? v, VehicleDetail? d) {
    return [
      d?.vehicleBrand ?? v?.vehicleBrand,
      d?.vehicleClass ?? v?.vehicleClass,
    ].whereType<String>().join(" \u00B7 ");
  }

  String _formatDate(DateTime? date, String? time) {
    if (date == null) return "\u2014";
    final df = DateFormat("d MMMM yyyy, EEEE", "tr_TR");
    return "${df.format(date)} ${time ?? ""}";
  }

  String _formatCurrency(num? v) {
    if (v == null) return "\u2014";
    return NumberFormat.currency(
      locale: "tr_TR",
      symbol: "\u20BA",
      decimalDigits: 2,
    ).format(v);
  }
}
