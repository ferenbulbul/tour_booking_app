import 'package:freezed_annotation/freezed_annotation.dart';

part 'guide.freezed.dart';
part 'guide.g.dart';

@freezed
class Guide with _$Guide {
  const factory Guide({
    required String guideId,
    required num price,
    @Default(<String>[])
    List<String>
    languages, // Default to empty list if backend returns null
    required String firstName,
    required String lastName,
    String? image,
    double? avgRating,
    int? ratingCount,
  }) = _Guide;

  factory Guide.fromJson(Map<String, dynamic> json) => _$GuideFromJson(json);
}
