// profile_status_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileStatusViewModel extends ChangeNotifier {
  static const _key = 'is_profile_complete';

  bool? _isComplete; // null = yükleniyor
  bool _dismissedThisSession = false;

  bool? get isComplete => _isComplete;
  bool get dismissedThisSession => _dismissedThisSession;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isComplete = prefs.getBool(_key) ?? false;
    print(_isComplete);
    notifyListeners();
  }

  Future<void> setProfileComplete(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('is_profile_complete'));
    await prefs.setBool(_key, value);
    _isComplete = value;
    _dismissedThisSession = false; // tamamlanınca zaten gizlenecek
    notifyListeners();
  }

  // Sadece bu oturumda kapatma
  void dismissForThisSession() {
    _dismissedThisSession = true;
    notifyListeners();
  }

  // Gerekirse manuel yenile
  Future<void> refresh() => init();
}
