// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tour_booking/core/enum/user_role.dart';
// import 'package:tour_booking/services/location/location_permission_service.dart';
// import 'package:tour_booking/services/location/location_viewmodel.dart';
// // Kendi projenizdeki dosyaların yollarını buraya doğru şekilde ekleyin Örn: 'package:tour_booking/viewmodels/location_view_model.dart'

// class LocationActionButton extends StatelessWidget {
//   final String buttonText;
//   final VoidCallback?
//   onPressedCallback; // Butona basıldığında ekstra bir şey yapmak isterseniz

//   const LocationActionButton({
//     super.key,
//     this.buttonText = 'Konum İznini Kontrol Et ve Konumu Gönder',
//     this.onPressedCallback,
//   });

//   // ViewModel'deki izin durumuna göre buton veya metin rengini ayarlamak için yardımcı metod
//   Color _getStatusColor(LocationPermissionStatus? status) {
//     switch (status) {
//       case LocationPermissionStatus.grantedAlways:
//       case LocationPermissionStatus.grantedWhenInUse:
//         return Colors.green;
//       case LocationPermissionStatus.denied:
//         return Colors.orange;
//       case LocationPermissionStatus.permanentlyDenied:
//         return Colors.red;
//       default:
//         return Colors.blueGrey; // Bilinmeyen durumlar için
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ViewModel'i dinlemek için Consumer kullanıyoruz
//     return Consumer<LocationViewModel>(
//       builder: (context, viewModel, child) {
//         // İzin durumuna göre butonun metnini dinamik olarak değiştirebiliriz
//         String currentButtonText = buttonText;
//         if (viewModel.isTracking) {
//           currentButtonText = 'Konum Takibi Aktif (Durdur)';
//         } else if (viewModel.permissionStatus ==
//             LocationPermissionStatus.permanentlyDenied) {
//           currentButtonText = 'Ayarlardan İzin Ver (Kalıcı Reddedildi)';
//         } else if (viewModel.permissionStatus ==
//             LocationPermissionStatus.denied) {
//           currentButtonText = 'Konum İzni Gerekli (Tekrar İste)';
//         }

//         return Column(
//           mainAxisSize: MainAxisSize.min, // Sadece içeriği kadar yer kapla
//           children: [
//             ElevatedButton.icon(
//               onPressed: () async {
//                 if (viewModel.isTracking) {
//                   // Eğer konum takibi aktifse, butona basıldığında durdurma işlevi görsün
//                   viewModel.stopTracking();
//                 } else {
//                   // Konum takibi aktif değilse veya durdurulduysa,
//                   // CUSTOMER rolü için izinleri kontrol et ve başlat
//                   await viewModel.checkAndHandleLocation(UserRole.customer);
//                 }
//                 onPressedCallback?.call(); // Ekstra bir callback varsa çağır
//               },
//               icon: Icon(
//                 viewModel.isTracking ? Icons.stop : Icons.location_on,
//                 size: 28,
//               ),
//               label: Text(
//                 currentButtonText,
//                 style: const TextStyle(fontSize: 20),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: viewModel.isTracking
//                     ? Colors.redAccent
//                     : Colors.deepPurple,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                   vertical: 20,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             // Mevcut durumu kullanıcının görmesi için ek bilgiler
//             Text(
//               'İzin Durumu: ${viewModel.permissionStatus?.name ?? "Bilinmiyor"}',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: _getStatusColor(viewModel.permissionStatus),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             if (viewModel.currentPosition != null && viewModel.isTracking)
//               Text(
//                 'Son Konum: L:${viewModel.currentPosition!.latitude.toStringAsFixed(6)}, Lng:${viewModel.currentPosition!.longitude.toStringAsFixed(6)}',
//                 style: const TextStyle(fontSize: 14),
//                 textAlign: TextAlign.center,
//               ),
//             if (viewModel.permissionStatus ==
//                 LocationPermissionStatus.permanentlyDenied)
//               Padding(
//                 padding: const EdgeInsets.only(top: 5),
//                 child: Text(
//                   '🚨 Kalıcı reddedildi. Ayarlar > Uygulamalar > İzinler kısmından manuel olarak izin verin.',
//                   style: TextStyle(color: Colors.red[700], fontSize: 13),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }
