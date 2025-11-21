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
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/utils/device_info_helper.dart';

enum AuthProviderType { google, apple }

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final SecureTokenStorage _tokenStorage = SecureTokenStorage();
  final AuthService _authService = AuthService();

  User? _user;
  User? get user => _user;
  String name = "";

  Future<Result<LoginResponse>> signIn(AuthProviderType provider) async {
    try {
      AuthCredential credential;

      // 🔹 Provider seçimine göre credential oluştur
      if (provider == AuthProviderType.google) {
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return Result.failure(
            FailureModel(message: "Google girişi iptal edildi."),
          );
        }

        final googleAuth = await googleUser.authentication;
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
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId:
                'com.tourbooking.applelogin.', // Apple Developer’da oluşturduğun Service ID
            redirectUri: Uri.parse(
              'https://tourbooking-api-272954735037.europe-west2.run.app/callbacks/sign_in_with_apple', // Firebase’in verdiği return URL
            ),
          ),
        );
        // ✅ Burada isim/soyisim'i yakalayabilirsin
        final fullName = [
          appleCredential.givenName,
          appleCredential.familyName,
        ].where((e) => e != null && e.isNotEmpty).join(" ");

        print("🍎 Apple FullName: $fullName");
        name = fullName;
        credential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );
      }

      // 🔹 Firebase ile giriş yap
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

      final req = FirebaseTokenRequest(token: firebaseIdToken, fullName: name);
      // 🔹 Backend doğrulama → provider’a göre farklı endpoint çağırabilirsin
      final backendResponse = await _authService.verifyGoogleUser(req);
      ///////////////
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

        _user = loggedInUser;
        print("✅ ${provider.name} girişi başarılı ve token'lar kaydedildi.");
      } else {
        _user = null;
      }

      notifyListeners();
      return result;
    } catch (e) {
      print('🚨 ${provider.name} Sign-In veya Backend hatası: $e');
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
      await _firebaseAuth.signOut();
      await _authService.logout();
      _tokenStorage.clearTokens();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _user = null;
      notifyListeners();
      print("👋 Tüm oturumlar kapatıldı.");
    } catch (e) {
      print('🚨 Çıkış yapma hatası: $e');
    }
  }
}
