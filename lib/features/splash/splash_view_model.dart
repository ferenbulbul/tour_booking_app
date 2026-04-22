import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/models/user_me/user_me.dart';
import 'package:tour_booking/services/auth/auth_service.dart';
import 'package:tour_booking/services/core/secure_token_storage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashViewModel extends ChangeNotifier {
  final SecureTokenStorage _tokenStorage = SecureTokenStorage();
  final AuthService _authService = AuthService();

  bool? _isLoggedIn;
  UserMe? _user;
  UserRole? _role;
  bool _skipAutoGuestSignIn = false;

  bool get isChecking => _isLoggedIn == null;
  bool get isLoggedInStatus => _isLoggedIn ?? false;
  UserMe? get user => _user;
  UserRole? get role => _role;
  bool get isGuest => _role == UserRole.guest;

  // Uygulama ilk acildiginda calisan (Soguk acilis)
  Future<void> initializeApp() async {
    _isLoggedIn = null;
    notifyListeners();
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();

        // Once local hafizadan (diski) oku (Hot restart icin can simidi)
        final String? localName = prefs.getString('user_full_name');
        final bool? localEmailConfirmed = prefs.getBool('user_email_confirmed');
        final String? roleStr = prefs.getString('user_role');

        // Servisi cagir ama hata alsa da local veriye guven
        final freshUser = await getUserMeSafe();

        if (freshUser != null) {
          _user = freshUser;
          // Role'u server'dan gelen veriyle guncelle
          if (freshUser.role != null) {
            _role = UserRoleExtension.fromString(freshUser.role);
            await prefs.setString('user_role', freshUser.role!);
          } else {
            _role = roleStr != null ? UserRoleExtension.fromString(roleStr) : null;
          }
        } else if (localName != null) {
          // Servis patlaksa localdeki veriyi kullan
          _user = UserMe(
            firstName: localName,
            emailConfirmed: localEmailConfirmed ?? false,
            userId: "cached_user",
            role: roleStr,
          );
          _role = roleStr != null ? UserRoleExtension.fromString(roleStr) : null;
        }

        _isLoggedIn = (_user != null); // User varsa giris basarilidir

        // Token vardi ama user alinamadiysa (gecersiz token) → guest'e dus
        if (_isLoggedIn == false && !_skipAutoGuestSignIn) {
          await _tokenStorage.clearTokens();
          await _performGuestSignIn();
        }
      } else if (!_skipAutoGuestSignIn) {
        // Token yoksa otomatik guest girisi yap
        await _performGuestSignIn();
      } else {
        _isLoggedIn = false;
      }
    } catch (e) {
      // Hata olsa bile guest olarak devam etmeyi dene
      if (!_skipAutoGuestSignIn) {
        await _performGuestSignIn();
      } else {
        _isLoggedIn = false;
      }
    } finally {
      FlutterNativeSplash.remove();
      notifyListeners();
    }
  }

  /// Otomatik guest girisi
  Future<void> _performGuestSignIn() async {
    try {
      final response = await _authService.guestSignIn();
      if (response.isSuccess == true && response.data != null) {
        final loginData = response.data!;

        // Tokenlari kaydet
        await _tokenStorage.saveTokens(
          loginData.accessToken,
          loginData.refreshToken,
        );

        // Auth datasini kaydet
        await saveAuthData(loginData);
      } else {
        _isLoggedIn = false;
      }
    } catch (e) {
      debugPrint('Guest sign-in failed: $e');
      _isLoggedIn = false;
    }
  }

  // Giris/Kayit sonrasi her seyi halleder
  Future<void> saveAuthData(LoginResponse response) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. DISKE YAZ (Hot Restart icin kurtarici)
    await prefs.setString('user_full_name', response.userFullName);
    await prefs.setBool('user_email_confirmed', response.emailConfirmed);
    await prefs.setString('user_role', response.role);

    // 2. BELLEGE YAZ (Anlik yonlendirme icin)
    _user = UserMe(
      userId: "temp_id_from_login",
      firstName: response.userFullName,
      emailConfirmed: response.emailConfirmed,
      role: response.role,
    );
    _role = UserRoleExtension.fromString(response.role);
    _isLoggedIn = true;

    // 3. BEKCIYI UYANDIR
    notifyListeners();

    // 4. ARKA PLANDA ASIL VERIYI CEK (Opsiyonel)
    _refreshUserMeInBackground();
  }

  // Sessizce veriyi tazeleme
  Future<void> _refreshUserMeInBackground() async {
    final freshUser = await getUserMeSafe();
    if (freshUser != null) {
      _user = freshUser;
      if (freshUser.role != null) {
        _role = UserRoleExtension.fromString(freshUser.role);
      }
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
      notifyListeners();
    }
  }

  /// Guest profilden "Giris Yap" tiklaninca login ekranina yonlendir
  Future<void> redirectToLogin() async {
    _skipAutoGuestSignIn = true;
    await signOut();
  }

  /// Cikis yap ve guest olarak devam et (login'e atmaz)
  Future<void> signOutToGuest() async {
    await _tokenStorage.clearTokens();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
    await prefs.remove('user_full_name');
    await prefs.remove('user_email_confirmed');

    // Hemen guest sign-in yap — arada _isLoggedIn = false olmadan
    await _performGuestSignIn();
    notifyListeners();
  }

  // Login'e donmek isteyenler icin temizlik
  Future<void> signOut() async {
    _isLoggedIn = false;
    _user = null;
    _role = null;
    await _tokenStorage.clearTokens();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
    notifyListeners();
  }
}
