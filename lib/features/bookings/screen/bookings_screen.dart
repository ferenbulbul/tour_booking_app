import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/enum/booking_status.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/empty_state.dart';
import 'package:tour_booking/features/bookings/bookings_viewmodel.dart';
import 'package:tour_booking/features/bookings/widget/booking_card.dart';
import 'package:tour_booking/features/bookings/widget/booking_card_content.dart';
import 'package:tour_booking/features/bookings/widget/booking_card_header.dart';
import 'package:tour_booking/features/bookings/widget/booking_skeleton.dart';
import 'package:tour_booking/models/booking/booking_dto.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      final vm = context.read<BookingsViewModel>();
      vm.fetchBookingsByStatus(BookingStatus.upcoming);
      vm.fetchBookingsByStatus(BookingStatus.completed);
      vm.fetchBookingsByStatus(BookingStatus.cancelled);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshAll() {
    final vm = context.read<BookingsViewModel>();
    vm.fetchBookingsByStatus(BookingStatus.upcoming);
    vm.fetchBookingsByStatus(BookingStatus.completed);
    vm.fetchBookingsByStatus(BookingStatus.cancelled);
  }

  void _openDetail(BookingDto item) {
    showBookingDetailSheet(
      context,
      item: item,
      onCancel: context.read<BookingsViewModel>().requestCancellation,
      onRated: _refreshAll,
      onCancelled: _refreshAll,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Selector<BookingsViewModel, String?>(
          selector: (_, vm) => vm.message,
          builder: (context, message, _) {
            if (message != null && message.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;
                UIHelper.showSuccess(context, message.tr());
                context.read<BookingsViewModel>().clearMessage();
              });
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                _buildHeader(),
                const SizedBox(height: 16),

                // TAB BAR
                _buildTabBar(),
                const SizedBox(height: 4),

                // TAB CONTENT
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _UpcomingTab(onOpenDetail: _openDetail),
                      _CompletedTab(onOpenDetail: _openDetail),
                      _CancelledTab(onOpenDetail: _openDetail),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding, 24, AppSpacing.screenPadding, 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr("my_bookings_title"),
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            tr("bookings_subtitle"),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerHeight: 0,
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          unselectedLabelStyle: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
          labelPadding: EdgeInsets.zero,
          padding: const EdgeInsets.all(3),
          tabs: [
            Tab(text: tr('booking_tab_upcoming')),
            Tab(text: tr('booking_tab_completed')),
            Tab(text: tr('booking_tab_cancelled')),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// UPCOMING TAB
// ─────────────────────────────────────────────────────────────
class _UpcomingTab extends StatelessWidget {
  final void Function(BookingDto) onOpenDetail;
  const _UpcomingTab({required this.onOpenDetail});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingsViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoadingAll && vm.allBookings.isEmpty) {
          return const BookingsSkeleton();
        }

        if (vm.allBookings.isEmpty) {
          return EmptyState(
            icon: SolarIconsOutline.calendarDate,
            title: 'empty_upcoming_title'.tr(),
            subtitle: 'empty_upcoming_subtitle'.tr(),
          );
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding, 12, AppSpacing.screenPadding, 24,
          ),
          itemCount: vm.allBookings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (_, i) => UpcomingBookingCard(
            item: vm.allBookings[i],
            onTap: () => onOpenDetail(vm.allBookings[i]),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// COMPLETED TAB
// ─────────────────────────────────────────────────────────────
class _CompletedTab extends StatelessWidget {
  final void Function(BookingDto) onOpenDetail;
  const _CompletedTab({required this.onOpenDetail});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingsViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoadingCompleted && vm.completedBookings.isEmpty) {
          return const BookingsSkeleton();
        }

        if (vm.completedBookings.isEmpty) {
          return EmptyState(
            icon: SolarIconsOutline.checkCircle,
            title: 'empty_completed_title'.tr(),
            subtitle: 'empty_completed_subtitle'.tr(),
          );
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding, 12, AppSpacing.screenPadding, 24,
          ),
          itemCount: vm.completedBookings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => PastBookingTile(
            item: vm.completedBookings[i],
            onTap: () => onOpenDetail(vm.completedBookings[i]),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CANCELLED TAB
// ─────────────────────────────────────────────────────────────
class _CancelledTab extends StatelessWidget {
  final void Function(BookingDto) onOpenDetail;
  const _CancelledTab({required this.onOpenDetail});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingsViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoadingCancelled && vm.cancelledBookings.isEmpty) {
          return const BookingsSkeleton();
        }

        if (vm.cancelledBookings.isEmpty) {
          return EmptyState(
            icon: SolarIconsOutline.closeCircle,
            title: 'empty_cancelled_title'.tr(),
            subtitle: 'empty_cancelled_subtitle'.tr(),
          );
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding, 12, AppSpacing.screenPadding, 24,
          ),
          itemCount: vm.cancelledBookings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => PastBookingTile(
            item: vm.cancelledBookings[i],
            onTap: () => onOpenDetail(vm.cancelledBookings[i]),
          ),
        );
      },
    );
  }
}
