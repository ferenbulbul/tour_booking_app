import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggested_location.freezed.dart';
part 'suggested_location.g.dart';

@freezed
class SuggestedLocationTranslation with _$SuggestedLocationTranslation {
  const factory SuggestedLocationTranslation({
    String? languageCode,
    @Default('') String name,
    String? description,
  }) = _SuggestedLocationTranslation;

  factory SuggestedLocationTranslation.fromJson(Map<String, dynamic> json) =>
      _$SuggestedLocationTranslationFromJson(json);
}

@freezed
class TransportSuggestedLocation with _$TransportSuggestedLocation {
  const TransportSuggestedLocation._();

  const factory TransportSuggestedLocation({
    required String id,
    required double latitude,
    required double longitude,
    required String cityId,
    String? districtId,
    @Default(true) bool isActive,
    @Default([]) List<SuggestedLocationTranslation> translations,
  }) = _TransportSuggestedLocation;

  factory TransportSuggestedLocation.fromJson(Map<String, dynamic> json) =>
      _$TransportSuggestedLocationFromJson(json);

  String get name => translations.isNotEmpty
      ? translations.first.name
      : 'Konum';

  String? get description => translations.isNotEmpty
      ? translations.first.description
      : null;
}
