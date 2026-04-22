import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/widgets/bottom_action_bar.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/transport/transport_summary_viewmodel.dart';
import 'package:tour_booking/features/transport/widget/transport_price_breakdown.dart';
import 'package:tour_booking/features/transport/widget/transport_route_map.dart';
import 'package:tour_booking/navigation/app_router.dart';

class TransportSummaryScreen extends StatefulWidget {
  const TransportSummaryScreen({super.key});

  @override
  State<TransportSummaryScreen> createState() => _TransportSummaryScreenState();
}

class _TransportSummaryScreenState extends State<TransportSummaryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransportSummaryViewModel>().calculatePrice();
    });
  }

  Future<void> _handleBooking(TransportSummaryViewModel vm) async {
    if (!splashViewModel.isLoggedInStatus) {
      context.push('/login');
      return;
    }

    context.push('/checkout/contact-info', extra: 'transport');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransportSummaryViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: CommonAppBar(title: 'transport_summary'.tr()),
          body: vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : vm.priceResult == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              vm.errorMessage ?? 'error_generic'.tr(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: () => vm.calculatePrice(),
                              icon: const Icon(Icons.refresh),
                              label: Text('retry'.tr()),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding:
                          const EdgeInsets.all(AppSpacing.screenPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Static route map (read-only)
                          if (vm.pickupLat != null &&
                              vm.dropoffLat != null)
                            TransportRouteMap(
                              pickupLat: vm.pickupLat!,
                              pickupLng: vm.pickupLng!,
                              dropoffLat: vm.dropoffLat!,
                              dropoffLng: vm.dropoffLng!,
                              height: 180,
                              fetchRoute: false,
                            ),

                          const SizedBox(height: AppSpacing.l),

                          // Trip Info
                          _infoCard(
                            children: [
                              _infoRow(Icons.circle, Colors.green,
                                  vm.pickupAddress ?? '-'),
                              const SizedBox(height: 8),
                              _infoRow(Icons.circle, Colors.red,
                                  vm.dropoffAddress ?? '-'),
                              const Divider(height: 20),
                              _infoRow(
                                Icons.straighten,
                                AppColors.primary,
                                '${vm.priceResult!.distanceKm.toStringAsFixed(1)} km',
                              ),
                              const SizedBox(height: 6),
                              _infoRow(
                                Icons.timer_outlined,
                                AppColors.primary,
                                '${vm.priceResult!.estimatedDurationMinutes} ${'transport_minutes'.tr()}',
                              ),
                              if (vm.selectedDate != null) ...[
                                const SizedBox(height: 6),
                                _infoRow(
                                  Icons.calendar_today,
                                  AppColors.primary,
                                  DateFormat('dd MMMM yyyy', 'tr_TR')
                                      .format(vm.selectedDate!),
                                ),
                              ],
                              if (vm.selectedTime != null) ...[
                                const SizedBox(height: 6),
                                _infoRow(
                                  Icons.access_time,
                                  AppColors.primary,
                                  vm.selectedTime!,
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: AppSpacing.l),

                          // Vehicle Info
                          if (vm.selectedVehicle != null)
                            _infoCard(
                              children: [
                                Text(
                                  '${vm.selectedVehicle!.brandName} ${vm.selectedVehicle!.className}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _infoRow(
                                    Icons.airline_seat_recline_normal,
                                    Colors.grey,
                                    '${vm.selectedVehicle!.seatCount} ${'transport_seats'.tr()}'),
                                const SizedBox(height: 4),
                                _infoRow(Icons.person_outline, Colors.grey,
                                    vm.selectedVehicle!.driverName),
                                const SizedBox(height: 4),
                                _infoRow(Icons.business, Colors.grey,
                                    vm.selectedVehicle!.agencyName),
                              ],
                            ),

                          const SizedBox(height: AppSpacing.l),

                          // Price Breakdown
                          TransportPriceBreakdown(
                              price: vm.priceResult!),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
          bottomNavigationBar: vm.priceResult != null
              ? BottomActionBar(
                  price: vm.priceResult!.totalPrice,
                  buttonText: vm.isBooking
                      ? 'loading'.tr()
                      : 'transport_book_now'.tr(),
                  onPressed: vm.isBooking
                      ? () {}
                      : () => _handleBooking(vm),
                )
              : null,
        );
      },
    );
  }

  Widget _infoCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _infoRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
