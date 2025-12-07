import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/models/register/register_request.dart';
import 'package:tour_booking/services/auth/auth_service.dart';
import 'package:tour_booking/services/core/secure_token_storage.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  // Token depolama servisini burada initialize ediyoruz
  final SecureTokenStorage _tokenStorage = SecureTokenStorage();

  bool isLoading = false;
  String? message;
  List<String> validationErrors = [];

  Future<Result<LoginResponse>> register(RegisterRequest request) async {
    isLoading = true;
    message = null;
    validationErrors = [];
    notifyListeners();

    // DEBUG: Gelen isteğin içeriğini kontrol etme
    print('Register Request Gönderiliyor:');
    print('Email: ${request.email}');
    print('Ülke Kodu: ${request.countryCode}');

    final response = await _authService.register(request);
    final result = handleResponse<LoginResponse>(response);

    if (result.isSuccess) {
      final loginResponse = result.data;

      if (loginResponse != null) {
        await _tokenStorage.saveTokens(
          loginResponse.accessToken,
          loginResponse.refreshToken,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_role', loginResponse.role);
        await prefs.setBool(
          'is_profile_complete',
          loginResponse.isProfileComplete,
        );
      }

      // Mesajları temizle
      message = null;
      validationErrors = [];
    } else {
      // 5. Başarısız İşlem: Hata ve Validasyon Mesajlarını Alma
      message = result.error?.message;
      validationErrors = result.error?.validationErrors ?? [];
    }

    // 6. Yüklenme Durumunu Kapatma ve Bildirme
    isLoading = false;
    notifyListeners();

    // İşlenmiş sonucu döndür
    return result;
  }

  void clearMessages() {
    message = null;
    validationErrors = [];
    notifyListeners();
  }
}
