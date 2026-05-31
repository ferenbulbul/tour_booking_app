import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tour_booking/services/core/api_client.dart';

class SecureTokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    // Update in-memory cache FIRST so subsequent API calls use the new token
    ApiClient.updateTokenCache(accessToken, refreshToken);
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  Future<void> clearTokens() async {
    ApiClient.clearTokenCache();
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
  }
}
