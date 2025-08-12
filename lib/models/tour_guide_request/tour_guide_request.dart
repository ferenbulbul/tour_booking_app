import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'tour_guide_request.freezed.dart';
part 'tour_guide_request.g.dart';

@freezed
class TourGuideRequest with _$TourGuideRequest {
  const factory TourGuideRequest({
    required String cityId,
    required String districtId,
    required String tourPointId,
    @JsonKey(toJson: _dateToString) required DateTime date,
  }) = _TourGuideRequest;

  factory TourGuideRequest.fromJson(Map<String, dynamic> json) =>
      _$TourGuideRequestFromJson(json);
}

String _dateToString(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
