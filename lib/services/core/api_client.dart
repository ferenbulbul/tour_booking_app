import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
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
  late String _url = _baseUrl;

  /// HTTP request timeout — prevents hanging indefinitely
  static const Duration _requestTimeout = Duration(seconds: 30);

  /// Session expired callback — SplashVM tarafindan set edilir
  static Future<void> Function()? onSessionExpired;

  /// In-memory token cache — avoids expensive secure storage reads on every request
  static String? _cachedAccessToken;
  static String? _cachedRefreshToken;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

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

  /// Get token from memory cache first, fallback to secure storage
  Future<String?> _getToken() async {
    if (_cachedAccessToken != null) return _cachedAccessToken;
    _cachedAccessToken = await _tokenStorage.getAccessToken();
    return _cachedAccessToken;
  }

  /// Save tokens to both memory and secure storage
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    _cachedAccessToken = accessToken;
    _cachedRefreshToken = refreshToken;
    await _tokenStorage.saveTokens(accessToken, refreshToken);
  }

  /// Clear token cache
  static void clearTokenCache() {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
  }

  Future<BaseResponse<T>> _handle<T>({
    required Future<http.Response> Function(String token) send,
    T Function(Object?)? fromJson,
    String? debugPath,
  }) async {
    return safeCall<T>(() async {
      final sw = Stopwatch()..start();
      String? token = await _getToken();
      debugPrint(
        '[ApiClient] ${debugPath ?? "?"} → token: ${token != null ? "${token.substring(0, 10)}..." : "NULL"} (${sw.elapsedMilliseconds}ms)',
      );
      http.Response response = await send(token ?? '').timeout(_requestTimeout);
      debugPrint(
        '[ApiClient] ${debugPath ?? "?"} → ${response.statusCode} (${sw.elapsedMilliseconds}ms)',
      );

      if (response.statusCode == 401) {
        final refreshSuccess = await _refreshAccessToken();
        if (refreshSuccess) {
          final newToken = _cachedAccessToken;
          response = await send(newToken ?? '').timeout(_requestTimeout);
          if (response.statusCode == 401) {
            await onSessionExpired?.call();
            return Future.error("Oturum süresi doldu.");
          }
        } else {
          await onSessionExpired?.call();
          return Future.error("Oturum süresi doldu.");
        }
      }

      if (response.body.isEmpty) {
        return BaseResponse<T>(
          isSuccess: false,
          message: 'error_generic',
          validationErrors: const [],
          data: null,
        );
      }

      final map = jsonDecode(response.body) as Map<String, dynamic>;
      return BaseResponse<T>.fromJson(map, fromJson ?? (_) => null as T);
    });
  }

  Future<bool> _refreshAccessToken() async {
    final refreshToken =
        _cachedRefreshToken ?? await _tokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final request = RefreshTokenRequest(refreshToken: refreshToken);

      final response = await _client
          .post(
            Uri.parse('$_url/auth/refresh-token'),
            headers: _headers(),
            body: jsonEncode(request.toJson()),
          )
          .timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final auth = AuthResponse.fromJson(
          data['data'] as Map<String, dynamic>,
        );
        await _saveTokens(auth.accessToken, auth.refreshToken);
        return true;
      }
    } on TimeoutException {
      debugPrint('[ApiClient] Token refresh timed out');
    } catch (e) {
      debugPrint('[ApiClient] Token refresh failed: $e');
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
    final fullUri = Uri.parse(
      '$_url$path',
    ).replace(queryParameters: queryParams);
    debugPrint('[ApiClient] GET $fullUri');
    return _handle<T>(
      debugPath: 'GET $path',
      fromJson: fromJson,
      send: (token) => _client.get(
        fullUri,
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
    debugPrint('[ApiClient] POST $_url$path');
    return _handle<T>(
      debugPath: 'POST $path',
      fromJson: fromJson,
      send: (token) => _client.post(
        Uri.parse('$_url$path'),
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
        Uri.parse('$_url$path'),
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
        Uri.parse('$_url$path'),
        headers: _headers(token: token, extra: extraHeaders),
      ),
    );
  }
}
