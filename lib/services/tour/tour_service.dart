import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/city/city_dto.dart';
import 'package:tour_booking/models/city_list/city_list_response.dart';
import 'package:tour_booking/models/create_booking_request/create_booking_command.dart';
import 'package:tour_booking/models/district_list/district_list_response.dart';
import 'package:tour_booking/models/featured_tour_point_list/featured_tour_point_list_dto.dart';
import 'package:tour_booking/models/is_valid_response/is_valid_response.dart';
import 'package:tour_booking/models/region_list/region_list_response.dart';
import 'package:tour_booking/models/tour_guide_request/tour_guide_request.dart';
import 'package:tour_booking/models/tour_guides_response/tour_guides_response.dart';
import 'package:tour_booking/models/tour_point_detail/tour_point_detail.dart';
import 'package:tour_booking/models/tour_point_detail_wrapper/tour_point_detail_wrapper.dart';
import 'package:tour_booking/models/tour_search/mobile_tour_points_by_search_dto.dart';
import 'package:tour_booking/models/tour_search_detail_request/tour_search_detailed_request.dart';
import 'package:tour_booking/models/tour_search_list/mobile_tour_points_response.dart';
import 'package:tour_booking/models/tour_search_response/tour_search_response.dart';
import 'package:tour_booking/models/tour_types/tour_types_dto.dart';
import 'package:tour_booking/models/tour_vehicle_request/tour_vehicle_request.dart';
import 'package:tour_booking/models/vehicle/vehicle.dart';
import 'package:tour_booking/models/vehicle_detail/vehicle_detail.dart';
import 'package:tour_booking/models/vehicle_detail_response/vehicle_detail_response.dart';
import 'package:tour_booking/models/vehicle_response/tour_vehicle_response.dart';
import 'package:tour_booking/services/core/api_client.dart';

class TourService {
  final ApiClient _apiClient;

  TourService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<BaseResponse<TourTypesDto>> getTourTypes() async {
    var response = _apiClient.get<TourTypesDto>(
      path: "/Mobile/tourTypes",
      fromJson: (json) => TourTypesDto.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }

  Future<BaseResponse<FeaturedTourPointListDto>> getFeaturedTourPoints() {
    return _apiClient.get<FeaturedTourPointListDto>(
      path: '/Mobile/highlightedTourPoints',
      fromJson: (json) =>
          FeaturedTourPointListDto.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<BaseResponse<MobileTourPointsResponse>> getTourTypesSearch(
    String query,
  ) async {
    var response = _apiClient.get<MobileTourPointsResponse>(
      path: "/Mobile/tour-points-by-query",
      queryParams: {'query': query},
      fromJson: (json) =>
          MobileTourPointsResponse.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }

  Future<BaseResponse<MobileRegionListResponse>> getRegions() async {
    var response = _apiClient.get<MobileRegionListResponse>(
      path: "/Mobile/regions",
      fromJson: (json) =>
          MobileRegionListResponse.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }

  Future<BaseResponse<MobileCityListResponse>> getCities(
    String regionId,
  ) async {
    var response = _apiClient.get<MobileCityListResponse>(
      path: "/Mobile/cities",
      queryParams: {'regionId': regionId},
      fromJson: (json) =>
          MobileCityListResponse.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }

  Future<BaseResponse<MobileDistrictListResponse>> getDistricts(
    String cityId,
  ) async {
    var response = _apiClient.get<MobileDistrictListResponse>(
      path: "/Mobile/districts",
      queryParams: {'cityId': cityId},
      fromJson: (json) =>
          MobileDistrictListResponse.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }

  Future<BaseResponse<TourSearchResponse>> searchTourPoints(
    TourSearchRequest request,
  ) async {
    var response = _apiClient.post<TourSearchResponse>(
      path: "/Mobile/detailed-search",
      body: request.toJson(),
      fromJson: (json) =>
          TourSearchResponse.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }

  Future<BaseResponse<TourPointDetailWrapper>> getTourPointDetail(
    String id,
  ) async {
    var response = _apiClient.get<TourPointDetailWrapper>(
      path: "/Mobile/tour-point-details",
      queryParams: {'tourPointId': id},
      fromJson: (json) =>
          TourPointDetailWrapper.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }

  Future<BaseResponse<TourVehicleResponse>> getVehicles(
    TourVehicleRequest request,
  ) async {
    var response = _apiClient.post<TourVehicleResponse>(
      path: "/Mobile/search-vehicle",
      body: request.toJson(),
      fromJson: (json) =>
          TourVehicleResponse.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }

  Future<BaseResponse<VehicleResponse>> getVehicle(String vehicleId) async {
    var response = _apiClient.get<VehicleResponse>(
      path: "/Mobile/vehicle-detail",
      queryParams: {'vehicleId': vehicleId},
      fromJson: (json) =>
          VehicleResponse.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }

  Future<BaseResponse<TourGuidesResponse>> searchGuide(
    TourGuideRequest request,
  ) async {
    var response = _apiClient.post<TourGuidesResponse>(
      path: "/Mobile/search-guide",
      body: request.toJson(),
      fromJson: (json) =>
          TourGuidesResponse.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }

  Future<BaseResponse<IsValidResponse>> ControlBooking(
    CreateBookingCommand request,
  ) async {
    var b = request.toJson();
    print(b);
    var response = _apiClient.post<IsValidResponse>(
      path: "/Mobile/create-booking",
      body: request.toJson(),
      fromJson: (json) =>
          IsValidResponse.fromJson(json as Map<String, dynamic>),
    );
    return response;
  }
}
