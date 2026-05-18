import 'package:flutter/material.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/models/featured_tour_point/featured_tour_point_dto.dart';
import 'package:tour_booking/models/featured_tour_point_list/featured_tour_point_list_dto.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class FavoriteViewModel extends ChangeNotifier {
  final TourService _service = TourService();

  bool isLoading = false;
  String? message;

  /// Favoriler listesi (ekran için)
  List<FeaturedTourPointDto> favorites = [];

  /// 🔥 GERÇEK SOURCE OF TRUTH
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  /// ❤️ Favori mi?
  bool isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  /// 📥 Favorileri API'den çek
  Future<void> fetchFavorites() async {
    try {
      isLoading = true;
      notifyListeners();

      final resp = await _service.getFavorites();
      final result = handleResponse<FeaturedTourPointListDto>(resp);

      if (result.isSuccess && result.data != null) {
        favorites = result.data!.tourPoints;

        _favoriteIds
          ..clear()
          ..addAll(favorites.map((f) => f.id));

        message = null;
      } else {
        favorites = [];
        _favoriteIds.clear();
        message = resp.message ?? "Favoriler alınamadı";
      }
    } catch (e) {
      favorites = [];
      _favoriteIds.clear();
      message = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🔁 FAVORİ EKLE / ÇIKAR (HER YERDE AYNI)
  Future<void> toggleFavorite(String id) async {
    final wasFavorite = _favoriteIds.contains(id);

    // 🔥 OPTIMISTIC UPDATE
    FeaturedTourPointDto? removedItem;
    if (wasFavorite) {
      _favoriteIds.remove(id);
      removedItem = favorites.cast<FeaturedTourPointDto?>().firstWhere(
            (f) => f?.id == id,
            orElse: () => null,
          );
      favorites = favorites.where((f) => f.id != id).toList();
    } else {
      _favoriteIds.add(id);
    }

    notifyListeners();

    try {
      await _service.ToggleFavorite(id);
    } catch (e) {
      // 🔴 ROLLBACK
      if (wasFavorite) {
        _favoriteIds.add(id);
        if (removedItem != null) {
          favorites = [...favorites, removedItem];
        }
      } else {
        _favoriteIds.remove(id);
      }
      notifyListeners();
    }
  }
}
