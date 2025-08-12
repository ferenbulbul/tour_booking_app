import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/guide/guide.dart';

part 'tour_guides_response.freezed.dart';
part 'tour_guides_response.g.dart';

@freezed
class TourGuidesResponse with _$TourGuidesResponse {
  const factory TourGuidesResponse({@Default(<Guide>[]) List<Guide> guides}) =
      _TourGuidesResponse;

  factory TourGuidesResponse.fromJson(Map<String, dynamic> json) =>
      _$TourGuidesResponseFromJson(json);
}
