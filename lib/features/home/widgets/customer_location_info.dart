import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/services/auth/location_permission_service.dart';
import 'package:tour_booking/services/auth/location_viewmodel.dart.dart';

/// SADECE Customer rolü için gösterilecek durum widget'ı.
class CustomerLocationInfo extends StatelessWidget {
  const CustomerLocationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationViewModel>(
      builder: (context, viewModel, child) {
        final status = viewModel.permissionStatus;

        // Sadece kullanıcı izin verdiyse bir mesaj göster.
        if (status == LocationPermissionStatus.grantedWhenInUse) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Yakınınızdaki fırsatları görmek için konumunuz kullanılabilir.",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          );
        }
        // Diğer tüm durumlarda (reddedildi, sorulmadı vb.) hiçbir şey gösterme.
        return const SizedBox.shrink();
      },
    );
  }
}
