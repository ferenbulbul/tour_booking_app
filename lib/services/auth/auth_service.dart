import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/login/login_request.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/services/auth/secure_token_storage.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:5144/api/Auth';

  Future<BaseResponse<LoginResponse>> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
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
      },
      body: jsonEncode({'code': code}),
    );
    final json = jsonDecode(response.body);
    return BaseResponse<void>.fromJson(json, (_) => null);
  }

  Future<BaseResponse<void>> resendVerificationCode() async {
    final token = await SecureTokenStorage().getAccessToken();
    final response = await http.post(
      Uri.parse('$baseUrl/send-verification-email'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final json = jsonDecode(response.body);
    return BaseResponse<void>.fromJson(json, (_) => null);
  }
}
