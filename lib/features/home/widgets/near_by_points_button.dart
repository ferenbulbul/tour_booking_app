import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class NearbyPointsButton extends StatelessWidget {
  const NearbyPointsButton({super.key});

  Future<bool> _hasPermission() async {
    final status = await Permission.locationWhenInUse.status;
    return status.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasPermission(),
      builder: (context, snapshot) {
        // Buton her zaman gözüksün → sadece onPressed içinde kontrol yapacağız
        return OutlinedButton.icon(
          onPressed: () async {
            final status = await Permission.locationWhenInUse.status;

            if (status.isGranted) {
              // izin varsa sayfaya git
              if (context.mounted) {
                context.pushNamed("nearbyPoints");
              }
            } else {
              // izin yoksa snackbar göster
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Lütfen Ayarladan Konumunuza izin verin"),
                  ),
                );
              }

              // istersen burda izin popup'ı da tetikleyebilirsin:
              // await Permission.locationWhenInUse.request();
            }
          },
          icon: const Icon(Icons.place_outlined),
          label: const Text(
            "Size Yakın Yerleri Görmek İster Misiniz ?",
            style: TextStyle(fontSize: 15),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
