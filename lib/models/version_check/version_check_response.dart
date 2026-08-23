class VersionCheckResponse {
  final bool updateRequired;
  final String? minVersion;
  final String? storeUrl;

  VersionCheckResponse({
    required this.updateRequired,
    this.minVersion,
    this.storeUrl,
  });

  factory VersionCheckResponse.fromJson(Map<String, dynamic> json) {
    return VersionCheckResponse(
      updateRequired: json['updateRequired'] == true,
      minVersion: json['minVersion'] as String?,
      storeUrl: json['storeUrl'] as String?,
    );
  }
}
