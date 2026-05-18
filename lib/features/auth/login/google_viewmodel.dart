import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tour_booking/core/network/failure_model.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/models/firebase_token/firebase_token_request.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/services/auth/auth_service.dart';

enum AuthProviderType { google, apple }

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
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

  /// Sadece Google/Firebase oturumlarini kapat (token/prefs SplashVM halleder)
  Future<void> socialSignOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint("Social SignOut Error: $e");
    }
  }

  /// Sadece Firebase user sil + Google sign out (token/prefs SplashVM halleder)
  Future<void> socialDeleteAccount() async {
    if (_firebaseAuth.currentUser != null) {
      await _firebaseAuth.currentUser!.delete();
    }
    await _googleSignIn.signOut();
  }
}
