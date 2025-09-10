import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/home/widgets/customer_location_button.dart';

class NearbyPointsPage extends StatelessWidget {
  const NearbyPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sana Yakın Yerler"),
        actions: const [
          // AppBar'ın sağındaki yenile butonu
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CustomerSendLocationButton(text: "Yenile"),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (vm.isLoadingNearby) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.nearbyPoints.isEmpty) {
            return const Center(child: Text("Yakın yer bulunamadı."));
          }

          // Pull-to-refresh desteği
          return RefreshIndicator(
            onRefresh: () =>
                context.read<HomeViewModel>().fetchNearbyTourPoints(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.nearbyPoints.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final point = vm.nearbyPoints[index];
                return InkWell(
                  onTap: () =>
                      context.pushNamed('searchDetail', extra: point.id),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // Görsel
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: point.mainImage.isNotEmpty
                                ? point.mainImage
                                : "https://via.placeholder.com/300",
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: Colors.grey.shade300),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        // Alt bilgi şeridi
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  point.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${point.cityName} • ${point.tourTypeName}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Sağ üstte mesafe etiketi
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${point.distance.toStringAsFixed(1)} km",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
