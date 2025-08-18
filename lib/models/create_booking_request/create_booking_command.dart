import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:tour_booking/models/decimal_converter/decimal_converter.dart';

part 'create_booking_command.freezed.dart';
part 'create_booking_command.g.dart';

@freezed
class CreateBookingCommand with _$CreateBookingCommand {
  const factory CreateBookingCommand({
    required String tourPointId,
    String? guideId,
    required String cityId,
    required String districtId,
    required String vehicleId,
    @DecimalConverter() required Decimal tourPrice,
    @DecimalConverter() Decimal? guidePrice,

    @JsonKey(toJson: _dateToString) required DateTime date,
  }) = _CreateBookingCommand;

  factory CreateBookingCommand.fromJson(Map<String, dynamic> json) =>
      _$CreateBookingCommandFromJson(json);
}

String _dateToString(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
