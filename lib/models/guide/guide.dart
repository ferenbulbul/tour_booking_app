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
    languages, // backend null dönerse map'lerken boş listeye düşebiliriz
    required String firstName,
    required String lastName,
    String? image,
  }) = _Guide;

  factory Guide.fromJson(Map<String, dynamic> json) => _$GuideFromJson(json);
}
