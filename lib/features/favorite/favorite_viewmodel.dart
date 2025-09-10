import 'package:flutter/material.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/models/featured_tour_point/featured_tour_point_dto.dart';
import 'package:tour_booking/models/featured_tour_point_list/featured_tour_point_list_dto.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class FavoriteViewModel extends ChangeNotifier {
  final TourService _service = TourService();

  bool isLoading = false;
  String? message;
  List<FeaturedTourPointDto> favorites = [];
  String? selectedTourPointId;
  Future<void> fetchFavorites() async {
    try {
      isLoading = true;
      notifyListeners();

      final resp = await _service.getFavorites();
      final result = handleResponse<FeaturedTourPointListDto>(resp);

      if (result.isSuccess && result.data != null) {
        favorites = result.data!.tourPoints;
        message = null;
      } else {
        favorites = [];
        message = resp.message ?? "Favoriler alınamadı";
      }
    } catch (e) {
      favorites = [];
      message = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void removeFavoriteLocal(String id) {
    favorites = favorites.where((f) => f.id != id).toList();
    selectedTourPointId = id;
    notifyListeners();
  }

  // Future<void> toggleFavorite(String tourPointId) async {
  //   // basit mantık: eğer listede varsa sil, yoksa ekle
  //   final exists = favorites.any((f) => f.tourPointId == tourPointId);

  //   try {
  //     if (exists) {
  //       await _favoriteService.removeFavorite(tourPointId);
  //       favorites.removeWhere((f) => f.tourPointId == tourPointId);
  //     } else {
  //       final resp = await _favoriteService.addFavorite(tourPointId);
  //       final result = handleResponse<FavoriteDto>(resp);
  //       if (result.isSuccess && result.data != null) {
  //         favorites.add(result.data!);
  //       }
  //     }
  //   } catch (e) {
  //     message = e.toString();
  //   }

  //   notifyListeners();
  // }
  Future<void> removeFavorite(String tourPointId) async {
    notifyListeners();
    try {
      await _service.ToggleFavorite(selectedTourPointId!);
    } catch (e) {
      notifyListeners();
    }
  }
}
