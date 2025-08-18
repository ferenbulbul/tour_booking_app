import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/tour_point/tour_point.dart';

part 'tour_search_response.freezed.dart';
part 'tour_search_response.g.dart';

@freezed
class TourSearchResponse with _$TourSearchResponse {
  factory TourSearchResponse({List<TourPoint>? tourPoints}) =
      _TourSearchResponse;

  factory TourSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$TourSearchResponseFromJson(json);
}
