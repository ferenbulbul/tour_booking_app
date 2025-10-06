import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/bookings/bookings_viewmodel.dart';
import 'package:intl/intl.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<BookingsViewModel>().fetchBookings());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingsViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text("Geçmiş Siparişlerim")),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.bookings.isEmpty
          ? const Center(child: Text("Henüz siparişiniz bulunmuyor."))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: vm.bookings.length,
              itemBuilder: (context, i) {
                final b = vm.bookings[i];
                final date = DateFormat(
                  'dd MMMM yyyy',
                  'tr_TR',
                ).format(DateTime.parse(b.departureDate));
                final color = b.status == "Tamamlandı"
                    ? Colors.green
                    : b.status == "Bugün"
                    ? Colors.orange
                    : Colors.blue;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0.8,
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: color.withOpacity(0.15),
                        child: Icon(Icons.hiking, color: color),
                      ),
                      title: Text(
                        b.tourPointName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "$date • ${b.status}",
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      childrenPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        Text(
                          "📍 Kalkış Yeri: ${b.departureLocationDescription}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "🗺️ Şehir / İlçe: ${b.departureCity} - ${b.departureDistrict}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "🕒 Kalkış Saati: ${b.departureTime}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "🚗 Araç: ${b.vehicleBrand} (${b.seatCount} koltuk)",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "🧍‍♂️ Şoför: ${b.driverName}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (b.guideName.trim().isNotEmpty)
                          Text(
                            "🧭 Rehber: ${b.guideName}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        const Divider(height: 16),
                        Text(
                          "💰 Tur Fiyatı: ${b.tourPointPrice} ₺",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "🎯 Rehber Ücreti: ${b.guidePrice} ₺",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "💵 Toplam: ${b.totalPrice} ₺",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
