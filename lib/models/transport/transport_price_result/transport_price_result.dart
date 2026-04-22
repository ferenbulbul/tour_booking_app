import 'package:freezed_annotation/freezed_annotation.dart';

part 'transport_price_result.freezed.dart';
part 'transport_price_result.g.dart';

@freezed
class TransportPriceResult with _$TransportPriceResult {
  const factory TransportPriceResult({
    required double distanceKm,
    required int estimatedDurationMinutes,
    required num baseFee,
    required num pricePerKm,
    required num totalPrice,
    @Default('TRY') String currency,
  }) = _TransportPriceResult;

  factory TransportPriceResult.fromJson(Map<String, dynamic> json) =>
      _$TransportPriceResultFromJson(json);
}
