import 'dart:convert';

class LocationValidationResult {
  final bool isValid;
  final String? errorMessage;

  const LocationValidationResult({required this.isValid, this.errorMessage});
}

class LocationValidator {
  // ------------------------------------------------------------
  // NORMALIZE → Türkçe/İngilizce gereksiz kelimeleri temizle
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
        .replaceAll("center", "")
        .replaceAll("central district", "")
        .replaceAll("central", "")
        .replaceAll("downtown", "")
        .trim();
  }

  // ------------------------------------------------------------
  // İngilizce gelen ilçe adlarını MERKEZ olarak kabul et
  // ------------------------------------------------------------
  static String fixEnglishDistrict(String d) {
    final x = d.toLowerCase();

    const centerWords = [
      "center",
      "city center",
      "central",
      "central district",
      "downtown",
      "town center",
      "main city",
    ];

    if (centerWords.contains(x)) return "merkez";

    return d;
  }

  // ------------------------------------------------------------
  // DISTRICT EXTRACT (FullMapView ile birebir aynı)
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
  // VALİDASYON ENTRANCE
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

    // İngilizce düzeltme
    apiDistRaw = fixEnglishDistrict(apiDistRaw);

    // Normalize edilmiş değerler
    final apiCity = normalize(apiCityRaw);
    final apiDist = normalize(apiDistRaw);

    final wantCity = normalize(expectedCity);
    final wantDist = normalize(expectedDistrict);

    // ------------------------------------------------------------
    // ŞEHİR UYUŞMAZ
    // ------------------------------------------------------------
    if (apiCity != wantCity) {
      return LocationValidationResult(
        isValid: false,
        errorMessage:
            "Bu konum $expectedCity / $expectedDistrict sınırlarında değil!",
      );
    }

    // ------------------------------------------------------------
    // İLÇE EŞLEŞME — ESNEK
    // ------------------------------------------------------------
    bool sameDistrict = apiDist == wantDist;

    // Merkez → Ortahisar gibi eşleştirmeler
    if (!sameDistrict) {
      // 1. Seçilen merkez ama beklenen şehir merkeziyse
      if (apiDist == "merkez" && wantDist == wantCity) {
        sameDistrict = true;
      }

      // 2. Trabzon özel → Merkez = Ortahisar
      if (!sameDistrict) {
        if (wantDist.contains("ortahisar") &&
            (apiDist.contains("merkez") || apiDist == "merkez")) {
          sameDistrict = true;
        }
      }
    }

    if (!sameDistrict) {
      return LocationValidationResult(
        isValid: false,
        errorMessage:
            "Bu konum $expectedCity / $expectedDistrict sınırlarında değil!",
      );
    }

    // ------------------------------------------------------------
    // TÜM KONTROLLER GEÇTİ
    // ------------------------------------------------------------
    return const LocationValidationResult(isValid: true);
  }
}
