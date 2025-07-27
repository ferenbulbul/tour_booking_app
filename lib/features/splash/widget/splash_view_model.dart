import 'package:flutter/material.dart';
import 'package:tour_booking/services/auth/secure_token_storage.dart';

class SplashViewModel extends ChangeNotifier {
  final SecureTokenStorage _tokenStorage = SecureTokenStorage();

  bool _isInitialLinkHandled = false;
  bool get isInitialLinkHandled => _isInitialLinkHandled;

  void setInitialLinkHandled() {
    _isInitialLinkHandled = true;
  }

  Future<bool> isLoggedIn() async {
    final token = await _tokenStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
