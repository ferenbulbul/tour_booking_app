import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/login/login_request.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/navigation/app_navigator.dart';
import 'package:tour_booking/services/auth/secure_token_storage.dart';

class AuthService {
  final baseUrl = dotenv.env['baseUrl'];
  final mobileAndroid = dotenv.env['mobileAndroid'];
  final localeCode =
      appNavigatorKey.currentContext?.locale.languageCode ?? 'en';

  Future<BaseResponse<LoginResponse>> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': localeCode,
      },
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

  Future<BaseResponse<void>> verifyCode(String code) async {
    final token = await SecureTokenStorage().getAccessToken();
    final response = await http.post(
      Uri.parse('$baseUrl/verify-email'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept-Language': localeCode,
      },
      body: jsonEncode({'code': code}),
    );
    final json = jsonDecode(response.body);
    return BaseResponse<void>.fromJson(json, (_) => null);
  }

  Future<BaseResponse<void>> resendVerificationCode() async {
    final token = await SecureTokenStorage().getAccessToken();
    final response = await http.post(
      Uri.parse('$mobileAndroid/send-verification-email'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final json = jsonDecode(response.body);
    return BaseResponse<void>.fromJson(json, (_) => null);
  }
}
