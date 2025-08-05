import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/featured_tour_point_list/featured_tour_point_list_dto.dart';
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
}
