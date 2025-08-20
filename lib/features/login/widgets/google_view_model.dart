import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/core/network/failure_model.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/core/network/result.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/services/auth/auth_service.dart';
import 'package:tour_booking/services/core/secure_token_storage.dart';

class GoogleViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final SecureTokenStorage _tokenStorage = SecureTokenStorage();

  final AuthService _authService = AuthService();

  User? _user;
  User? get user => _user;
  String? message;
  List<String> validationErrors = [];

  Future<Result<LoginResponse>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return Result.failure(
          FailureModel(
            message: "Giriş işlemi kullanıcı tarafından iptal edildi.",
          ),
        );
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final User loggedInUser = userCredential.user!;
      final String? firebaseIdToken = await loggedInUser.getIdToken();

      if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
        return Result.failure(
          FailureModel(
            message:
                "Firebase kimlik token'ı alınamadı. Lütfen tekrar deneyin.",
          ),
        );
      }

      var backendResponse = await _authService.verifyGoogleUser(
        firebaseIdToken,
      );

      final result = handleResponse<LoginResponse>(backendResponse);

      if (result.isSuccess && result.data != null) {
        await _tokenStorage.saveTokens(
          result.data!.accessToken,
          result.data!.refreshToken,
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_role', result.data!.role);
        _user = loggedInUser;
        print("✅ Giriş başarılı ve token'lar kaydedildi.");
      } else {
        _user = null;
      }

      notifyListeners();
      return result;
    } catch (e) {
      print('🚨 Google Sign-In veya Backend hatası: $e');
      _user = null;
      notifyListeners();

      return Result.failure(
        FailureModel(message: "Beklenmedik bir hata oluştu: ${e.toString()}"),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      print("👋 Google oturumu kapatıldı.");

      await _firebaseAuth.signOut();
      print("🔥 Firebase oturumu kapatıldı.");

      final SecureTokenStorage _tokenStorage = SecureTokenStorage();
      _tokenStorage.clearTokens();

      _user = null;

      notifyListeners();
    } catch (e) {
      print('🚨 Çıkış yapma hatası: $e');
    }
  }
}
