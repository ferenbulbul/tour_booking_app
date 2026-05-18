import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/enum/driver_booking_status.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/models/customer_info_for_driver/customer_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';

class CustomerInfoListView extends StatelessWidget {
  const CustomerInfoListView({
    super.key,
    required this.items,
    this.onCompleteDropoff,
  });

  final List<CustomerInfo> items;
  final Future<bool> Function(String bookingId)? onCompleteDropoff;

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
            Icon(SolarIconsOutline.box, size: 72),
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

        final isTransport = item.bookingType == 1;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER + STATUS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (isTransport)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(SolarIconsOutline.routing,
                                  size: 20, color: AppColors.primary),
                            ),
                          Expanded(
                            child: Text(
                              isTransport
                                  ? (item.pickupAddress ?? item.departureDescription)
                                  : item.departureDescription,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Chip(label: Text(_statusLabel(item))),
                  ],
                ),

                const SizedBox(height: 12),

                if (isTransport) ...[
                  // TRANSPORT: Pickup → Dropoff
                  _locationRow(
                    Icons.circle,
                    Colors.green,
                    'transport_pickup'.tr(),
                    item.pickupAddress ?? '-',
                  ),
                  const SizedBox(height: 6),
                  _locationRow(
                    Icons.circle,
                    Colors.red,
                    'transport_dropoff'.tr(),
                    item.dropoffAddress ?? '-',
                  ),
                  const SizedBox(height: 8),
                  if (item.dropoffLatitude != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        icon: const Icon(SolarIconsOutline.map),
                        label: Text('driver_open_dropoff_map'.tr()),
                        onPressed: () => _openMap(
                          item.dropoffLatitude!,
                          item.dropoffLongitude!,
                        ),
                      ),
                    ),
                ] else ...[
                  // TOUR
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      icon: const Icon(SolarIconsOutline.map),
                      label: const Text('Haritada Aç'),
                      onPressed: () => _openMap(
                        item.departureLatitude,
                        item.departureLongitude,
                      ),
                    ),
                  ),
                ],

                const Divider(height: 24),

                // CUSTOMER INFO
                Row(
                  children: [
                    const Icon(SolarIconsOutline.user, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(item.cutomerFullName)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(SolarIconsOutline.phone, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.customerPhoneNumber,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
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

                // TRANSPORT: Dropoff button
                if (isTransport && item.bookingId != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(SolarIconsOutline.checkCircle),
                      label: Text('driver_transport_dropoff'.tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _confirmDropoff(context, item),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _locationRow(IconData icon, Color color, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ),
      ],
    );
  }

  void _confirmDropoff(BuildContext context, CustomerInfo item) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  SolarIconsOutline.checkCircle,
                  size: 28,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'driver_transport_dropoff_confirm'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'driver_transport_dropoff_confirm_message'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('cancel'.tr()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(ctx);
                          final success = await onCompleteDropoff?.call(item.bookingId!);
                          if (success == true && context.mounted) {
                            UIHelper.showSuccess(context, 'driver_transport_dropoff_success'.tr());
                          }
                        },
                        child: Text('confirm'.tr()),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
    UIHelper.showError(context, 'WhatsApp yüklü değil veya açılamadı');
  }
}
