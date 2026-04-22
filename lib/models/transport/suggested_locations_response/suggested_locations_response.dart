import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/transport/suggested_location/suggested_location.dart';

part 'suggested_locations_response.freezed.dart';
part 'suggested_locations_response.g.dart';

@freezed
class TransportSuggestedLocationsResponse
    with _$TransportSuggestedLocationsResponse {
  const factory TransportSuggestedLocationsResponse({
    @Default([]) List<TransportSuggestedLocation> locations,
  }) = _TransportSuggestedLocationsResponse;

  factory TransportSuggestedLocationsResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$TransportSuggestedLocationsResponseFromJson(json);
}
