import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/widgets/skelaton/tour_card_skeleton.dart';
import 'package:tour_booking/features/detailed_search/search_result/search_result_viewmodel.dart';
import 'package:tour_booking/features/detailed_search/search_result/widget/tour_search_result_card.dart';
import 'package:tour_booking/models/tour_search_detail_request/tour_search_detailed_request.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class TourSearchResultsScreen extends StatefulWidget {
  final int type;
  final String? regionId;
  final String? cityId;
  final String? districtId;

  const TourSearchResultsScreen({
    super.key,
    required this.type,
    this.regionId,
    this.cityId,
    this.districtId,
  });

  @override
  State<TourSearchResultsScreen> createState() =>
      _TourSearchResultsScreenState();
}

class _TourSearchResultsScreenState extends State<TourSearchResultsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final req = TourSearchRequest(
        type: widget.type,
        regionId: widget.regionId,
        cityId: widget.cityId,
        districtId: widget.districtId,
      );

      context.read<TourSearchResultsViewModel>().fetchTourPoints(req);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TourSearchResultsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          vm.isLoading ? "Searching..." : "Tours",
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.surface,
      ),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(TourSearchResultsViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: TourCardSkeleton());
    }

    if (vm.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(vm.errorMessage!),
        ),
      );
    }

    if (vm.tourPoints.isEmpty) {
      return const Center(
        child: Text("No results found", style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vm.tourPoints.length,
      itemBuilder: (_, i) => TourSearchResultCard(point: vm.tourPoints[i]),
    );
  }
}
