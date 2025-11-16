import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:tour_booking/features/auth/login/widgets/google_view_model.dart';
import 'package:tour_booking/models/auth_response/auth_response.dart';
import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/refresh_token_request/refresh_token_request.dart';
import 'package:tour_booking/navigation/app_navigator.dart';
import 'package:tour_booking/services/core/secure_token_storage.dart';
import 'package:tour_booking/services/core/safe_call.dart';

class ApiClient {
  final http.Client _client;
  final SecureTokenStorage _tokenStorage = SecureTokenStorage();
  final String _baseUrl = dotenv.env['baseUrl'] ?? '';
  final String _mobileUrl = dotenv.env['mobileAndroid'] ?? '';
  final String _cloudUrl = dotenv.env['cloud'] ?? '';
  final AuthViewModel? _authViewModel;

  ApiClient({AuthViewModel? authViewModel, http.Client? client})
    : _client = client ?? http.Client(),
      _authViewModel = authViewModel;

  Map<String, String> _headers({String? token, Map<String, String>? extra}) {
    final localeCode =
        appNavigatorKey.currentContext?.locale.languageCode ?? 'en';
    return {
      'Content-Type': 'application/json',
      'Accept-Language': localeCode,
      if (token != null) 'Authorization': 'Bearer $token',
      if (extra != null) ...extra,
    };
  }

  Future<BaseResponse<T>> _handle<T>({
    required Future<http.Response> Function(String token) send,
    T Function(Object?)? fromJson,
  }) async {
    return safeCall<T>(() async {
      String? token = await _tokenStorage.getAccessToken();
      http.Response response = await send(token ?? '');

      if (response.statusCode == 401) {
        final refreshSuccess = await _refreshAccessToken();
        if (refreshSuccess) {
          final newToken = await _tokenStorage.getAccessToken();
          response = await send(newToken ?? '');
          if (response.statusCode == 401) {
            await _authViewModel?.signOut();
            appNavigatorKey.currentContext?.pushReplacement('/login');
            ;
            return Future.error("Oturum süresi doldu.");
          }
        } else {
          await _authViewModel?.signOut();
          appNavigatorKey.currentContext?.pushReplacement('/login');
          return Future.error("Oturum süresi doldu.");
        }
      }

      final map = jsonDecode(response.body) as Map<String, dynamic>;
      return BaseResponse<T>.fromJson(map, fromJson ?? (_) => null as T);
    });
  }

  Future<bool> _refreshAccessToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    // freezed model kullanarak body hazırla
    final request = RefreshTokenRequest(refreshToken: refreshToken);

    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/refresh-token'),
      headers: _headers(),
      body: jsonEncode(request.toJson()), // modelden json
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // backend ApiResponse<AuthResponse> dönüyor, önce data’yı çekiyoruz
      final auth = AuthResponse.fromJson(data['data'] as Map<String, dynamic>);

      await _tokenStorage.saveTokens(auth.accessToken, auth.refreshToken);
      return true;
    }

    return false;
  }

  // GET
  Future<BaseResponse<T>> get<T>({
    required String path,
    Map<String, String>? queryParams,
    Map<String, String>? extraHeaders,
    T Function(Object?)? fromJson,
  }) {
    return _handle<T>(
      fromJson: fromJson,
      send: (token) => _client.get(
        Uri.parse('$_baseUrl$path').replace(queryParameters: queryParams),
        headers: _headers(token: token, extra: extraHeaders),
      ),
    );
  }

  // POST
  Future<BaseResponse<T>> post<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, String>? extraHeaders,
    T Function(Object?)? fromJson,
  }) {
    return _handle<T>(
      fromJson: fromJson,
      send: (token) => _client.post(
        Uri.parse('$_baseUrl$path'),
        headers: _headers(token: token, extra: extraHeaders),
        body: jsonEncode(body ?? {}),
      ),
    );
  }

  // PUT
  Future<BaseResponse<T>> put<T>({
    required String path,
    Map<String, dynamic>? body,
    Map<String, String>? extraHeaders,
    T Function(Object?)? fromJson,
  }) {
    return _handle<T>(
      fromJson: fromJson,
      send: (token) => _client.put(
        Uri.parse('$_baseUrl$path'),
        headers: _headers(token: token, extra: extraHeaders),
        body: jsonEncode(body ?? {}),
      ),
    );
  }

  // DELETE
  Future<BaseResponse<T>> delete<T>({
    required String path,
    Map<String, String>? extraHeaders,
    T Function(Object?)? fromJson,
  }) {
    return _handle<T>(
      fromJson: fromJson,
      send: (token) => _client.delete(
        Uri.parse('$_baseUrl$path'),
        headers: _headers(token: token, extra: extraHeaders),
      ),
    );
  }
}
