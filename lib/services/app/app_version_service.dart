import 'package:tour_booking/models/base/base_response.dart';
import 'package:tour_booking/models/version_check/version_check_response.dart';
import 'package:tour_booking/services/core/api_client.dart';

/// Açılışta zorunlu güncelleme kontrolü. Backend, sürümü env'deki minimumla
/// karşılaştırır (MobileApp__MinVersion*) — zorlamayı artırmak deploy istemez.
class AppVersionService {
  final ApiClient _apiClient;

  AppVersionService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<BaseResponse<VersionCheckResponse>> checkVersion({
    required String platform,
    required String version,
  }) {
    return _apiClient.get<VersionCheckResponse>(
      path: "/app/version-check",
      queryParams: {"platform": platform, "version": version},
      fromJson: (json) =>
          VersionCheckResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
