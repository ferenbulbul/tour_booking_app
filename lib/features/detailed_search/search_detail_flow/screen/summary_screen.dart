import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/detailed_search/search_detail_flow/tour_search_detail_viewmodel.dart';
import 'package:tour_booking/models/guide/guide.dart';
import 'package:tour_booking/models/vehicle/vehicle.dart';
import 'package:tour_booking/models/vehicle_detail/vehicle_detail.dart';

/// A compact summary screen that reads all selections from
/// [TourSearchDetailViewModel] and presents a confirmation view.
///
/// It shows: date, city, district, tour point, vehicle, guide, prices and total.
///
/// NOTE:
/// - City/District/Tour Point names are not part of the provided models here.
///   The screen currently displays their *IDs*. Replace the `TODO` parts with
///   your display names if your models expose them (e.g., `name`, `title`).
/// - Vehicle price is taken in this order: `setViheclePrice` (if set) →
///   `selectedVehicle.price` → `vehicleDetail.price`.
/// - Guide price is taken from the selected guide (if any).
/// - The Confirm button is disabled unless date & vehicle are chosen.
class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TourSearchDetailViewModel>(
      builder: (context, vm, _) {
        final selectedVehicle = _getSelectedVehicle(vm);
        final vehicleDetail = vm.vehicle; // Could be null if not fetched
        final selectedGuide = _getSelectedGuide(vm);

        final DateTime? date = vm.selectedDate;

        final int? vehiclePrice = _pickVehiclePrice(
          vm,
          selectedVehicle,
          vehicleDetail,
        );
        final num? guidePrice = selectedGuide?.price;
        final num totalPrice = (vehiclePrice ?? 0) + (guidePrice ?? 0);

        final canConfirm = date != null && selectedVehicle != null;
        final String cityDisplay = vm.selectedCityName ?? 'Seçilmedi';
        final String districtDisplay = vm.selectedDistrictName ?? 'Seçilmedi';
        final String tourPointDisplay = vm.selectedTourPointName ?? 'Seçilmedi';
        final String placeDisplay = vm.selectedPlaceDesc ?? 'Seçilmedi';
        final String departureTime = vm.selectedTime ?? 'Seçilmedi';
        final cityDistrict = [
          cityDisplay ?? '',
          districtDisplay ?? '',
        ].where((s) => s.isNotEmpty).join(', ');
        // Fallback textuals — replace with your actual display names if available

        return Scaffold(
          appBar: AppBar(title: const Text('Özet')),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionCard(
                    title: 'Seyahat Bilgileri',
                    children: [
                      _infoRow('Tarih', _formatDate(date, departureTime)),
                      _infoRow('Kalkış Bölgesi', cityDistrict),
                      _infoRow('Tam konum', placeDisplay),
                      _infoRow('Tur Noktası', tourPointDisplay),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'Araç',
                    trailing: selectedVehicle?.image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              imageUrl: selectedVehicle!.image,
                              height: 64,
                              width: 64,
                              fit: BoxFit.cover,
                            ),
                          )
                        : null,
                    children: [
                      _infoRow(
                        'Araç',
                        _vehicleTitle(selectedVehicle, vehicleDetail),
                      ),
                      _infoRow(
                        'Sınıf',
                        vehicleDetail?.vehicleClass ??
                            selectedVehicle?.vehicleClass ??
                            '—',
                      ),
                      _infoRow(
                        'Tip',
                        vehicleDetail?.vehicleType ??
                            selectedVehicle?.vehicleType ??
                            '—',
                      ),
                      _infoRow(
                        'Koltuk',
                        _toStr(
                          vehicleDetail?.seatCount ??
                              selectedVehicle?.seatCount,
                        ),
                      ),
                      _infoRow('Araç Ücreti', _formatCurrency(vehiclePrice)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (selectedGuide != null)
                    _SectionCard(
                      title: 'Rehber',
                      trailing: selectedGuide?.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                imageUrl: selectedGuide!.image!,
                                height: 64,
                                width: 64,
                                fit: BoxFit.cover,
                              ),
                            )
                          : null,
                      children: [
                        _infoRow('Rehber', _guideTitle(selectedGuide)),
                        _infoRow(
                          'Diller',
                          (selectedGuide?.languages.isNotEmpty == true)
                              ? selectedGuide!.languages.join(', ')
                              : '—',
                        ),
                        _infoRow('Rehber Ücreti', _formatCurrency(guidePrice)),
                      ],
                    ),

                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'Ödeme Özeti',
                    children: [
                      _infoRow('Araç', _formatCurrency(vehiclePrice)),
                      _infoRow('Rehber', _formatCurrency(guidePrice)),
                      const Divider(height: 20),
                      _infoRow(
                        'Toplam',
                        _formatCurrency(totalPrice),
                        isEmph: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: canConfirm
                        ? () async {
                            await vm.ControlBooking(); // API cevabını bekle
                            if (vm.isValid && vm.bookingId != null) {
                              context.push('/payment', extra: vm.bookingId);
                            } else {
                              // Hata mesajını göstermek istersen:
                              if (vm.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(vm.errorMessage!)),
                                );
                              }
                            }
                          }
                        : null,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Onayla'),
                  ),
                  if (!canConfirm) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Onaylamak için tarih ve araç seçin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.redAccent),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ————————————————————————————————————————————————————————————————
  // Helpers
  // ————————————————————————————————————————————————————————————————

  Vehicle? _getSelectedVehicle(TourSearchDetailViewModel vm) {
    final String? id = vm.selectedVehicleId;
    if (id == null) return null;
    return vm.vehicles.firstWhereOrNull((v) => v.vehicleId == id);
  }

  Guide? _getSelectedGuide(TourSearchDetailViewModel vm) {
    final String? id = vm.selectedGuideId;
    if (id == null) return null;
    return vm.guides.firstWhereOrNull((g) => g.guideId == id);
  }

  int? _pickVehiclePrice(
    TourSearchDetailViewModel vm,
    Vehicle? selectedVehicle,
    VehicleDetail? vehicleDetail,
  ) {
    final fromVm = vm.setVehiclePrice;
    if (fromVm != null) return fromVm;
    if (selectedVehicle?.price != null) return selectedVehicle!.price;
    return vehicleDetail?.price;
  }

  static String _vehicleTitle(Vehicle? v, VehicleDetail? d) {
    final brand = d?.vehicleBrand ?? v?.vehicleBrand;
    final klass = d?.vehicleClass ?? v?.vehicleClass;
    return [brand, klass]
            .where((e) => (e != null && e.trim().isNotEmpty))
            .join(' • ')
            .isNotEmpty
        ? [brand, klass].whereType<String>().join(' • ')
        : (v != null ? 'Seçildi' : 'Seçilmedi');
  }

  static String _guideTitle(Guide? g) {
    if (g == null) return 'Seçilmedi';
    final full = '${g.firstName} ${g.lastName}'.trim();
    return full.isEmpty ? 'Rehber' : full;
  }

  static String _toStr(Object? v) => v?.toString() ?? '—';

  static Widget _infoRow(String label, String value, {bool isEmph = false}) {
    final style = isEmph
        ? const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)
        : const TextStyle(fontSize: 14);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(color: Colors.black54)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: style)),
        ],
      ),
    );
  }

  static String _formatDate(DateTime? date, String departureTime) {
    if (date == null) return 'Seçilmedi';

    // Örn: 13 Ağustos 2025, Çar
    final df = DateFormat('d MMMM yyyy, EEE', 'tr_TR');
    final formattedDate = df.format(date);

    // Saati string olarak ekle
    return "$formattedDate $departureTime";
  }

  static String _formatCurrency(num? value) {
    if (value == null) return '—';
    final f = NumberFormat.currency(
      locale: 'tr_TR',
      symbol: '₺',
      decimalDigits: 0,
    );
    return f.format(value);
  }
}

// ————————————————————————————————————————————————————————————————
// Small section card
// ————————————————————————————————————————————————————————————————
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.children,
    this.trailing,
  });

  final String title;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

// ————————————————————————————————————————————————————————————————
// Iterable extension: firstWhereOrNull (no external deps)
// ————————————————————————————————————————————————————————————————
extension FirstWhereOrNullExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}
