import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_spacing.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().fetchNearbyTourPoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CommonAppBar(
        title: tr("nearby_tours"),
        showBack: true,
        actionIcon: Icons.gps_fixed,
        onActionPressed: () => vm.fetchNearbyTourPoints(),
      ),
      body: _buildBody(context, vm),
    );
  }

  Widget _buildBody(BuildContext context, HomeViewModel vm) {
    if (vm.isLoadingNearby) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.sectionSpacing,
        ),
        child: NearbySkeleton(),
      );
    }

    if (vm.nearbyPoints.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () => vm.fetchNearbyTourPoints(),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.sectionSpacing,
        ),
        itemCount: vm.nearbyPoints.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.m,
          mainAxisSpacing: AppSpacing.m,
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

  Widget _buildEmptyState(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: scheme.surfaceVariant.withOpacity(.45),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: scheme.outlineVariant.withOpacity(.25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off_rounded, size: 46, color: scheme.primary),
            const SizedBox(height: AppSpacing.s),
            Text(
              tr("no_nearby_tour_found"),
              style: TextStyle(
                color: scheme.onSurface.withOpacity(.85),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
