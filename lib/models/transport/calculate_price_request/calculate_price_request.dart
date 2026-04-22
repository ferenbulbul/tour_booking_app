import 'package:freezed_annotation/freezed_annotation.dart';

part 'calculate_price_request.freezed.dart';
part 'calculate_price_request.g.dart';

@freezed
class TransportCalculatePriceRequest with _$TransportCalculatePriceRequest {
  const factory TransportCalculatePriceRequest({
    required String transportPricingId,
    required double pickupLatitude,
    required double pickupLongitude,
    required double dropoffLatitude,
    required double dropoffLongitude,
    double? clientDistanceKm,
    int? clientDurationMinutes,
  }) = _TransportCalculatePriceRequest;

  factory TransportCalculatePriceRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$TransportCalculatePriceRequestFromJson(json);
}
