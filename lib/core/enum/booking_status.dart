enum BookingStatus { upcoming, completed, cancelled }

extension BookingStatusExt on BookingStatus {
  String get asQuery {
    switch (this) {
      case BookingStatus.upcoming:
        return "upcoming";
      case BookingStatus.completed:
        return "completed";
      case BookingStatus.cancelled:
        return "cancelled";
    }
  }
}
