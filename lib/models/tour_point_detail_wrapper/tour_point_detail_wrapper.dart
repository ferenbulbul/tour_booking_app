import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/tour_point_detail/tour_point_detail.dart';

part 'tour_point_detail_wrapper.freezed.dart';
part 'tour_point_detail_wrapper.g.dart';

@freezed
class TourPointDetailWrapper with _$TourPointDetailWrapper {
  const factory TourPointDetailWrapper({
    required TourPointDetail tourPointDetails,
  }) = _TourPointDetailWrapper;

  factory TourPointDetailWrapper.fromJson(Map<String, dynamic> json) =>
      _$TourPointDetailWrapperFromJson(json);
}
