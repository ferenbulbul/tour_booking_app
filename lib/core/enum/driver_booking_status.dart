import 'package:freezed_annotation/freezed_annotation.dart';

enum DriverBookingStatus { upcoming, today }

extension DriverBookingStatusX on DriverBookingStatus {
  static DriverBookingStatus fromInt(int value) {
    switch (value) {
      case 1:
        return DriverBookingStatus.today;
      case 0:
      default:
        return DriverBookingStatus.upcoming;
    }
  }

  String get label {
    switch (this) {
      case DriverBookingStatus.today:
        return 'Bugün';
      case DriverBookingStatus.upcoming:
        return 'Yaklaşan';
    }
  }
}

class DriverBookingStatusConverter
    implements JsonConverter<DriverBookingStatus, int> {
  const DriverBookingStatusConverter();

  @override
  DriverBookingStatus fromJson(int json) {
    switch (json) {
      case 1:
        return DriverBookingStatus.today;
      case 0:
      default:
        return DriverBookingStatus.upcoming;
    }
  }

  @override
  int toJson(DriverBookingStatus object) {
    return object.index;
  }
}
