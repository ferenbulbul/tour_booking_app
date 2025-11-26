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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TabBar(
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 2.5,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.black.withOpacity(0.5),
                  tabs: const [
                    Tab(text: "Yaklaşan"),
                    Tab(text: "Tamamlanan"),
                    Tab(text: "İptal Edilen"),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  children: [
                    Builder(
                      builder: (context) {
                        final index = DefaultTabController.of(context).index;
                        return _list(
                          vm.allBookings,
                          vm.isLoadingAll,
                          index,
                          showCancelAction: true,
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final index = DefaultTabController.of(context).index;
                        return _list(
                          vm.completedBookings,
                          vm.isLoadingCompleted,
                          index,
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final index = DefaultTabController.of(context).index;
                        return _list(
                          vm.cancelledBookings,
                          vm.isLoadingCancelled,
                          index,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _list(
    List bookings,
    bool loading,
    int tabIndex, {
    bool showCancelAction = false,
  }) {
    if (loading) {
      return const BookingsSkeleton();
    }

    if (bookings.isEmpty) {
      if (tabIndex == 0) return buildEmptyBookings("upcoming");
      if (tabIndex == 1) return buildEmptyBookings("completed");
      if (tabIndex == 2) return buildEmptyBookings("cancelled");
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (_, i) =>
          BookingCard(item: bookings[i], showCancelAction: showCancelAction),
    );
  }
}

Widget buildEmptyBookings(String type) {
  IconData icon;
  String title;
  String subtitle;

  switch (type) {
    case "upcoming":
      icon = Icons.event_available_outlined;
      title = "Yaklaşan rezervasyonun yok";
      subtitle = "Yeni bir tur seçerek planını oluşturabilirsin.";
      break;

    case "completed":
      icon = Icons.check_circle_outline;
      title = "Tamamlanan bir turun bulunmuyor";
      subtitle = "Katıldığın turlar burada görünecek.";
      break;

    case "cancelled":
      icon = Icons.cancel_outlined;
      title = "İptal edilen rezervasyon yok";
      subtitle = "Şu anda iptal edilmiş bir kaydın bulunmuyor.";
      break;

    default:
      icon = Icons.inbox_outlined;
      title = "Kayıt bulunamadı";
      subtitle = "";
  }

  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.black26),

          const SizedBox(height: 20),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
