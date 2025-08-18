import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class DecimalConverter implements JsonConverter<Decimal, dynamic> {
  const DecimalConverter();

  @override
  Decimal fromJson(dynamic json) {
    if (json is String) return Decimal.parse(json);
    if (json is num) return Decimal.parse(json.toString());
    throw Exception('Invalid type for Decimal: $json');
  }

  @override
  dynamic toJson(Decimal object) => object.toString();
}
