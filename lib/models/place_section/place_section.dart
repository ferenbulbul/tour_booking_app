class PlaceSelection {
  final String description;
  final double? lat;
  final double? lng;

  const PlaceSelection({required this.description, this.lat, this.lng});
}

class TransportLocationsResult {
  final PlaceSelection? pickup;
  final PlaceSelection? dropoff;
  final double? distanceKm;
  final int? durationMinutes;
  final String? routePolyline;

  const TransportLocationsResult({
    this.pickup,
    this.dropoff,
    this.distanceKm,
    this.durationMinutes,
    this.routePolyline,
  });
}
