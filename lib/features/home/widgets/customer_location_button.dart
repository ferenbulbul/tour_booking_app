// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:tour_booking/features/home/home_viewmodel.dart';
// import 'package:tour_booking/models/location_update/location_dto.dart';
// import 'package:tour_booking/services/tour/tour_service.dart';

// class CustomerSendLocationButton extends StatefulWidget {
//   final String text;
//   const CustomerSendLocationButton({super.key, this.text = "Konumu Yenile"});

//   @override
//   State<CustomerSendLocationButton> createState() =>
//       _CustomerSendLocationButtonState();
// }

// class _CustomerSendLocationButtonState
//     extends State<CustomerSendLocationButton> {
//   bool _loading = false;
//   final _service = TourService();

//   Future<void> _onPressed() async {
//     if (_loading) return;
//     setState(() => _loading = true);

//     try {
//       // 1) Servis açık mı?
//       if (!await Geolocator.isLocationServiceEnabled()) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Konum servisleri kapalı.")),
//         );
//         return;
//       }

//       // 2) İzin popup
//       var status = await Permission.locationWhenInUse.status;
//       if (!status.isGranted) {
//         status = await Permission.locationWhenInUse.request();
//       }
//       if (!status.isGranted) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               status.isPermanentlyDenied
//                   ? "Konum izni kalıcı olarak reddedildi."
//                   : "Konum izni verilmedi.",
//             ),
//           ),
//         );
//         return;
//       }

//       // 3) Konumu al
//       final pos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       // 4) Backend'e gönder
//       final dto = LocationDto(
//         latitude: double.parse(pos.latitude.toStringAsFixed(6)),
//         longitude: double.parse(pos.longitude.toStringAsFixed(6)),
//       );
//       await _service.locationUpdate(dto);

//       // 5) Nearby yeniden çek
//       if (mounted) {
//         await context.read<HomeViewModel>().fetchNearbyTourPoints();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Konum güncellendi, yakın yerler yenilendi ✅"),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Hata: $e")));
//       }
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return OutlinedButton.icon(
//       onPressed: _loading ? null : _onPressed,
//       style: OutlinedButton.styleFrom(
//         foregroundColor: Colors.white, // ikon + text beyaz
//         side: const BorderSide(color: Colors.white), // çerçeve beyaz
//         textStyle: const TextStyle(color: Colors.white),
//       ),
//       icon: _loading
//           ? const SizedBox(
//               width: 16,
//               height: 16,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(
//                   Colors.white,
//                 ), // spinner beyaz
//               ),
//             )
//           : const Icon(Icons.my_location, color: Colors.white),
//       label: Text(
//         _loading ? "Güncelleniyor..." : widget.text,
//         style: const TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }
