import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/models/user_me/user_me.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/auth/auth_service.dart';
import 'package:tour_booking/services/core/secure_token_storage.dart';
import 'package:tour_booking/services/core/api_client.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashViewModel extends BaseViewModel {
  final SecureTokenStorage _tokenStorage = SecureTokenStorage();
  final AuthService _authService = ServiceLocator.instance.authService;

  bool? _isLoggedIn;
  UserMe? _user;
  UserRole? _role;

  // Onboarding state
  bool _hasSeenOnboarding = true; // default true to prevent flash
  bool _shouldShowLoginSheet = false;

  // Auth transition animation
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

  // Runs on first app launch (cold start)
  Future<void> initializeApp() async {
    // Bind session expired callback
    ApiClient.onSessionExpired = _handleSessionExpired;

    _isLoggedIn = null;
    notifyListeners();

    // Check onboarding status
    final onboardingPrefs = await SharedPreferences.getInstance();
    _hasSeenOnboarding = onboardingPrefs.getBool('has_seen_onboarding') ?? false;

    try {
      final token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();

        // Read from local storage first (lifeline for hot restart)
        final String? localName = prefs.getString('user_full_name');
        final bool? localEmailConfirmed = prefs.getBool('user_email_confirmed');
        final String? roleStr = prefs.getString('user_role');

        // Call service but trust local data even if it fails
        final freshUser = await getUserMeSafe();

        if (freshUser != null) {
          _user = freshUser;
          // Update role with server data
          if (freshUser.role != null) {
            _role = UserRoleExtension.fromString(freshUser.role);
            await prefs.setString('user_role', freshUser.role!);
          } else {
            _role = roleStr != null ? UserRoleExtension.fromString(roleStr) : null;
          }
        } else if (localName != null) {
          // If service fails, use local data
          _user = UserMe(
            firstName: localName,
            emailConfirmed: localEmailConfirmed ?? false,
            userId: "cached_user",
            role: roleStr,
          );
          _role = roleStr != null ? UserRoleExtension.fromString(roleStr) : null;
        }

        _isLoggedIn = (_user != null); // Login succeeds if user exists

        // Token existed but user couldn't be fetched (invalid token) -> fall back to guest
        if (_isLoggedIn == false) {
          await _tokenStorage.clearTokens();
          await _performGuestSignIn();
        }
      } else {
        // No token — perform automatic guest sign-in
        await _performGuestSignIn();
      }
    } catch (e) {
      // Even if error occurs, try to continue as guest
      await _performGuestSignIn();
    } finally {
      FlutterNativeSplash.remove();
      notifyListeners();
    }
  }

  /// Automatic guest sign-in
  Future<void> _performGuestSignIn() async {
    try {
      final response = await _authService.guestSignIn();
      if (response.isSuccess == true && response.data != null) {
        final loginData = response.data!;

        // Save auth data (no animation, internal)
        await _saveAuthDataInternal(loginData);
      } else {
        _isLoggedIn = false;
      }
    } catch (e) {
      debugPrint('Guest sign-in failed: $e');
      _isLoggedIn = false;
    }
  }

  // Handles everything after login/register (with transition animation)
  Future<void> saveAuthData(LoginResponse response) async {
    // Start transition animation
    _isTransitioning = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 350));

    await _saveAuthDataInternal(response);

    // Let rebuild complete, then close overlay
    await Future.delayed(const Duration(milliseconds: 200));
    _isTransitioning = false;
    notifyListeners();
  }

  /// Save auth data (no animation, internal use)
  Future<void> _saveAuthDataInternal(LoginResponse response) async {
    // 0. SAVE TOKENS
    await _tokenStorage.saveTokens(response.accessToken, response.refreshToken);

    final prefs = await SharedPreferences.getInstance();

    // 1. WRITE TO DISK (lifeline for hot restart)
    await prefs.setString('user_full_name', response.userFullName);
    await prefs.setBool('user_email_confirmed', response.emailConfirmed);
    await prefs.setString('user_role', response.role);

    // 2. WRITE TO MEMORY (for instant redirect)
    _user = UserMe(
      userId: "temp_id_from_login",
      firstName: response.userFullName,
      emailConfirmed: response.emailConfirmed,
      role: response.role,
    );
    _role = UserRoleExtension.fromString(response.role);
    _isLoggedIn = true;

    // 3. WAKE UP THE GUARD (notify listeners)
    notifyListeners();

    // 4. FETCH ACTUAL DATA IN BACKGROUND (optional)
    _refreshUserMeInBackground();
  }

  // Silently refresh user data
  Future<void> _refreshUserMeInBackground() async {
    final freshUser = await getUserMeSafe();
    if (freshUser != null) {
      _user = freshUser;
      if (freshUser.role != null) {
        _role = UserRoleExtension.fromString(freshUser.role);
      }
      notifyListeners();
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

  /// Called by ApiClient when a 401 is received.
  /// Continue as guest + show login sheet.
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

  /// Full sign-out: API logout + social cleanup + guest sign-in
  Future<void> performFullSignOut({
    Future<void> Function()? socialCleanup,
  }) async {
    // Start transition animation
    _isTransitioning = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 350));

    try {
      await _authService.logout();
    } catch (e) {
      debugPrint('SplashViewModel.performFullSignOut: $e');
    }
    if (socialCleanup != null) await socialCleanup();
    await _clearAuthData();
    await _performGuestSignIn();
    notifyListeners();

    // Let rebuild complete, then close overlay
    await Future.delayed(const Duration(milliseconds: 200));
    _isTransitioning = false;
    notifyListeners();
  }

  /// After account deletion: social cleanup + guest sign-in
  Future<void> performAccountDeletion({
    Future<void> Function()? socialCleanup,
  }) async {
    // Start transition animation
    _isTransitioning = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 350));

    if (socialCleanup != null) await socialCleanup();
    await _clearAuthData();
    await _performGuestSignIn();
    notifyListeners();

    // Let rebuild complete, then close overlay
    await Future.delayed(const Duration(milliseconds: 200));
    _isTransitioning = false;
    notifyListeners();
  }

  /// Continue as guest from login screen
  Future<void> continueAsGuest() async {
    await _clearAuthData();
    await _performGuestSignIn();
    notifyListeners();
  }

  /// Onboarding completed
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    _hasSeenOnboarding = true;
    _shouldShowLoginSheet = true;
    notifyListeners();
  }

  /// Clear all auth data (token + prefs + memory)
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
