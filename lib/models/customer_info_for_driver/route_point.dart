import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_point.freezed.dart';
part 'route_point.g.dart';

@freezed
class RoutePoint with _$RoutePoint {
  const factory RoutePoint({
    required String name,
    required double latitude,
    required double longitude,
    required int orderIndex,
  }) = _RoutePoint;

  factory RoutePoint.fromJson(Map<String, dynamic> json) =>
      _$RoutePointFromJson(json);
}
