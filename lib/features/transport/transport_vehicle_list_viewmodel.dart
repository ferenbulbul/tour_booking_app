import 'package:flutter/material.dart';
import 'package:tour_booking/models/transport/search_vehicles_request/search_vehicles_request.dart';
import 'package:tour_booking/models/transport/transport_vehicle/transport_vehicle.dart';
import 'package:tour_booking/services/transport/transport_service.dart';

class TransportVehicleListViewModel extends ChangeNotifier {
  final TransportService _service = TransportService();

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
        errorMessage = resp.message ?? 'error_generic';
      }
    } catch (e) {
      vehicles = [];
      errorMessage = 'error_generic';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
