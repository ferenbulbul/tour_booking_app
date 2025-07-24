import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/login/login_request.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/models/register/register_request.dart';
import 'package:tour_booking/navigation/app_navigator.dart';
import 'package:tour_booking/services/auth/secure_token_storage.dart';

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  String get _baseUrl => dotenv.env['baseUrl'] ?? '';
  String get _mobileAndroid => dotenv.env['mobileAndroid'] ?? '';

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

  Future<BaseResponse<LoginResponse>> login(LoginRequest request) async {
    final resp = await _client.post(
      Uri.parse('$_baseUrl/login'),
      headers: _headers(),
      body: jsonEncode(request.toJson()),
    );

    if (resp.body.isEmpty) {
      throw Exception('Boş cevap geldi. Backend çalışıyor mu?');
    }

    final jsonMap = jsonDecode(resp.body);
    return BaseResponse<LoginResponse>.fromJson(
      jsonMap,
      (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<BaseResponse<void>> verifyCode(String code) async {
    final token = await SecureTokenStorage().getAccessToken();
    final resp = await _client.post(
      Uri.parse('$_baseUrl/verify-email'),
      headers: _headers(token: token),
      body: jsonEncode({'code': code}),
    );

    final json = jsonDecode(resp.body);
    return BaseResponse<void>.fromJson(json, (_) => null);
  }

  Future<BaseResponse<void>> resendVerificationCode() async {
    final token = await SecureTokenStorage().getAccessToken();
    final resp = await _client.post(
      Uri.parse('$_baseUrl/send-verification-email'),
      headers: _headers(token: token),
    );

    final json = jsonDecode(resp.body);
    return BaseResponse<void>.fromJson(json, (_) => null);
  }

  Future<BaseResponse<LoginResponse>> register(RegisterRequest request) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/register'),
      headers: _headers(),
      body: jsonEncode(request.toJson()),
    );
    if (response.body.isEmpty) {
      throw Exception('Boş cevap geldi. Backend çalışıyor mu?');
    }
    final jsonMap = jsonDecode(response.body);
    return BaseResponse<LoginResponse>.fromJson(
      jsonMap,
      (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } catch (e) {
      // ignore: avoid_print
      print("🚨 AuthService error: $e");
      rethrow;
    }
  }
}
