import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';

class FeaturedPointsWidget extends StatelessWidget {
  const FeaturedPointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    if (vm.isLoading) return const Center(child: CircularProgressIndicator());
    if (vm.featuredPoints.isEmpty) return const Text("Öne çıkan yer yok");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Öne Çıkanlar",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),

        // Yana doğru kayan liste
        SizedBox(
          height: 220, // kart yüksekliği artırıldı
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: vm.featuredPoints.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final point = vm.featuredPoints[index];
              return SizedBox(
                width: 180, // kart genişliği artırıldı
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Stack(
                    children: [
                      // Resim
                      Positioned.fill(
                        child: Image.network(
                          point.mainImage.isNotEmpty
                              ? point.mainImage
                              : "https://via.placeholder.com/300",
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Üstte gölgeli başlık
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          color: Colors.black.withOpacity(0.6),
                          child: Text(
                            point.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
        ),
      ],
    );
  }
}
