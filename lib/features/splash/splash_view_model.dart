import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/models/user_me/user_me.dart';
import 'package:tour_booking/services/auth/auth_service.dart';
import 'package:tour_booking/services/core/secure_token_storage.dart';
import 'package:tour_booking/services/core/api_client.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashViewModel extends ChangeNotifier {
  final SecureTokenStorage _tokenStorage = SecureTokenStorage();
  final AuthService _authService = AuthService();

  bool? _isLoggedIn;
  UserMe? _user;
  UserRole? _role;

  // Onboarding state
  bool _hasSeenOnboarding = true; // default true → flash onleme
  bool _shouldShowLoginSheet = false;

  // Auth geçiş animasyonu
  bool _isTransitioning = false;

  bool get isChecking => _isLoggedIn == null;
  bool get isLoggedInStatus => _isLoggedIn ?? false;
  UserMe? get user => _user;
  UserRole? get role => _role;
  bool get isGuest => _role == UserRole.guest;
  bool get shouldShowOnboarding => !_hasSeenOnboarding;
  bool get shouldShowLoginSheet => _shouldShowLoginSheet;
  bool get isTransitioning => _isTransitioning;

  void clearLoginSheetFlag() => _shouldShowLoginSheet = false;

  // Uygulama ilk acildiginda calisan (Soguk acilis)
  Future<void> initializeApp() async {
    // Session expired callback'i bagla
    ApiClient.onSessionExpired = _handleSessionExpired;

    _isLoggedIn = null;
    notifyListeners();

    // Onboarding durumunu kontrol et
    final onboardingPrefs = await SharedPreferences.getInstance();
    _hasSeenOnboarding = onboardingPrefs.getBool('has_seen_onboarding') ?? false;

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
        if (_isLoggedIn == false) {
          await _tokenStorage.clearTokens();
          await _performGuestSignIn();
        }
      } else {
        // Token yoksa otomatik guest girisi yap
        await _performGuestSignIn();
      }
    } catch (e) {
      // Hata olsa bile guest olarak devam etmeyi dene
      await _performGuestSignIn();
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

        // Auth datasini kaydet (animasyonsuz, dahili)
        await _saveAuthDataInternal(loginData);
      } else {
        _isLoggedIn = false;
      }
    } catch (e) {
      debugPrint('Guest sign-in failed: $e');
      _isLoggedIn = false;
    }
  }

  // Giris/Kayit sonrasi her seyi halleder (geçiş animasyonlu)
  Future<void> saveAuthData(LoginResponse response) async {
    // Geçiş animasyonunu başlat
    _isTransitioning = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 350));

    await _saveAuthDataInternal(response);

    // Rebuild tamamlansın, sonra overlay'i kapat
    await Future.delayed(const Duration(milliseconds: 200));
    _isTransitioning = false;
    notifyListeners();
  }

  /// Auth verilerini kaydet (animasyonsuz, dahili kullanım)
  Future<void> _saveAuthDataInternal(LoginResponse response) async {
    // 0. TOKENLARI KAYDET
    await _tokenStorage.saveTokens(response.accessToken, response.refreshToken);

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

  /// 401 alindığında ApiClient tarafindan cagrilir
  /// Guest olarak devam et + login sheet goster
  Future<void> _handleSessionExpired() async {
    await _clearAuthData();
    await _performGuestSignIn();
    _shouldShowLoginSheet = true;
    notifyListeners();
  }

  void updateEmailConfirmation(bool status) {
    if (_user != null) {
      _user = _user!.copyWith(emailConfirmed: status);
      notifyListeners();
    }
  }

  /// Tam cikis: API logout + social temizlik + guest sign-in
  Future<void> performFullSignOut({
    Future<void> Function()? socialCleanup,
  }) async {
    // Geçiş animasyonunu başlat
    _isTransitioning = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 350));

    try {
      await _authService.logout();
    } catch (_) {}
    if (socialCleanup != null) await socialCleanup();
    await _clearAuthData();
    await _performGuestSignIn();
    notifyListeners();

    // Rebuild tamamlansın, sonra overlay'i kapat
    await Future.delayed(const Duration(milliseconds: 200));
    _isTransitioning = false;
    notifyListeners();
  }

  /// Hesap silme sonrasi: social temizlik + guest sign-in
  Future<void> performAccountDeletion({
    Future<void> Function()? socialCleanup,
  }) async {
    // Geçiş animasyonunu başlat
    _isTransitioning = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 350));

    if (socialCleanup != null) await socialCleanup();
    await _clearAuthData();
    await _performGuestSignIn();
    notifyListeners();

    // Rebuild tamamlansın, sonra overlay'i kapat
    await Future.delayed(const Duration(milliseconds: 200));
    _isTransitioning = false;
    notifyListeners();
  }

  /// Login ekranindan guest olarak devam et
  Future<void> continueAsGuest() async {
    await _clearAuthData();
    await _performGuestSignIn();
    notifyListeners();
  }

  /// Onboarding tamamlandi
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    _hasSeenOnboarding = true;
    _shouldShowLoginSheet = true;
    notifyListeners();
  }

  /// Tum auth verilerini temizle (token + prefs + memory)
  Future<void> _clearAuthData() async {
    await _tokenStorage.clearTokens();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
    await prefs.remove('user_full_name');
    await prefs.remove('user_email_confirmed');
    _isLoggedIn = false;
    _user = null;
    _role = null;
  }
}
