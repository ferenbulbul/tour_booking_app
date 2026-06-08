import 'package:easy_localization/easy_localization.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/models/featured_tour_point/featured_tour_point_dto.dart';
import 'package:tour_booking/models/featured_tour_point_list/featured_tour_point_list_dto.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class FavoriteViewModel extends BaseViewModel {
  final TourService _service = ServiceLocator.instance.tourService;

  bool isLoading = false;
  String? message;

  /// Favorites list (for the screen)
  List<FeaturedTourPointDto> favorites = [];

  /// Actual source of truth
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  /// Is this item a favorite?
  bool isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  /// Fetch favorites from API
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
        message = resp.message ?? tr('error_favorites_failed');
      }
    } catch (e) {
      favorites = [];
      _favoriteIds.clear();
      message = tr('error_generic');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle favorite add/remove (universal)
  Future<void> toggleFavorite(String id) async {
    final wasFavorite = _favoriteIds.contains(id);

    // OPTIMISTIC UPDATE
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
      await _service.toggleFavorite(id);
    } catch (e) {
      // ROLLBACK
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
