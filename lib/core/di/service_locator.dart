import 'package:tour_booking/services/auth/auth_service.dart';
import 'package:tour_booking/services/driver/driver_service.dart';
import 'package:tour_booking/services/google_places/google_place_service.dart';
import 'package:tour_booking/services/location/location_permission_service.dart';
import 'package:tour_booking/services/location/location_service.dart';
import 'package:tour_booking/services/payment/payment_service.dart';
import 'package:tour_booking/services/recent_search/recent_search_service.dart';
import 'package:tour_booking/services/tour/tour_service.dart';
import 'package:tour_booking/services/transport/transport_service.dart';

/// Lightweight service locator — single point of service instantiation.
///
/// Call [ServiceLocator.instance.init()] once in `main()` before `runApp()`.
class ServiceLocator {
  ServiceLocator._();
  static final instance = ServiceLocator._();

  late final TourService tourService;
  late final AuthService authService;
  late final TransportService transportService;
  late final DriverService driverService;
  late final PaymentService paymentService;
  late final GooglePlaceService googlePlaceService;
  late final LocationPermissionService locationPermissionService;
  late final LocationService locationService;
  late final RecentSearchService recentSearchService;

  void init() {
    tourService = TourService();
    authService = AuthService();
    transportService = TransportService();
    driverService = DriverService();
    paymentService = PaymentService();
    googlePlaceService = GooglePlaceService();
    locationPermissionService = LocationPermissionService();
    locationService = LocationService();
    recentSearchService = RecentSearchService();
  }
}
