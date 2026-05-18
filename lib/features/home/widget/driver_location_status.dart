import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/services/location/location_permission_service.dart';
import 'package:tour_booking/features/location/location_viewmodel.dart';

/// SADECE Driver rolü için gösterilecek durum widget'ı.
class DriverLocationStatus extends StatelessWidget {
  const DriverLocationStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationViewModel>(
      builder: (context, viewModel, child) {
        String statusText;
        Color statusColor;
        IconData statusIcon;

        final status = viewModel.permissionStatus;

        if (viewModel.isTracking) {
          final pos = viewModel.currentPosition;
          final lat = pos?.latitude.toStringAsFixed(4) ?? '...';
          final lon = pos?.longitude.toStringAsFixed(4) ?? '...';
          statusText = "Konum paylaşılıyor: $lat, $lon";
          statusColor = Colors.green;
          statusIcon = SolarIconsOutline.mapPoint;
        } else {
          switch (status) {
            case LocationPermissionStatus.grantedWhenInUse:
              statusText =
                  "Arka plan izni gerekli. Konum sadece uygulama açıkken paylaşılıyor.";
              statusColor = Colors.blue;
              statusIcon = SolarIconsOutline.infoCircle;
              break;
            case LocationPermissionStatus.denied:
              statusText = "Konum takibi için izin gerekli.";
              statusColor = Colors.red;
              statusIcon = SolarIconsOutline.mapPointRemove;
              break;
            case LocationPermissionStatus.permanentlyDenied:
              statusText = "Konum izni reddedildi. Lütfen ayarlardan açın.";
              statusColor = Colors.red;
              statusIcon = SolarIconsOutline.settings;
              break;
            default:
              statusText = "Konum izni bekleniyor...";
              statusColor = Colors.orange;
              statusIcon = SolarIconsOutline.stopwatch;
          }
        }

        // İlk açılışta durum null ise hiçbir şey gösterme
        if (status == null) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: statusColor),
          ),
          child: Row(
            children: [
              Icon(statusIcon, color: statusColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
