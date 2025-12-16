import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/bottom_action_bar.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/widgets/section_title.dart';
import 'package:tour_booking/features/detailed_search/flow/tour_search_detail_viewmodel.dart';
import 'package:tour_booking/models/guide/guide.dart';
import 'package:tour_booking/models/vehicle/vehicle.dart';
import 'package:tour_booking/models/vehicle_detail/vehicle_detail.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TourSearchDetailViewModel>(
      builder: (context, vm, _) {
        final selectedVehicle = _getSelectedVehicle(vm);
        final vehicleDetail = vm.vehicle;
        final selectedGuide = _getSelectedGuide(vm);

        final date = vm.selectedDate;

        final vehiclePrice =
            vm.setVehiclePrice ??
            selectedVehicle?.price ??
            vehicleDetail?.price;

        final guidePrice = selectedGuide?.price;
        final totalPrice = (vehiclePrice ?? 0) + (guidePrice ?? 0);

        final canConfirm = date != null && selectedVehicle != null;

        return Scaffold(
          appBar: const CommonAppBar(title: "Seyahat Özeti"),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(title: "Seyahat Bilgileri"),
                const SizedBox(height: 12),

                _summaryCard(
                  headerImage: vm.tourpointImage,
                  children: [
                    _infoRow("Tarih", _formatDate(date, vm.selectedTime)),
                    _infoRow("Kalkış Bölgesi", vm.selectedCityName ?? "—"),
                    _infoRow("İlçe", vm.selectedDistrictName ?? "—"),
                    _infoRowMultiline("Tam Konum", vm.selectedPlaceDesc ?? "—"),
                    _infoRow("Tur Noktası", vm.selectedTourPointName ?? "—"),
                  ],
                ),

                const SizedBox(height: 28),

                SectionTitle(title: "Araç Bilgisi"),
                const SizedBox(height: 12),

                _summaryCard(
                  headerImage: selectedVehicle?.image,
                  children: [
                    _infoRow(
                      "Araç",
                      _vehicleTitle(selectedVehicle, vehicleDetail),
                    ),
                    _infoRow("Sınıf", vehicleDetail?.vehicleClass ?? "—"),
                    _infoRow("Tip", vehicleDetail?.vehicleType ?? "—"),
                    _infoRow("Koltuk", "${vehicleDetail?.seatCount ?? "-"}"),
                    _infoRow("Ücret", _formatCurrency(vehiclePrice)),
                  ],
                ),

                if (selectedGuide != null) ...[
                  const SizedBox(height: 28),
                  SectionTitle(title: "Rehber Bilgisi"),
                  const SizedBox(height: 12),

                  _summaryCard(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.border,
                            backgroundImage: selectedGuide.image != null
                                ? NetworkImage(selectedGuide.image!)
                                : null,
                            child: selectedGuide.image == null
                                ? const Icon(
                                    Icons.person,
                                    color: AppColors.textLight,
                                    size: 28,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              "${selectedGuide.firstName} ${selectedGuide.lastName}",
                              style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _infoRow("Diller", selectedGuide.languages.join(", ")),
                      _infoRow("Rehber Ücreti", _formatCurrency(guidePrice)),
                    ],
                  ),
                ],

                const SizedBox(height: 28),

                SectionTitle(title: "Ödeme Özeti"),
                const SizedBox(height: 12),

                _paymentCard(
                  totalPrice: totalPrice.toInt(),
                  vehiclePrice: vehiclePrice,
                  guidePrice: guidePrice,
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomActionBar(
            price: totalPrice.toInt(),
            buttonText: "Onayla",
            onPressed: canConfirm
                ? () async {
                    await vm.ControlBooking();
                    if (vm.isValid && vm.bookingId != null) {
                      context.push("/payment", extra: vm.bookingId);
                    } else if (vm.errorMessage != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(vm.errorMessage!)));
                    }
                  }
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Bir hata oluştu, lütfen tekrar deneyin.",
                        ),
                      ),
                    );
                  },
          ),
        );
      },
    );
  }

  // ===========================================================================
  // SUMMARY CARD
  // ===========================================================================
  Widget _summaryCard({String? headerImage, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          if (headerImage != null && headerImage.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: headerImage,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.border),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.border,
                    child: const Icon(
                      Icons.broken_image,
                      color: AppColors.textLight,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyMedium.copyWith(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRowMultiline(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyMedium.copyWith(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentCard({
    required int totalPrice,
    num? vehiclePrice,
    num? guidePrice,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          _paymentRow("Araç", _formatCurrency(vehiclePrice)),
          _paymentRow("Rehber", _formatCurrency(guidePrice)),
          const Divider(color: Colors.white54),
          _paymentRow(
            "Toplam",
            _formatCurrency(totalPrice),
            big: true,
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _paymentRow(
    String label,
    String value, {
    bool bold = false,
    bool big = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: big ? 18 : 14,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: big ? 20 : 15,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================
  Vehicle? _getSelectedVehicle(TourSearchDetailViewModel vm) {
    final id = vm.selectedVehicleId;
    return id == null
        ? null
        : vm.vehicles.firstWhereOrNull((v) => v.vehicleId == id);
  }

  Guide? _getSelectedGuide(TourSearchDetailViewModel vm) {
    final id = vm.selectedGuideId;
    return id == null
        ? null
        : vm.guides.firstWhereOrNull((g) => g.guideId == id);
  }

  String _vehicleTitle(Vehicle? v, VehicleDetail? d) {
    return [
      d?.vehicleBrand ?? v?.vehicleBrand,
      d?.vehicleClass ?? v?.vehicleClass,
    ].whereType<String>().join(" • ");
  }

  String _formatDate(DateTime? date, String? time) {
    if (date == null) return "—";
    final df = DateFormat("d MMMM yyyy, EEEE", "tr_TR");
    return "${df.format(date)} ${time ?? ""}";
  }

  String _formatCurrency(num? v) {
    if (v == null) return "—";
    final f = NumberFormat.currency(
      locale: "tr_TR",
      symbol: "₺",
      decimalDigits: 0,
    );
    return f.format(v);
  }
}
