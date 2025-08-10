import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'tour_vehicle_request.freezed.dart';
part 'tour_vehicle_request.g.dart';

@freezed
class TourVehicleRequest with _$TourVehicleRequest {
  const factory TourVehicleRequest({
    required String cityId,
    required String districtId,
    required String tourPointId,

    @JsonKey(toJson: _dateToString) required DateTime date,
  }) = _TourVehicleRequest;

  factory TourVehicleRequest.fromJson(Map<String, dynamic> json) =>
      _$TourVehicleRequestFromJson(json);
}

// DateTime → String (örn. "2025-08-19")
String _dateToString(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
