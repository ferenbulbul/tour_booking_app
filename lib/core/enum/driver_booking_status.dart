import 'package:easy_localization/easy_localization.dart';
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
        return tr('driver_status_today');
      case DriverBookingStatus.upcoming:
        return tr('driver_status_upcoming');
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
