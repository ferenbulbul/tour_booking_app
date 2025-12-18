import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/enum/booking_status.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/widgets/empty_state.dart';
import 'package:tour_booking/features/bookings/bookings_viewmodel.dart';
import 'package:tour_booking/features/bookings/widget/booking_card.dart';
import 'package:tour_booking/features/bookings/widget/booking_skelaton.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final vm = context.read<BookingsViewModel>();
      vm.fetchBookingsByStatus(BookingStatus.upcoming);
      vm.fetchBookingsByStatus(BookingStatus.completed);
      vm.fetchBookingsByStatus(BookingStatus.cancelled);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingsViewModel>();
    final scheme = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: scheme.surface,
        appBar: CommonAppBar(title: 'my_bookings_title'.tr(), showBack: false),
        body: Column(
          children: [
            // -----------------------------------------------------------------
            // TAB BAR (premium)
            // -----------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.black54,
                labelStyle: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: AppTextStyles.labelLarge,
                tabs: [
                  Tab(text: 'booking_tab_upcoming'.tr()),
                  Tab(text: 'booking_tab_completed'.tr()),
                  Tab(text: 'booking_tab_cancelled'.tr()),
                ],
              ),
            ),

            // -----------------------------------------------------------------
            // CONTENT
            // -----------------------------------------------------------------
            Expanded(
              child: TabBarView(
                children: [
                  _list(
                    bookings: vm.allBookings,
                    loading: vm.isLoadingAll,
                    type: BookingStatus.upcoming,
                    showCancelAction: true,
                  ),
                  _list(
                    bookings: vm.completedBookings,
                    loading: vm.isLoadingCompleted,
                    type: BookingStatus.completed,
                  ),
                  _list(
                    bookings: vm.cancelledBookings,
                    loading: vm.isLoadingCancelled,
                    type: BookingStatus.cancelled,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // LIST BUILDER
  // -------------------------------------------------------------------------
  Widget _list({
    required List bookings,
    required bool loading,
    required BookingStatus type,
    bool showCancelAction = false,
  }) {
    if (loading) {
      return const BookingsSkeleton();
    }

    if (bookings.isEmpty) {
      switch (type) {
        case BookingStatus.upcoming:
          return EmptyState(
            icon: Icons.event_available_outlined,
            title: 'empty_upcoming_title'.tr(),
            subtitle: 'empty_upcoming_subtitle'.tr(),
          );

        case BookingStatus.completed:
          return EmptyState(
            icon: Icons.check_circle_outline,
            title: 'empty_completed_title'.tr(),
            subtitle: 'empty_completed_subtitle'.tr(),
          );

        case BookingStatus.cancelled:
          return EmptyState(
            icon: Icons.cancel_outlined,
            title: 'empty_cancelled_title'.tr(),
            subtitle: 'empty_cancelled_subtitle'.tr(),
          );
      }
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) =>
          BookingCard(item: bookings[i], showCancelAction: showCancelAction),
    );
  }
}
