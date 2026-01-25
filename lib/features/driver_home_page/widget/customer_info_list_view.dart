import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tour_booking/core/enum/driver_booking_status.dart';
import 'package:tour_booking/models/customer_info_for_driver/customer_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CustomerInfoListView extends StatelessWidget {
  const CustomerInfoListView({super.key, required this.items});

  final List<CustomerInfo> items;

  String _statusLabel(CustomerInfo item) {
    switch (item.status) {
      case DriverBookingStatus.today:
        return 'Bugün';
      case DriverBookingStatus.upcoming:
      default:
        return 'Yaklaşan';
    }
  }

  Future<void> _openMap(double lat, double lng) async {
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.inbox, size: 72),
            SizedBox(height: 12),
            Text(
              'Şu an aktif bir müşteri yok',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            Text(
              'Yeni talepler geldiğinde burada görünecek.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 TUR ADI + STATUS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.departureDescription,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Chip(label: Text(_statusLabel(item))),
                  ],
                ),

                const SizedBox(height: 12),

                // 🔹 KALKIŞ NOKTASI
                Text(
                  'Kalkış Noktası',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  item.tourPointName,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 8),

                // 🔹 HARİTA BUTONU
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text('Haritada Aç'),
                    onPressed: () => _openMap(
                      item.departureLatitude,
                      item.departureLongitude,
                    ),
                  ),
                ),

                const Divider(height: 24),

                // 🔹 MÜŞTERİ BİLGİLERİ
                Row(
                  children: [
                    const Icon(Icons.person, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(item.cutomerFullName)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 18),
                    const SizedBox(width: 6),

                    // 📞 NUMARA YAZI OLARAK
                    Expanded(
                      child: Text(
                        item.customerPhoneNumber,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),

                    // 💬 WHATSAPP BUTONU
                    IconButton(
                      tooltip: 'WhatsApp ile yaz',
                      icon: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                      ),
                      onPressed: () =>
                          _openWhatsApp(context, item.customerPhoneNumber),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> _openWhatsApp(BuildContext context, String phone) async {
  final cleanPhone = phone.replaceAll('+', '').replaceAll(' ', '');

  final uri = Uri.parse(
    'https://wa.me/$cleanPhone?text=${Uri.encodeComponent('Merhaba, tur için yazıyorum')}',
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('WhatsApp yüklü değil veya açılamadı'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
