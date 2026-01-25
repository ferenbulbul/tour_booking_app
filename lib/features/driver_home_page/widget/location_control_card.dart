import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/services/location/location_viewmodel.dart';

/// Driver için konum izni/akışı butonla yönetilen kart.
/// ⚠️ Mantık AYNI – dokunulmadı
class LocationControlCard extends StatelessWidget {
  const LocationControlCard({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final locationVm = context.watch<LocationViewModel>();
    final tracking = locationVm.isTracking;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Konum Paylaşımı',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              tracking
                  ? 'Konum paylaşımı AKTİF.'
                  : 'Konum paylaşımı PASİF. Başlatmak için butona bas.',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  icon: Icon(tracking ? Icons.stop : Icons.play_arrow),
                  label: Text(tracking ? 'Konumu Durdur' : 'Konumu Başlat'),
                  onPressed: () async {
                    if (tracking) {
                      // ❌ DOKUNMADIM
                      locationVm.stopTracking();
                    } else {
                      // ❌ DOKUNMADIM
                      await locationVm.checkAndHandleLocation(role);
                    }
                  },
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.settings),
                  label: const Text('Ayarlar'),
                  onPressed: () {
                    openAppSettings();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
