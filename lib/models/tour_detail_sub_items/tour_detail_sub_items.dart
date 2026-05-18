import 'package:freezed_annotation/freezed_annotation.dart';

part 'tour_detail_sub_items.freezed.dart';
part 'tour_detail_sub_items.g.dart';

@freezed
class RoutePointItem with _$RoutePointItem {
  const factory RoutePointItem({
    required String name,
    String? description,
    required double latitude,
    required double longitude,
    required int orderIndex,
    required int pointType,
  }) = _RoutePointItem;

  factory RoutePointItem.fromJson(Map<String, dynamic> json) =>
      _$RoutePointItemFromJson(json);
}

@freezed
class HighlightItem with _$HighlightItem {
  const factory HighlightItem({
    required String text,
    required int orderIndex,
  }) = _HighlightItem;

  factory HighlightItem.fromJson(Map<String, dynamic> json) =>
      _$HighlightItemFromJson(json);
}

@freezed
class InclusionItem with _$InclusionItem {
  const factory InclusionItem({
    required String text,
    required bool isIncluded,
    required int orderIndex,
  }) = _InclusionItem;

  factory InclusionItem.fromJson(Map<String, dynamic> json) =>
      _$InclusionItemFromJson(json);
}

@freezed
class ImportantInfoItem with _$ImportantInfoItem {
  const factory ImportantInfoItem({
    required String text,
    required int orderIndex,
  }) = _ImportantInfoItem;

  factory ImportantInfoItem.fromJson(Map<String, dynamic> json) =>
      _$ImportantInfoItemFromJson(json);
}
