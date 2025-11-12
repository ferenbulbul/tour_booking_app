// lib/services/auth/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/firebase_token/firebase_token_request.dart';
import 'package:tour_booking/models/login/login_request.dart';
import 'package:tour_booking/models/login/login_response.dart';
import 'package:tour_booking/models/register/register_request.dart';
import 'package:tour_booking/services/core/api_client.dart';
import 'package:tour_booking/services/core/secure_token_storage.dart';
import 'package:tour_booking/utils/device_info_helper.dart';

class AuthService {
  final ApiClient _apiClient;
  final SecureTokenStorage _tokenStorage = SecureTokenStorage();

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// 🔹 Login
  Future<BaseResponse<LoginResponse>> login(LoginRequest req) async {
    final device = await DeviceInfoHelper.getDevice();

    final updatedReq = req.copyWith(
      deviceId: device.deviceId,
      deviceModel: device.deviceModel,
    );

    return _apiClient.post<LoginResponse>(
      path: '/Auth/login',
      body: updatedReq.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 🔹 Register
  Future<BaseResponse<LoginResponse>> register(RegisterRequest req) async {
    final device = await DeviceInfoHelper.getDevice();

    final updatedReq = req.copyWith(
      deviceId: device.deviceId,
      deviceModel: device.deviceModel,
    );

    return _apiClient.post<LoginResponse>(
      path: '/Auth/register',
      body: updatedReq.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 🔹 Google veya Apple login (Firebase token üzerinden)
  Future<BaseResponse<LoginResponse>> verifyGoogleUser(
    FirebaseTokenRequest req,
  ) async {
    final device = await DeviceInfoHelper.getDevice();

    final updatedReq = req.copyWith(
      deviceId: device.deviceId,
      deviceModel: device.deviceModel,
    );

    return _apiClient.post<LoginResponse>(
      path: '/Auth/signin-with-google',
      body: updatedReq.toJson(),
      fromJson: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<BaseResponse<void>> verifyCode(String code) async {
    return _apiClient.post<void>(
      path: '/Auth/verify-email',
      body: {'code': code},
    );
  }

  Future<BaseResponse<void>> resendVerificationCode() async {
    return _apiClient.post<void>(path: '/Auth/send-verification-email');
  }

  Future<BaseResponse<void>> forgotPassword(String email) {
    return _apiClient.post<void>(
      path: '/Auth/forgot-password',
      body: {'email': email},
    );
  }

  Future<BaseResponse<void>> verifyPasswordCode(String email, String code) {
    return _apiClient.post<void>(
      path: '/Auth/verify-password-code',
      body: {'email': email, 'code': code},
    );
  }

  Future<BaseResponse<void>> resetPassword(String email, String newPassword) {
    return _apiClient.post<void>(
      path: '/Auth/reset-password',
      body: {'email': email, 'newPassword': newPassword},
    );
  }

  Future<BaseResponse<LoginResponse>> changePassword(String password) {
    return _apiClient.post<LoginResponse>(
      path: '/Auth/new-password',
      body: {'password': password},
      fromJson: (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// 🔓 Logout
  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }
}
