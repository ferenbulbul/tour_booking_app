enum BookingType {
  tour,
  transport;

  static BookingType fromInt(int value) {
    switch (value) {
      case 1:
        return BookingType.transport;
      case 0:
      default:
        return BookingType.tour;
    }
  }
}
