import 'package:easy_localization/easy_localization.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/models/transport/search_vehicles_request/search_vehicles_request.dart';
import 'package:tour_booking/models/transport/transport_vehicle/transport_vehicle.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/transport/transport_service.dart';

class TransportVehicleListViewModel extends BaseViewModel {
  final TransportService _service = ServiceLocator.instance.transportService;

  bool isLoading = false;
  String? errorMessage;
  List<TransportVehicle> vehicles = [];

  Future<void> searchVehicles(TransportSearchVehiclesRequest request) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final resp = await _service.searchVehicles(request);
      if (resp.isSuccess == true && resp.data != null) {
        vehicles = resp.data!.vehicles;
      } else {
        vehicles = [];
        errorMessage = resp.message ?? tr('error_generic');
      }
    } catch (e) {
      vehicles = [];
      errorMessage = tr('error_generic');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
