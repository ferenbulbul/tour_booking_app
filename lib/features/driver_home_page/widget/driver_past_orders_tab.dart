import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/empty_state.dart';
import 'package:tour_booking/features/driver_home_page/driver_past_orders_viewmodel.dart';
import 'package:tour_booking/features/driver_home_page/widget/driver_past_order_card.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class DriverPastOrdersTab extends StatelessWidget {
  const DriverPastOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverPastOrdersViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading && vm.pastBookings.isEmpty) {
          return const _PastOrdersSkeleton();
        }

        if (vm.error != null && vm.pastBookings.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Text(
                vm.error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.colors.error,
                ),
              ),
            ),
          );
        }

        if (vm.pastBookings.isEmpty) {
          return EmptyState(
            icon: SolarIconsOutline.history,
            title: tr('driver_no_past_orders'),
            subtitle: tr('driver_no_past_orders_sub'),
          );
        }

        return RefreshIndicator(
          onRefresh: vm.fetchPastBookings,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding, 12, AppSpacing.screenPadding, 24,
            ),
            itemCount: vm.pastBookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.ml),
            itemBuilder: (_, i) => DriverPastOrderCard(item: vm.pastBookings[i]),
          ),
        );
      },
    );
  }
}

class _PastOrdersSkeleton extends StatelessWidget {
  const _PastOrdersSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.ext.shimmerBase,
      highlightColor: context.ext.shimmerHighlight,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.l,
        ),
        child: Column(
          children: List.generate(4, (_) => const _SkeletonCard()),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.ml),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
            ),
            const SizedBox(width: AppSpacing.ms),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 14,
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: 100,
                    height: 12,
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: 60,
                    height: 14,
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
