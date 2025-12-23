import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/widgets/empty_state.dart';
import 'package:tour_booking/features/home/widgets/tour_type_result_skeleton.dart';
import 'package:tour_booking/features/detailed_search/search_result/search_result_viewmodel.dart';
import 'package:tour_booking/features/detailed_search/search_result/widget/tour_search_result_card.dart';
import 'package:tour_booking/models/tour_search_detail_request/tour_search_detailed_request.dart';

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
    final scheme = Theme.of(context).colorScheme;
    // 🔥 UIHelper tetikleme noktası
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm.errorMessage != null) {
        UIHelper.showError(context, vm.errorMessage!);
        vm.clearMessages();
      }
    });

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: CommonAppBar(
        title: tr("tour_search_results_title"),
        centerTitle: true,
        showBack: true,
      ),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(TourSearchResultsViewModel vm) {
    if (vm.isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, __) => const TourCardSkeleton(),
      );
    }

    if (vm.tourPoints.isEmpty) {
      return EmptyState(
        icon: Icons.search_off_rounded,
        title: tr("search_no_results_title"),
        subtitle: tr("search_no_results_subtitle"),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.screenPadding,
      ),
      itemCount: vm.tourPoints.length,
      itemBuilder: (_, i) =>
          RepaintBoundary(child: TourSearchResultCard(point: vm.tourPoints[i])),
    );
  }
}
