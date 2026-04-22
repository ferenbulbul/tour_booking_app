class LocationValidationResult {
  final bool isValid;
  final String? errorMessage;

  const LocationValidationResult({required this.isValid, this.errorMessage});
}

class LocationValidator {
  // ------------------------------------------------------------
  // TEMİZLEME
  // ------------------------------------------------------------
  static String normalize(String s) {
    return s
        .toLowerCase()
        .replaceAll("province", "")
        .replaceAll("district", "")
        .replaceAll("belediyesi", "")
        .replaceAll("belediy", "")
        .replaceAll("ilçe", "")
        .replaceAll("il", "")
        .replaceAll("city", "")
        .replaceAll("center", "")
        .replaceAll("central", "")
        .replaceAll("downtown", "")
        .trim();
  }

  // ------------------------------------------------------------
  // CENTER / DOWNTOWN EŞ KELİMELERİ GLOBAL
  // ------------------------------------------------------------
  static const centerWords = [
    "merkez",
    "center",
    "city center",
    "central",
    "central district",
    "downtown",
    "town center",
    "main city",
    "old town",
    "historic center",
  ];

  // ------------------------------------------------------------
  // API’den gelen DISTRICT → merkez eşleştirmesi
  // ------------------------------------------------------------
  static bool isGlobalCenterMatch(
    String apiDist,
    String apiCity,
    String wantDist,
  ) {
    apiDist = apiDist.toLowerCase().trim();
    apiCity = apiCity.toLowerCase().trim();
    wantDist = wantDist.toLowerCase().trim();

    // 1) Sadece "merkez / center" türleri
    for (final w in centerWords) {
      if (apiDist == w) return true;
      if (apiDist == "$apiCity $w") return true;
    }

    // 2) Eğer API “{city} merkez” diyorsa
    if (apiDist.contains(apiCity) && apiDist.contains("merkez")) {
      return true;
    }

    // 3) Beklenen district şehir adı ise (= merkez)
    if (wantDist == apiCity && apiDist.contains("merkez")) {
      return true;
    }

    return false;
  }

  // ------------------------------------------------------------
  // DISTRICT EXTRACT
  // ------------------------------------------------------------
  static String resolveDistrict(List<dynamic> comps) {
    String? level2;
    String? level3;
    String? locality;
    String? sublocality;

    for (final c in comps) {
      final types = List<String>.from(c["types"]);
      final name = c["long_name"] as String;

      if (types.contains("administrative_area_level_2")) level2 = name;
      if (types.contains("administrative_area_level_3")) level3 = name;
      if (types.contains("locality")) locality = name;
      if (types.contains("sublocality") ||
          types.contains("sublocality_level_1")) {
        sublocality = name;
      }
    }

    return level2 ?? level3 ?? locality ?? sublocality ?? "";
  }

  // ------------------------------------------------------------
  // CITY EXTRACT
  // ------------------------------------------------------------
  static String extractCity(List<dynamic> comps) {
    for (final c in comps) {
      final types = List<String>.from(c["types"]);
      if (types.contains("administrative_area_level_1")) {
        return c["long_name"];
      }
    }
    return "";
  }

  // ------------------------------------------------------------
  // 🔥 FINAL VALIDATION
  // ------------------------------------------------------------
  static LocationValidationResult validate({
    required List<dynamic> components,
    required String formatted,
    required String expectedCity,
    required String expectedDistrict,
  }) {
    final apiCityRaw = extractCity(components);
    var apiDistRaw = resolveDistrict(components);

    if (apiCityRaw.isEmpty || apiDistRaw.isEmpty) {
      return const LocationValidationResult(
        isValid: false,
        errorMessage: "Adres tespit edilemedi.",
      );
    }

    final apiCity = normalize(apiCityRaw);
    final apiDist = normalize(apiDistRaw);
    final wantCity = normalize(expectedCity);
    final wantDist = normalize(expectedDistrict);

    // 1) Şehir uyuşmazsa direkt fail
    if (apiCity != wantCity) {
      return LocationValidationResult(
        isValid: false,
        errorMessage:
            "Bu konum $expectedCity / $expectedDistrict sınırlarında değil!",
      );
    }

    // 2) İlçe tam eşleşme
    bool match = apiDist == wantDist;

    // 3) Global otomatik merkez eşleştirmesi
    if (!match) {
      if (isGlobalCenterMatch(apiDistRaw, apiCityRaw, wantDist)) {
        match = true;
      }
    }

    if (!match) {
      return LocationValidationResult(
        isValid: false,
        errorMessage:
            "Bu konum $expectedCity / $expectedDistrict sınırlarında değil!",
      );
    }

    return const LocationValidationResult(isValid: true);
  }
}
