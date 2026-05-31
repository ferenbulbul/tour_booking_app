import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
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
      backgroundColor: context.colors.surfaceContainerHighest,
      appBar: CommonAppBar(title: tr('summary_title')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.l),
        children: [
          // -- Trip Info --
          _sectionLabel(tr('summary_trip_info')),
          const SizedBox(height: AppSpacing.ms),
          _card(
            context: context,
            headerImage: detailVm.tourPointImage,
            children: [
              _row(context, tr('summary_date'),
                  _formatDate(context, date, selectionVm.selectedTime)),
              _row(context, tr('summary_departure_city'),
                  detailVm.selectedCityName ?? "\u2014"),
              _row(context, tr('summary_district'),
                  detailVm.selectedDistrictName ?? "\u2014"),
              _row(context, tr('summary_exact_location'),
                  selectionVm.selectedPlaceDesc ?? "\u2014",
                  multiline: true),
              _row(context, tr('summary_tour_point'),
                  detailVm.selectedTourPointName ?? "\u2014"),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // -- Vehicle Info --
          _sectionLabel(tr('summary_vehicle_info')),
          const SizedBox(height: AppSpacing.ms),
          _card(
            context: context,
            headerImage: selectedVehicle?.image,
            children: [
              _row(context, tr('summary_vehicle'),
                  _vehicleTitle(selectedVehicle, vehicleDetail)),
              _row(context, tr('summary_vehicle_class'),
                  vehicleDetail?.vehicleClass ?? "\u2014"),
              _row(context, tr('summary_vehicle_type'),
                  vehicleDetail?.vehicleType ?? "\u2014"),
              _row(context, tr('summary_seat'),
                  "${vehicleDetail?.seatCount ?? "\u2014"}"),
              _row(context, tr('summary_price'), _formatCurrency(vehiclePrice)),
            ],
          ),

          // -- Guide Info --
          if (selectedGuide != null) ...[
            const SizedBox(height: AppSpacing.xl),
            _sectionLabel(tr('summary_guide_info')),
            const SizedBox(height: AppSpacing.ms),
            _card(
              context: context,
              children: [
                // Guide avatar + name
                Row(
                  children: [
                    Semantics(
                      image: true,
                      label: 'Profile photo',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.xxl),
                        child: selectedGuide.image != null
                            ? CachedNetworkImage(
                                imageUrl: selectedGuide.image!,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => _avatarPlaceholder(context),
                                errorWidget: (_, __, ___) =>
                                    _avatarPlaceholder(context),
                              )
                            : _avatarPlaceholder(context),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
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
                const SizedBox(height: AppSpacing.m),
                _row(context, tr('summary_languages'),
                    selectedGuide.languages.join(", ")),
                _row(context, tr('summary_guide_price'),
                    _formatCurrency(guidePrice)),
              ],
            ),
          ],

          const SizedBox(height: AppSpacing.xl),

          // -- Payment Summary --
          _sectionLabel(tr('summary_payment_info')),
          const SizedBox(height: AppSpacing.ms),
          _paymentCard(
            context: context,
            vehiclePrice: vehiclePrice,
            guidePrice: guidePrice,
            totalPrice: totalPrice,
          ),

          const SizedBox(height: AppSpacing.xl),
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

  // --- Widgets ---

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.titleSmall,
    );
  }

  Widget _card({required BuildContext context, String? headerImage, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.ml),
        border: Border.all(color: context.colors.outline),
      ),
      child: Column(
        children: [
          if (headerImage != null && headerImage.isNotEmpty)
            Semantics(
              image: true,
              excludeSemantics: true,
              label: 'Photo',
              child: ClipRRect(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(AppRadius.medium)),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: headerImage,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 140,
                      color: context.colors.outline.withValues(alpha: 0.3),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 140,
                      color: context.colors.outline.withValues(alpha: 0.3),
                      child: Icon(SolarIconsOutline.galleryRemove,
                          color: context.ext.textLight, size: AppIconSize.xxl, semanticLabel: 'Image not available'),
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.ml),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value, {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment:
            multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.ext.textLight,
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: multiline ? 3 : 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarPlaceholder(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: context.colors.outline,
        shape: BoxShape.circle,
      ),
      child: Icon(SolarIconsOutline.user, size: AppIconSize.l, color: context.ext.textLight, semanticLabel: 'Person'),
    );
  }

  Widget _paymentCard({
    required BuildContext context,
    num? vehiclePrice,
    num? guidePrice,
    required num totalPrice,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.ml),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.ml),
        border: Border.all(color: context.colors.outline),
      ),
      child: Column(
        children: [
          _paymentRow(context, tr("summary_vehicle"), _formatCurrency(vehiclePrice)),
          if (guidePrice != null && guidePrice > 0)
            _paymentRow(context,
                tr("summary_guide_info"), _formatCurrency(guidePrice)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(
              height: 1,
              color: context.colors.outline,
            ),
          ),
          _paymentRow(
            context,
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
    BuildContext context,
    String label,
    String value, {
    bool bold = false,
    bool accent = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: bold ? context.colors.onSurface : context.colors.onSurfaceVariant,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: (accent ? AppTextStyles.titleSmall : AppTextStyles.bodyMedium).copyWith(
              color: accent ? context.colors.secondary : context.colors.onSurface,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // --- Helpers ---

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

  String _formatDate(BuildContext context, DateTime? date, String? time) {
    if (date == null) return "\u2014";
    final df = DateFormat("d MMMM yyyy, EEEE", context.locale.toString());
    return "${df.format(date)} ${time ?? ""}";
  }

  String _formatCurrency(num? v) {
    if (v == null) return "\u2014";
    return NumberFormat.currency(
      locale: "tr",
      symbol: "\u20BA",
      decimalDigits: 2,
    ).format(v);
  }
}
