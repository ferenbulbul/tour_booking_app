import 'package:flutter/material.dart';
import 'package:tour_booking/models/pending_rating/pending_rating_dto.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class RatingsViewModel extends ChangeNotifier {
  final TourService _service = TourService();

  bool isRatingLoading = false;
  bool isSubmitting = false;

  PendingRatingDto? pendingRating;

  final Map<String, int> ratings = {};
  final Map<String, String> comments = {};

  bool get canSubmit => ratings.isNotEmpty;

  Future<void> loadPendingRating({required String token}) async {
    isRatingLoading = true;
    notifyListeners();

    try {
      final res = await _service.getPendingRating(token: token);
      pendingRating = res.data;
    } catch (_) {
      pendingRating = null;
    } finally {
      isRatingLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitRating({required String token}) async {
    if (pendingRating == null) return false;
    if (ratings.isEmpty) return false;

    isSubmitting = true;
    notifyListeners();

    final payload = {
      "ratingRequestId": pendingRating!.ratingRequestId,
      "token": token,
      "ratings": pendingRating!.targets
          .where((t) => ratings.containsKey(t.targetId))
          .map(
            (t) => {
              "targetType": t.targetType,
              "targetId": t.targetId,
              "rating": ratings[t.targetId],
              "comment": comments[t.targetId],
            },
          )
          .toList(),
    };

    try {
      await _service.submitRating(payload: payload);

      pendingRating = null;
      ratings.clear();
      comments.clear();

      isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Submit rating error: $e");
      isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  void setRating(String targetId, int value) {
    ratings[targetId] = value;
    notifyListeners();
  }

  void setComment(String targetId, String value) {
    comments[targetId] = value;
  }

  void clear() {
    pendingRating = null;
    ratings.clear();
    comments.clear();
  }
}
