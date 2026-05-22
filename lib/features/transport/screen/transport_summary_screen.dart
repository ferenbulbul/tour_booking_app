import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_elevation.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/bottom_action_bar.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/transport/transport_summary_viewmodel.dart';
import 'package:tour_booking/features/transport/widget/transport_price_breakdown.dart';
import 'package:tour_booking/features/transport/widget/transport_route_map.dart';
import 'package:tour_booking/features/transport/transport_route_map_viewmodel.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

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
    context.push('/checkout/contact-info', extra: {
      'bookingType': 'transport',
      'transportVm': vm,
    });
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
                        padding: const EdgeInsets.all(AppSpacing.xxxl),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              vm.errorMessage ?? 'error_generic'.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: context.colors.error),
                            ),
                            const SizedBox(height: AppSpacing.l),
                            TextButton.icon(
                              onPressed: () => vm.calculatePrice(),
                              icon: const Icon(SolarIconsOutline.refresh, semanticLabel: 'Retry'),
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
                            ChangeNotifierProvider(
                              create: (_) => TransportRouteMapViewModel(),
                              child: TransportRouteMap(
                                pickupLat: vm.pickupLat!,
                                pickupLng: vm.pickupLng!,
                                dropoffLat: vm.dropoffLat!,
                                dropoffLng: vm.dropoffLng!,
                                height: 180,
                                fetchRoute: false,
                              ),
                            ),

                          const SizedBox(height: AppSpacing.l),

                          // Trip Info with timeline
                          _infoCard(
                            children: [
                              // Timeline: pickup → dropoff
                              _routeTimeline(
                                pickupText: vm.pickupAddress ?? '-',
                                dropoffText: vm.dropoffAddress ?? '-',
                              ),
                              const Divider(height: AppSpacing.xxl),
                              // Trip stats
                              _infoRow(
                                SolarIconsOutline.ruler,
                                context.colors.primary,
                                '${vm.priceResult!.distanceKm.toStringAsFixed(1)} km',
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              _infoRow(
                                SolarIconsOutline.stopwatch,
                                context.colors.primary,
                                '${vm.priceResult!.estimatedDurationMinutes} ${'transport_minutes'.tr()}',
                              ),
                              if (vm.selectedDate != null) ...[
                                const SizedBox(height: AppSpacing.sm),
                                _infoRow(
                                  SolarIconsOutline.calendarDate,
                                  context.colors.primary,
                                  DateFormat('dd MMMM yyyy', 'tr_TR')
                                      .format(vm.selectedDate!),
                                ),
                              ],
                              if (vm.selectedTime != null) ...[
                                const SizedBox(height: AppSpacing.sm),
                                _infoRow(
                                  SolarIconsOutline.clockCircle,
                                  context.colors.primary,
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
                                  style: AppTextStyles.titleSmall,
                                ),
                                const SizedBox(height: AppSpacing.s),
                                _infoRow(
                                    SolarIconsOutline.user,
                                    context.colors.onSurfaceVariant,
                                    '${vm.selectedVehicle!.seatCount} ${'transport_seats'.tr()}'),
                                const SizedBox(height: AppSpacing.xs),
                                _infoRow(SolarIconsOutline.user,
                                    context.colors.onSurfaceVariant,
                                    vm.selectedVehicle!.driverName),
                                const SizedBox(height: AppSpacing.xs),
                                _infoRow(SolarIconsOutline.buildings,
                                    context.colors.onSurfaceVariant,
                                    vm.selectedVehicle!.agencyName),
                              ],
                            ),

                          const SizedBox(height: AppSpacing.l),

                          // Price Breakdown
                          TransportPriceBreakdown(
                              price: vm.priceResult!),

                          const SizedBox(height: AppSpacing.massive),
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

  // ── Timeline widget for pickup → dropoff ──

  Widget _routeTimeline({
    required String pickupText,
    required String dropoffText,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left rail: dots + dashed line
          SizedBox(
            width: 20,
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xs),
                // Green dot (pickup)
                Container(
                  width: AppSpacing.m,
                  height: AppSpacing.m,
                  decoration: BoxDecoration(
                    color: context.ext.success,
                    shape: BoxShape.circle,
                  ),
                ),
                // Dashed connector
                Expanded(
                  child: CustomPaint(
                    painter: _DashedVerticalLinePainter(
                      color: context.colors.outline,
                    ),
                    child: const SizedBox(width: AppSpacing.xxs),
                  ),
                ),
                // Red dot (dropoff)
                Container(
                  width: AppSpacing.m,
                  height: AppSpacing.m,
                  decoration: BoxDecoration(
                    color: context.colors.error,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          // Right: addresses
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pickupText,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                Text(
                  dropoffText,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ──

  Widget _infoCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppElevation.shadowMd,
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
        Icon(icon, size: AppIconSize.m, color: color),
        const SizedBox(width: AppSpacing.ms),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Painters ──

class _DashedVerticalLinePainter extends CustomPainter {
  final Color color;
  _DashedVerticalLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const dashHeight = 4.0;
    const dashSpace = 3.0;
    double y = 0;
    final x = size.width / 2;

    while (y < size.height) {
      canvas.drawLine(Offset(x, y), Offset(x, y + dashHeight), paint);
      y += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
