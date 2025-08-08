import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/city/city_dto.dart';
import 'package:tour_booking/models/city_list/city_list_response.dart';
import 'package:tour_booking/models/district_list/district_list_response.dart';
import 'package:tour_booking/models/featured_tour_point_list/featured_tour_point_list_dto.dart';
import 'package:tour_booking/models/region_list/region_list_response.dart';
import 'package:tour_booking/models/tour_search/mobile_tour_points_by_search_dto.dart';
import 'package:tour_booking/models/tour_search_detail_request/tour_search_detailed_request.dart';
import 'package:tour_booking/models/tour_search_list/mobile_tour_points_response.dart';
import 'package:tour_booking/models/tour_search_response/tour_search_response.dart';
import 'package:tour_booking/models/tour_types/tour_types_dto.dart';
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
}
