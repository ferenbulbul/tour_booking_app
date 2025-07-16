import 'package:flutter/material.dart';
import 'package:tour_booking/services/auth/secure_token_storage.dart';

class SplashViewModel extends ChangeNotifier {
  final SecureTokenStorage _tokenStorage = SecureTokenStorage();

  Future<bool> isLoggedIn() async {
    final token = await _tokenStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
