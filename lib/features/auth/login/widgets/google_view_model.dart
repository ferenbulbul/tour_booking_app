import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_booking/core/network/failure_model.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/models/firebase_token/firebase_token_request.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/services/auth/auth_service.dart';
import 'package:tour_booking/services/core/secure_token_storage.dart';

enum AuthProviderType { google, apple }

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final SecureTokenStorage _tokenStorage = SecureTokenStorage();
  final AuthService _authService = AuthService();

  bool isLoading = false;

  // --- GİRİŞ YAPMA ---
  Future<Result<LoginResponse>> signIn(AuthProviderType provider) async {
    isLoading = true;
    notifyListeners();

    try {
      AuthCredential credential;
      String? fullName;

      if (provider == AuthProviderType.google) {
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          isLoading = false;
          notifyListeners();
          return Result.failure(
            FailureModel(message: 'google_sign_in_cancelled'),
          );
        }

        final googleAuth = await googleUser.authentication;
        fullName = googleUser.displayName;
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      } else {
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        fullName = [
          appleCredential.givenName,
          appleCredential.familyName,
        ].where((e) => e != null && e.isNotEmpty).join(" ");

        credential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );
      }

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final String? firebaseIdToken = await userCredential.user?.getIdToken();

      if (firebaseIdToken == null) {
        throw Exception("Firebase ID Token alınamadı");
      }

      final req = FirebaseTokenRequest(
        token: firebaseIdToken,
        fullName: fullName ?? "",
      );
      final backendResponse = await _authService.verifyGoogleUser(req);
      final result = handleResponse<LoginResponse>(backendResponse);

      if (result.isSuccess && result.data != null) {
        await _tokenStorage.saveTokens(
          result.data!.accessToken,
          result.data!.refreshToken,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_role', result.data!.role);
        await prefs.setBool(
          'is_profile_complete',
          result.data!.isProfileComplete,
        );
      }

      isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return Result.failure(
        FailureModel(message: "unexpected_error_occurred".tr()),
      );
    }
  }

  // --- ÇIKIŞ YAPMA ---
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      await _authService.logout();
      await _tokenStorage.clearTokens();

      final prefs = await SharedPreferences.getInstance();
      // 🔥 clear() yerine sadece auth ile ilgili olanları sil
      await prefs.remove('user_role');
      await prefs.remove('is_profile_complete');

      notifyListeners();
    } catch (e) {
      debugPrint("SignOut Error: $e");
    }
  }

  // --- HESABI SİLME ---
  Future<Result<void>> deleteAccount() async {
    isLoading = true;
    notifyListeners();

    try {
      // 1. Önce Backend'den hesabı sil (Eğer bir endpoint'in varsa)
      // final response = await _authService.deleteAccount();
      // final result = handleResponse(response);

      // 2. Sosyal ve Firebase oturumlarını kapat/sil
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser!.delete();
      }
      await _googleSignIn.signOut();

      // 3. Lokal verileri tamamen sıfırla
      await _tokenStorage.clearTokens();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      isLoading = false;
      notifyListeners();
      return Result.success(null);
    } catch (e) {
      isLoading = false;
      notifyListeners();
      // Firebase re-authentication isteyebilir, o yüzden hata dönebiliriz
      return Result.failure(FailureModel(message: e.toString()));
    }
  }
}
