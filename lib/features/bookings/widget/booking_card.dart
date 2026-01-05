import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tour_booking/models/booking/booking_dto.dart';
import 'package:tour_booking/core/theme/app_colors.dart';

class BookingCard extends StatefulWidget {
  final BookingDto item;
  final bool showCancelAction;
  final VoidCallback? onCancel;
  final bool isCancelling;

  const BookingCard({
    super.key,
    required this.item,
    this.showCancelAction = false,
    this.onCancel,
    this.isCancelling = false,
  });

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  bool _isOpen = false;

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s == "completed") {
      return Colors.green.shade600;
    }
    if (s == "cancelled") {
      return Colors.red.shade600;
    }
    return AppColors.primary;
  }

  String _statusLabel(String status, DateTime departureDate) {
    final s = status.toLowerCase();

    if (s == "completed") return 'booking_tab_completed'.tr();
    if (s == "cancelled") return 'booking_tab_cancelled'.tr();
    if (departureDate.isAfter(DateTime.now())) {
      return 'booking_tab_upcoming'.tr();
    }

    return status;
  }

  bool _isCancelable(String status) {
    final s = status.toLowerCase();
    return !(s == "completed" || s == "cancelled");
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
      margin: const EdgeInsetsDirectional.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // -----------------------------------------------------------------
          // HEADER
          // -----------------------------------------------------------------
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => setState(() => _isOpen = !_isOpen),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Row(
                children: [
                  // ICON
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.terrain_rounded,
                      size: 22,
                      color: statusColor,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // TITLE + DATE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.tourPointName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
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

                  // STATUS BADGE
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

                  const SizedBox(width: 6),

                  // CHEVRON
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 24,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // -----------------------------------------------------------------
          // EXPANDED CONTENT
          // -----------------------------------------------------------------
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
                      thickness: 0.8,
                      color: Colors.grey.withOpacity(.15),
                    ),

                    _info(
                      Icons.place_outlined,
                      'booking_label_departure_location'.tr(),
                      item.departureLocationDescription,
                    ),
                    _info(
                      Icons.access_time_rounded,
                      'booking_label_time'.tr(),
                      item.departureTime,
                    ),
                    _info(
                      Icons.directions_bus_rounded,
                      'booking_label_vehicle'.tr(),
                      "${item.vehicleBrand} • ${item.seatCount} ${'booking_seat_count'.tr()}",
                    ),
                    _info(
                      Icons.person_rounded,
                      'booking_label_driver'.tr(),
                      item.driverName,
                    ),

                    if (item.guideName.trim().isNotEmpty)
                      _info(
                        Icons.map_rounded,
                        'booking_label_guide'.tr(),
                        item.guideName,
                      ),

                    const SizedBox(height: 14),

                    // PRICE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'booking_total_price'.tr(),
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _formatCurrency(item.totalPrice),
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.5,
                            letterSpacing: -.2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if (widget.showCancelAction && canCancel)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            foregroundColor: Colors.red.shade600,
                            side: BorderSide(color: Colors.red.shade200),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: widget.isCancelling
                              ? null
                              : widget.onCancel,

                          child: widget.isCancelling
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'booking_cancel_request'.tr(),
                                  style: const TextStyle(
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

  Widget _info(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label: $value",
              style: const TextStyle(fontSize: 13.5, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatCurrency(num? v) {
  if (v == null) return "—";
  final f = NumberFormat.currency(
    locale: "tr_TR",
    symbol: "₺",
    decimalDigits: 2,
  );
  return "${f.format(v)} ₺";
}
