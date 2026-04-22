import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'search_vehicles_request.freezed.dart';
part 'search_vehicles_request.g.dart';

@freezed
class TransportSearchVehiclesRequest with _$TransportSearchVehiclesRequest {
  const factory TransportSearchVehiclesRequest({
    required String cityId,
    String? districtId,
    @JsonKey(toJson: _dateToString) required DateTime date,
    required String startTime,
    @Default(60) int estimatedDurationMinutes,
  }) = _TransportSearchVehiclesRequest;

  factory TransportSearchVehiclesRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$TransportSearchVehiclesRequestFromJson(json);
}

String _dateToString(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
