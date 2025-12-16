import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/widgets/empty_state.dart';
import 'package:tour_booking/features/home/widgets/tour_type_result_skeleton.dart';
import 'package:tour_booking/features/detailed_search/search_result/search_result_viewmodel.dart';
import 'package:tour_booking/features/detailed_search/search_result/widget/tour_search_result_card.dart';
import 'package:tour_booking/models/tour_search_detail_request/tour_search_detailed_request.dart';
import 'package:tour_booking/core/theme/app_colors.dart';

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
    final isLoading = context.select(
      (TourSearchResultsViewModel vm) => vm.isLoading,
    );
    final error = context.select(
      (TourSearchResultsViewModel vm) => vm.errorMessage,
    );
    final points = context.select(
      (TourSearchResultsViewModel vm) => vm.tourPoints,
    );

    return Scaffold(
      appBar: CommonAppBar(
        title: "Tur Sonuçları",
        centerTitle: true,
        showBack: true,
      ),

      body: _buildBody(isLoading, error, points),
    );
  }

  Widget _buildBody(bool isLoading, String? errorMsg, List points) {
    if (isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, __) => const TourCardSkeleton(),
      );
    }

    if (errorMsg != null) {
      return Center(
        child: Text(errorMsg, style: TextStyle(color: AppColors.error)),
      );
    }

    if (points.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off_rounded,
        title: "Sonuç Bulunamadı",
        subtitle:
            "Filtrelerinizi değiştirerek yeniden arama yapmayı deneyebilirsiniz.",
      );
    }
    ();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.screenPadding,
      ),
      itemCount: points.length,
      itemBuilder: (_, i) =>
          RepaintBoundary(child: TourSearchResultCard(point: points[i])),
    );
  }
}
