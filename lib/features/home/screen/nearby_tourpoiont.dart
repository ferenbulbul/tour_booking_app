import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/features/home/widgets/nearby_card.dart';
import 'package:tour_booking/features/home/widgets/nearby_skeleton.dart';

class NearbyPointsPage extends StatelessWidget {
  const NearbyPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Sana Yakın Yerler",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.gps_fixed, color: Colors.black87),
            splashRadius: 22,
            tooltip: "Konumu Yenile",
            onPressed: () {
              context.read<HomeViewModel>().fetchNearbyTourPoints();
            },
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: Builder(
        builder: (context) {
          if (vm.isLoadingNearby) {
            return const NearbySkeleton();
          }

          if (vm.nearbyPoints.isEmpty) {
            return const Center(child: Text("Yakın yer bulunamadı."));
          }

          return RefreshIndicator(
            onRefresh: () => vm.fetchNearbyTourPoints(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.nearbyPoints.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.77,
              ),
              itemBuilder: (context, i) {
                final p = vm.nearbyPoints[i];
                return GestureDetector(
                  onTap: () => context.pushNamed(
                    "searchDetail",
                    extra: {"id": p.id, "initialImage": p.mainImage},
                  ),
                  child: NearbyCard(
                    image: p.mainImage,
                    title: p.title,
                    city: p.cityName,
                    type: p.tourTypeName,
                    distance: p.distance,
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
