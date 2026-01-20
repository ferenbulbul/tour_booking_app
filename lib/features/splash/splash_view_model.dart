import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/models/user_me/user_me.dart';
import 'package:tour_booking/services/auth/auth_service.dart';
import 'package:tour_booking/services/core/secure_token_storage.dart';

class SplashViewModel extends ChangeNotifier {
  final SecureTokenStorage _tokenStorage = SecureTokenStorage();
  final AuthService _authService = AuthService();

  bool? _isLoggedIn;
  UserMe? _user;
  UserRole? _role;

  bool get isChecking => _isLoggedIn == null;
  bool get isLoggedInStatus => _isLoggedIn ?? false;
  UserMe? get user => _user;
  UserRole? get role => _role;

  // Uygulama ilk açıldığında çalışan (Soğuk açılış)
  Future<void> initializeApp() async {
    _isLoggedIn = null;
    notifyListeners();
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();

        // Önce local hafızadan (diski) oku (Hot restart için can simidi ⚓)
        final String? localName = prefs.getString('user_full_name');
        final bool? localEmailConfirmed = prefs.getBool('user_email_confirmed');
        final String? roleStr = prefs.getString('user_role');

        // Servisi çağır ama hata alsa da local veriye güven
        final freshUser = await getUserMeSafe();

        if (freshUser != null) {
          _user = freshUser;
        } else if (localName != null) {
          // Servis patlaksa localdeki veriyi kullan
          _user = UserMe(
            firstName: localName,
            emailConfirmed: localEmailConfirmed ?? false,
            userId: "cached_user",
          );
        }

        _role = roleStr != null ? UserRoleExtension.fromString(roleStr) : null;
        _isLoggedIn = (_user != null); // User varsa giriş başarılıdır
      } else {
        _isLoggedIn = false;
      }
    } catch (e) {
      _isLoggedIn = false;
    } finally {
      notifyListeners();
    }
  }

  // 🔥 TEK VE NET METOD: Giriş/Kayıt sonrası her şeyi halleder
  Future<void> saveAuthData(LoginResponse response) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. DİSKE YAZ (Hot Restart için kurtarıcı ⚓)
    await prefs.setString('user_full_name', response.userFullName);
    await prefs.setBool('user_email_confirmed', response.emailConfirmed);
    await prefs.setString('user_role', response.role);

    // 2. BELLEĞE YAZ (Anlık yönlendirme için 🚀)
    _user = UserMe(
      userId: "temp_id_from_login",
      firstName: response.userFullName,
      emailConfirmed: response.emailConfirmed,
    );
    _role = UserRoleExtension.fromString(response.role);
    _isLoggedIn = true;

    // 3. BEKÇİYİ UYANDIR
    notifyListeners();

    // 4. ARKA PLANDA ASIL VERİYİ ÇEK (Opsiyonel)
    _refreshUserMeInBackground();
  }

  // 🔥 LOGIN / REGISTER SONRASI ÇALIŞACAK OLAN

  // Sessizce veriyi tazeleme
  Future<void> _refreshUserMeInBackground() async {
    final freshUser = await getUserMeSafe();
    if (freshUser != null) {
      _user = freshUser;
      // Burada notify demene bile gerek yok, zaten içerideyiz.
      // Sadece profil sayfasında ID lazımsa o an güncellenmiş olur.
    }
  }

  Future<UserMe?> getUserMeSafe() async {
    try {
      final response = await _authService.getUserMe();
      return response.data;
    } catch (e) {
      return null;
    }
  }

  void updateEmailConfirmation(bool status) {
    if (_user != null) {
      _user = _user!.copyWith(emailConfirmed: status);
      notifyListeners(); // 🚩 Bekçi burada tetiklenir ve /home'a atar
    }
  }

  // 2. Login'e dönmek isteyenler için temizlik
  Future<void> signOut() async {
    _isLoggedIn = false;
    _user = null;
    _role = null;
    await _tokenStorage.clearTokens();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
    notifyListeners(); // 🚩 Bekçi burada tetiklenir ve /login'e izin verir
  }
}
