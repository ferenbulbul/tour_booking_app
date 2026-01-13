import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';

import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/home/widgets/tour_type_result_skeleton.dart';
import 'package:tour_booking/features/home/widgets/tour_type_result_card.dart';

class TourSearchResultsByTourTypeScreen extends StatefulWidget {
  final String? tourTypeId;

  const TourSearchResultsByTourTypeScreen({
    super.key,
    required this.tourTypeId,
  });

  @override
  State<TourSearchResultsByTourTypeScreen> createState() =>
      _TourSearchResultsByTourTypeScreenState();
}

class _TourSearchResultsByTourTypeScreenState
    extends State<TourSearchResultsByTourTypeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final id = widget.tourTypeId ?? "";
      context.read<HomeViewModel>().fetchTourPointsByType(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (HomeViewModel vm) => vm.isLoadingSearchByType,
    );
    final items = context.select((HomeViewModel vm) => vm.searchItemsByType);
    final msg = context.select((HomeViewModel vm) => vm.messageSearchByType);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,

      appBar: CommonAppBar(
        title: tr("tour_search_results_title"),
        showBack: true,
      ),

      body: _buildBody(isLoading, msg, items),
    );
  }

  Widget _buildBody(bool isLoading, String? msg, List items) {
    if (isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemBuilder: (_, __) => const TourCardSkeleton(),
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
        itemCount: 3,
      );
    }

    if (msg != null) {
      return _buildMessageState(context, msg, Icons.error_outline_rounded);
    }

    if (items.isEmpty) {
      return _buildMessageState(
        context,
        "Aradığınız kritere uygun tur bulunamadı.",
        Icons.search_off_rounded,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.screenPadding,
      ),
      itemBuilder: (_, i) => RepaintBoundary(
        child: TourTypeResultCard(
          id: items[i].id,
          image: items[i].mainImage ?? "",
          title: items[i].name ?? "-",
          city: items[i].cityName ?? "-",
          district: items[i].districtName,
          difficulty: items[i].tourDifficultyName,
          onTap: () {
            context.pushNamed(
              "searchDetail",
              extra: {"id": items[i].id, "initialImage": items[i].mainImage},
            );
          },
        ),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
      itemCount: items.length,
    );
  }

  // -------------------------------------------------------------
  // PREMIUM EMPTY & ERROR STATE (Design System Edition)
  // -------------------------------------------------------------
  Widget _buildMessageState(BuildContext context, String msg, IconData icon) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.l,
        ),
        decoration: BoxDecoration(
          color: scheme.surfaceVariant.withOpacity(.45),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: scheme.outline.withOpacity(.25), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: scheme.primary),
            const SizedBox(height: AppSpacing.m),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withOpacity(.8),
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
