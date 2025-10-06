import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/booking/booking_dto.dart';

part 'booking_list_response.freezed.dart';
part 'booking_list_response.g.dart';

@freezed
class BookingListResponse with _$BookingListResponse {
  const factory BookingListResponse({
    required List<BookingDto> customerBookings,
  }) = _BookingListResponse;

  factory BookingListResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingListResponseFromJson(json);
}
