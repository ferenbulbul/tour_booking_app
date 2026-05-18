import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_booking/models/recent_search/recent_search_item.dart';

class RecentSearchService {
  static const String _key = 'recent_searches';
  static const String _clickKey = 'recent_tour_clicks';
  static const int _maxItems = 10;

  // ════════════════════════════════════════════════════════════════
  // Son Aramalar
  // ════════════════════════════════════════════════════════════════
  Future<List<RecentSearchItem>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key) ?? '';
    if (jsonString.isEmpty) return [];
    return RecentSearchItem.fromJsonList(jsonString);
  }

  Future<void> addRecentSearch(RecentSearchItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getRecentSearches();

    // Remove duplicate if exists
    items.removeWhere((e) => e.id == item.id);

    // Add to beginning
    items.insert(0, item);

    // Keep max items
    if (items.length > _maxItems) {
      items.removeRange(_maxItems, items.length);
    }

    await prefs.setString(_key, RecentSearchItem.toJsonList(items));
  }

  Future<void> removeRecentSearch(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getRecentSearches();
    items.removeWhere((e) => e.id == id);
    await prefs.setString(_key, RecentSearchItem.toJsonList(items));
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  // ════════════════════════════════════════════════════════════════
  // Son Tıklanan Turlar (şehir bazlı)
  // ════════════════════════════════════════════════════════════════
  Future<List<Map<String, String>>> getRecentTourClicks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_clickKey) ?? '';
    if (jsonString.isEmpty) return [];
    final List<dynamic> list = json.decode(jsonString);
    return list
        .map((e) => {
              'cityId': e['cityId'] as String,
              'cityName': e['cityName'] as String,
            })
        .toList();
  }

  Future<void> addTourClick({
    required String cityId,
    required String cityName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final clicks = await getRecentTourClicks();

    // Aynı şehri kaldır (en üste taşıyacağız)
    clicks.removeWhere((e) => e['cityId'] == cityId);

    // Başa ekle
    clicks.insert(0, {'cityId': cityId, 'cityName': cityName});

    // Max 10 tut
    if (clicks.length > _maxItems) {
      clicks.removeRange(_maxItems, clicks.length);
    }

    await prefs.setString(_clickKey, json.encode(clicks));
  }
}
