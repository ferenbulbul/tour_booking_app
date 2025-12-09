import 'package:flutter/material.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/models/nearby_list/nearby_list_response.dart';
import 'package:tour_booking/models/user_me/user_me.dart';
import 'package:tour_booking/services/auth/auth_service.dart';
import 'package:tour_booking/services/core/secure_token_storage.dart';

class SplashViewModel extends ChangeNotifier {
  final SecureTokenStorage _tokenStorage = SecureTokenStorage();
  final AuthService _authService = AuthService();
  bool _isInitialLinkHandled = false;
  bool get isInitialLinkHandled => _isInitialLinkHandled;

  void setInitialLinkHandled() {
    _isInitialLinkHandled = true;
  }

  Future<bool> isLoggedIn() async {
    final token = await _tokenStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<UserMe?> getUserMeSafe() async {
    try {
      final response = await _authService.getUserMe();
      return response.data;
    } catch (e) {
      return null;
    }
  }
}
