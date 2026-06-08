import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/checkout/screen/contact_info_screen.dart';
import 'package:tour_booking/features/checkout/viewmodel/contact_info_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_detail_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_booking_selection_viewmodel.dart';
import 'package:tour_booking/features/tour/booking/tour_vehicle_guide_viewmodel.dart';
import 'package:tour_booking/features/transport/transport_summary_viewmodel.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';

/// Checkout-related routes.
List<RouteBase> checkoutRoutes() => [
      GoRoute(
        path: '/checkout/contact-info',
        name: 'contactInfo',
        builder: (context, state) {
          final String bookingType;
          TransportSummaryViewModel? transportVm;
          if (state.extra is Map<String, dynamic>) {
            final args = state.extra as Map<String, dynamic>;
            bookingType = args['bookingType'] as String? ?? 'tour';
            transportVm = args['transportVm'] as TransportSummaryViewModel?;
          } else {
            bookingType =
                state.extra is String ? state.extra as String : 'tour';
          }
          return ChangeNotifierProvider(
            create: (_) => ContactInfoViewModel(),
            child: ContactInfoScreen(
              onContinue: (firstName, lastName, email, phone) async {
                final nav = GoRouter.of(context);
                final ctx = context;
                if (bookingType == 'transport') {
                  await transportVm!.createBooking(
                    buyerFirstName: firstName,
                    buyerLastName: lastName,
                    buyerEmail: email,
                    buyerPhone: phone,
                  );
                  if (!ctx.mounted) return;
                  if (transportVm.bookingId != null &&
                      transportVm.bookingId!.isNotEmpty) {
                    nav.push('/payment', extra: transportVm.bookingId);
                  } else if (transportVm.errorMessage != null) {
                    UIHelper.showError(ctx, transportVm.errorMessage!);
                  }
                } else {
                  final detailVm = context.read<TourDetailViewModel>();
                  final selectionVm =
                      context.read<TourBookingSelectionViewModel>();
                  final vehicleGuideVm =
                      context.read<TourVehicleGuideViewModel>();
                  await vehicleGuideVm.controlBooking(
                    buyerFirstName: firstName,
                    buyerLastName: lastName,
                    buyerEmail: email,
                    buyerPhone: phone,
                    cityId: detailVm.selectedCityId!,
                    districtId: detailVm.selectedDistrictId!,
                    tourPointId: detailVm.selectedTourPointId!,
                    date: selectionVm.selectedDate!,
                    departureTime: selectionVm.selectedTime!,
                    locationDescription: selectionVm.selectedPlaceDesc,
                    latitude: selectionVm.selectedPlaceLat,
                    longitude: selectionVm.selectedPlaceLng,
                  );
                  if (!ctx.mounted) return;
                  if (vehicleGuideVm.isValid &&
                      vehicleGuideVm.bookingId != null) {
                    nav.push('/payment', extra: vehicleGuideVm.bookingId);
                  } else if (vehicleGuideVm.errorMessage != null) {
                    UIHelper.showError(ctx, vehicleGuideVm.errorMessage!);
                  }
                }
              },
            ),
          );
        },
      ),
    ];
