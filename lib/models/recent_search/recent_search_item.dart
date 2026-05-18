import 'dart:convert';

class RecentSearchItem {
  final String id;
  final String name;
  final String type;
  final DateTime timestamp;
  final String? cityId;
  final String? cityName;
  final String? image;

  const RecentSearchItem({
    required this.id,
    required this.name,
    required this.type,
    required this.timestamp,
    this.cityId,
    this.cityName,
    this.image,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'timestamp': timestamp.toIso8601String(),
        if (cityId != null) 'cityId': cityId,
        if (cityName != null) 'cityName': cityName,
        if (image != null) 'image': image,
      };

  factory RecentSearchItem.fromJson(Map<String, dynamic> json) {
    return RecentSearchItem(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      cityId: json['cityId'] as String?,
      cityName: json['cityName'] as String?,
      image: json['image'] as String?,
    );
  }

  static List<RecentSearchItem> fromJsonList(String jsonString) {
    if (jsonString.isEmpty) return [];
    final List<dynamic> list = json.decode(jsonString) as List<dynamic>;
    return list
        .map((e) => RecentSearchItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String toJsonList(List<RecentSearchItem> items) {
    return json.encode(items.map((e) => e.toJson()).toList());
  }
}
