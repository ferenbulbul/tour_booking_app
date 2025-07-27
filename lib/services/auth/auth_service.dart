// lib/services/auth/auth_service.dart
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/login/login_request.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/models/register/register_request.dart';
import 'package:tour_booking/models/reset_password/reset_password_request.dart';
import 'package:tour_booking/navigation/app_navigator.dart';
import 'package:tour_booking/services/auth/secure_token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tour_booking/services/safe_call.dart';

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;
  String get _mobileAndroid => dotenv.env['mobileAndroid'] ?? '';
  String get _baseUrl => dotenv.env['baseUrl'] ?? '';
  String get _localeCode =>
      appNavigatorKey.currentContext?.locale.languageCode ?? 'en';

  Map<String, String> _headers({String? token, Map<String, String>? extra}) {
    return {
      'Content-Type': 'application/json',
      'Accept-Language': _localeCode,
      if (token != null) 'Authorization': 'Bearer $token',
      if (extra != null) ...extra,
    };
  }

  /// Login
  Future<BaseResponse<LoginResponse>> login(LoginRequest req) {
    return safeCall<LoginResponse>(() async {
      final res = await _client.post(
        Uri.parse('$_baseUrl/login'),
        headers: _headers(),
        body: jsonEncode(req.toJson()),
      );
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      return BaseResponse<LoginResponse>.fromJson(
        map,
        (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
      );
    });
  }

  /// Email doğrulama kodunu test et
  Future<BaseResponse<void>> verifyCode(String code) {
    return safeCall<void>(() async {
      final token = await SecureTokenStorage().getAccessToken();
      final res = await _client.post(
        Uri.parse('$_baseUrl/verify-email'),
        headers: _headers(token: token),
        body: jsonEncode({'code': code}),
      );
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      return BaseResponse<void>.fromJson(map, (_) => null);
    });
  }

  /// Doğrulama kodunu yeniden gönder
  Future<BaseResponse<void>> resendVerificationCode() {
    return safeCall<void>(() async {
      final token = await SecureTokenStorage().getAccessToken();
      final res = await _client.post(
        Uri.parse('$_baseUrl/send-verification-email'),
        headers: _headers(token: token),
      );
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      return BaseResponse<void>.fromJson(map, (_) => null);
    });
  }

  /// Kayıt ol
  Future<BaseResponse<LoginResponse>> register(RegisterRequest req) {
    return safeCall<LoginResponse>(() async {
      final res = await _client.post(
        Uri.parse('$_baseUrl/register'),
        headers: _headers(),
        body: jsonEncode(req.toJson()),
      );
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      return BaseResponse<LoginResponse>.fromJson(
        map,
        (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
      );
    });
  }

  /// Şifre sıfırla
  Future<BaseResponse<void>> resetPassword(ResetPasswordRequest req) {
    return safeCall<void>(() async {
      final res = await _client.post(
        Uri.parse('$_baseUrl/reset-password'),
        headers: _headers(),
        body: jsonEncode(req.toJson()),
      );

      // Önce body’daki JSON’u parse etmeye çalış
      if (res.body.isNotEmpty) {
        try {
          final map = jsonDecode(res.body) as Map<String, dynamic>;
          return BaseResponse<void>.fromJson(map, (_) => null);
        } catch (_) {
          /* parse hatasıysa alt adımlara geç */
        }
      }

      // Body boşsa veya parse edilemediyse kodu kontrol et
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return BaseResponse<void>(
          isSuccess: true,
          message: 'Şifreniz başarıyla sıfırlandı.',
          validationErrors: [],
          data: null,
        );
      } else {
        return BaseResponse<void>(
          isSuccess: false,
          message: 'Sunucu hatası: ${res.statusCode}',
          validationErrors: [],
          data: null,
        );
      }
    });
  }
}

// Google Sign-In & Firebase Auth
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

Future<User?> signInWithGoogle() async {
  try {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCred = await _firebaseAuth.signInWithCredential(credential);
    return userCred.user;
  } catch (e) {
    // Burada da hata fırlatıp global handler’a bırakabilirsin
    rethrow;
  }
}
