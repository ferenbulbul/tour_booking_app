import 'package:flutter/material.dart';
import 'package:tour_booking/services/core/secure_token_storage.dart';

class DriverHomeViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  Future<void> refresh() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      // TODO: burada sürücüye özel verileri çek (örn. aktif görevler, bildirimler…)
      await Future.delayed(const Duration(milliseconds: 600));
    } catch (e) {
      error = 'Bir şeyler ters gitti: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      final SecureTokenStorage _tokenStorage = SecureTokenStorage();
      _tokenStorage.clearTokens();
      notifyListeners();
    } catch (e) {
      print('🚨 Çıkış yapma hatası: $e');
    }
  }
}
