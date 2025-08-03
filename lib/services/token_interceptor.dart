// lib/core/network/token_interceptor.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tour_booking/services/auth/secure_token_storage.dart';

class TokenInterceptor {
  final _client = http.Client();
  final _storage = SecureTokenStorage();
  final String _baseUrl = dotenv.env['baseUrl'] ?? '';

  Future<http.Response> sendAuthorizedRequest({
    required http.Request request,
  }) async {
    final token = await _storage.getAccessToken();
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'application/json';

    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);

    // access token expired ise
    if (response.statusCode == 401) {
      final refreshSuccess = await _refreshAccessToken();
      if (refreshSuccess) {
        final newToken = await _storage.getAccessToken();
        request.headers['Authorization'] = 'Bearer $newToken';
        final retry = await _client.send(request);
        return http.Response.fromStream(retry);
      } else {
        await _storage.clearTokens();
        throw Exception("Session expired. Please login again.");
      }
    }

    return response;
  }

  Future<bool> _refreshAccessToken() async {
    final refresh = await _storage.getRefreshToken();
    if (refresh == null) return false;

    final response = await _client.post(
      Uri.parse('$_baseUrl/refresh-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refresh}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final access = data['data']['accessToken'];
      final newRefresh = data['data']['refreshToken'];
      await _storage.saveTokens(access, newRefresh);
      return true;
    }

    return false;
  }
}
