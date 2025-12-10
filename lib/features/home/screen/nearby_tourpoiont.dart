import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/home/widgets/nearby_card.dart';
import 'package:tour_booking/features/home/widgets/nearby_skeleton.dart';

class NearbyPointsPage extends StatefulWidget {
  const NearbyPointsPage({super.key});

  @override
  State<NearbyPointsPage> createState() => _NearbyPointsPageState();
}

class _NearbyPointsPageState extends State<NearbyPointsPage> {
  @override
  void initState() {
    super.initState();

    /// Sayfa açılır açılmaz API'yi çağır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().fetchNearbyTourPoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      appBar: CommonAppBar(
        title: "Sana Yakın Yerler",
        showBack: true, // geri butonu istiyorsan, değilse false yap

        actionIcon: Icons.gps_fixed,
        onActionPressed: () {
          context.read<HomeViewModel>().fetchNearbyTourPoints();
        },
      ),

      body: _buildBody(vm),
    );
  }

  // ----------------------------------------------------------------------------
  // BODY BUILDER
  // ----------------------------------------------------------------------------
  Widget _buildBody(HomeViewModel vm) {
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
          childAspectRatio: 0.78,
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
  }
}
