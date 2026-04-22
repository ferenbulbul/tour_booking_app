import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/transport/calculate_price_request/calculate_price_request.dart';
import 'package:tour_booking/models/transport/complete_dropoff_request/complete_dropoff_request.dart';
import 'package:tour_booking/models/transport/create_transport_booking_request/create_transport_booking_request.dart';
import 'package:tour_booking/models/transport/search_vehicles_request/search_vehicles_request.dart';
import 'package:tour_booking/models/transport/suggested_locations_response/suggested_locations_response.dart';
import 'package:tour_booking/models/transport/transport_booking_response/transport_booking_response.dart';
import 'package:tour_booking/models/transport/transport_price_result/transport_price_result.dart';
import 'package:tour_booking/models/transport/transport_vehicles_response/transport_vehicles_response.dart';
import 'package:tour_booking/services/core/api_client.dart';

class TransportService {
  final ApiClient _apiClient;

  TransportService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<BaseResponse<TransportSuggestedLocationsResponse>>
      getSuggestedLocations(String cityId) {
    return _apiClient.get<TransportSuggestedLocationsResponse>(
      path: '/mobile/transport/suggested-locations',
      queryParams: {'cityId': cityId},
      fromJson: (json) => TransportSuggestedLocationsResponse.fromJson(
        json as Map<String, dynamic>,
      ),
    );
  }

  Future<BaseResponse<TransportVehiclesResponse>> searchVehicles(
    TransportSearchVehiclesRequest request,
  ) {
    return _apiClient.post<TransportVehiclesResponse>(
      path: '/mobile/transport/search-vehicles',
      body: request.toJson(),
      fromJson: (json) => TransportVehiclesResponse.fromJson(
        json as Map<String, dynamic>,
      ),
    );
  }

  Future<BaseResponse<TransportPriceResult>> calculatePrice(
    TransportCalculatePriceRequest request,
  ) {
    return _apiClient.post<TransportPriceResult>(
      path: '/mobile/transport/calculate-price',
      body: request.toJson(),
      fromJson: (json) => TransportPriceResult.fromJson(
        json as Map<String, dynamic>,
      ),
    );
  }

  Future<BaseResponse<TransportBookingResponse>> createBooking(
    CreateTransportBookingRequest request,
  ) {
    return _apiClient.post<TransportBookingResponse>(
      path: '/mobile/transport/create-booking',
      body: request.toJson(),
      fromJson: (json) => TransportBookingResponse.fromJson(
        json as Map<String, dynamic>,
      ),
    );
  }

  Future<BaseResponse<void>> completeDropoff(
    TransportCompleteDropoffRequest request,
  ) {
    return _apiClient.post<void>(
      path: '/mobile/transport/complete-dropoff',
      body: request.toJson(),
    );
  }
}
