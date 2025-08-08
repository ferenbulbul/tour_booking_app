import 'package:freezed_annotation/freezed_annotation.dart';

part 'tour_search_detailed_request.freezed.dart';
part 'tour_search_detailed_request.g.dart';

@freezed
class TourSearchRequest with _$TourSearchRequest {
  const factory TourSearchRequest({
    required int type,
    String? regionId,
    String? cityId,
    String? districtId,
  }) = _TourSearchRequest;

  factory TourSearchRequest.fromJson(Map<String, dynamic> json) =>
      _$TourSearchRequestFromJson(json);
}
