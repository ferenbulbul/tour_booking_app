import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
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
      appBar: CommonAppBar(
        title: vm.isLoading ? "Searching..." : "Turlar",
        centerTitle: true,
        showBack: true, // veya false, duruma göre
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
      return buildEmptySearch();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vm.tourPoints.length,
      itemBuilder: (_, i) => TourSearchResultCard(point: vm.tourPoints[i]),
    );
  }
}

Widget buildEmptySearch() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 60, color: Colors.black26),

          const SizedBox(height: 20),

          const Text(
            "Sonuç bulunamadı",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Filtrelerinizi değiştirerek yeniden arama yapmayı deneyebilirsiniz.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
          ),
        ],
      ),
    ),
  );
}
