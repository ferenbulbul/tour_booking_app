import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tour_booking/models/booking/booking_dto.dart';
import 'package:tour_booking/core/theme/app_colors.dart';

class BookingCard extends StatefulWidget {
  final BookingDto item;

  /// Sadece "Tümü" tabında true gönderilecek
  final bool showCancelAction;

  const BookingCard({
    super.key,
    required this.item,
    this.showCancelAction = false,
  });

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  bool _isOpen = false;

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s == "tamamlandı" || s == "completed") {
      return Colors.green.shade600;
    }
    if (s == "iptal" || s == "cancelled") {
      return Colors.red.shade600;
    }
    // success / upcoming vs → gelecek
    return AppColors.primary;
  }

  String _statusLabel(String status, DateTime departureDate) {
    final s = status.toLowerCase();

    if (s == "tamamlandı" || s == "completed") {
      return "Tamamlandı";
    }
    if (s == "iptal" || s == "cancelled") {
      return "İptal Edildi";
    }
    if (s == "success" || departureDate.isAfter(DateTime.now())) {
      return "Gelecek";
    }
    return status;
  }

  bool _isCancelable(String status) {
    final s = status.toLowerCase();
    // tamamlanan & iptal edilmiş -> iptal isteği yok
    if (s == "tamamlandı" ||
        s == "completed" ||
        s == "iptal" ||
        s == "cancelled") {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    final departureDate = DateTime.parse(item.departureDate);
    final date = DateFormat('dd MMMM yyyy', 'tr_TR').format(departureDate);

    final statusColor = _statusColor(item.status);
    final statusText = _statusLabel(item.status, departureDate);
    final canCancel = _isCancelable(item.status);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // HEADER
          InkWell(
            onTap: () => setState(() => _isOpen = !_isOpen),
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Row(
                children: [
                  // soft icon
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.terrain_rounded,
                      size: 22,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Başlık + tarih (başlık siyah)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          item.tourPointName,
                          style: const TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.black, // 🖤 başlık siyah
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ok ikonu
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 24,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // AÇILAN KISIM
          ClipRect(
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment: Alignment.center,
              heightFactor: _isOpen ? 1 : 0,
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    Divider(
                      height: 22,
                      thickness: 0.7,
                      color: Colors.grey.withOpacity(0.15), // 🔹 daha silik
                    ),

                    _info(
                      "Kalkış Yeri",
                      item.departureLocationDescription,
                      Icons.place_outlined,
                    ),
                    _info(
                      "Saat",
                      item.departureTime,
                      Icons.access_time_rounded,
                    ),
                    _info(
                      "Araç",
                      "${item.vehicleBrand} • ${item.seatCount} koltuk",
                      Icons.directions_bus_rounded,
                    ),
                    _info("Şoför", item.driverName, Icons.person_rounded),
                    if (item.guideName.trim().isNotEmpty)
                      _info("Rehber", item.guideName, Icons.map_rounded),

                    const SizedBox(height: 14),

                    // Toplam ücret (tamamen siyah ton)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Toplam Ücret",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black, // 🖤
                          ),
                        ),
                        Text(
                          "${item.totalPrice} ₺",
                          style: const TextStyle(
                            color: Colors.black87, // 🖤 yeşil yerine siyah
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // İPTAL TALEBİ BUTONU
                    if (widget.showCancelAction && canCancel)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            foregroundColor: Colors.red.shade600,
                            side: BorderSide(
                              color: Colors.red.shade200,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // TODO: İptal talebi oluşturma aksiyonu
                          },
                          child: const Text(
                            "İptal talebi oluştur",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 17, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label: $value",
              style: const TextStyle(fontSize: 13.5, height: 1.25),
            ),
          ),
        ],
      ),
    );
  }
}
