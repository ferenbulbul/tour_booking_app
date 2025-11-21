import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/enum/booking_status.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text("Rezervasyonlarım")),
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Column(
            children: [
              // --- MINIMAL TABBAR (arkada kutu yok) ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TabBar(
                  // sadece alt çizgi + renk
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 2.5,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.black.withOpacity(0.5),
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: "Yaklaşan"),
                    Tab(text: "Tamamlanan"),
                    Tab(text: "İptal Edilen"),
                  ],
                ),
              ),

              // --- TABBAR VIEW ---
              Expanded(
                child: TabBarView(
                  children: [
                    _list(
                      vm.allBookings,
                      vm.isLoadingAll,
                      showCancelAction: true, // sadece Tümü
                    ),
                    _list(vm.completedBookings, vm.isLoadingCompleted),
                    _list(vm.cancelledBookings, vm.isLoadingCancelled),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _list(List bookings, bool loading, {bool showCancelAction = false}) {
    if (loading) {
      return const BookingsSkeleton();
    }

    if (bookings.isEmpty) {
      return const Center(
        child: Text(
          "Bu kategoride kayıt bulunmuyor.",
          style: TextStyle(fontSize: 15),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (_, i) =>
          BookingCard(item: bookings[i], showCancelAction: showCancelAction),
    );
  }
}
