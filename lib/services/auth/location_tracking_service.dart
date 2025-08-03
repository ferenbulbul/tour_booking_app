import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationTrackingService {
  static Timer? _customerTimer;

  /// Servis (GPS) açık mı ve izin var mı? Gerekirse izin ister.
  static Future<bool> _ensureLocationPermission() async {
    // 1) Servis açık mı?
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Kullanıcıya bilgi gösterip ayarlara yönlendirebilirsiniz:
      // await Geolocator.openLocationSettings();
      return false;
    }

    // 2) İzin durumu
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      // Kullanıcı yine reddetti → takip başlatma
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      // Artık tekrar soramazsınız; sadece ayarlara yönlendirebilirsiniz:
      // await Geolocator.openAppSettings();
      return false;
    }

    // granted / whileInUse / always
    return true;
  }

  /// Şoför için arka plan izleme (ileride ayrı paketle yapılacak)
  static void startDriverTracking() {
    // TODO: flutter_background_geolocation gibi bir paketle kalıcı arka plan izleme
    print("Driver için sürekli konum takibi başlatıldı.");
  }

  /// Uygulama açıkken periyodik müşteri takibi
  static Future<void> startCustomerTracking() async {
    final ok = await _ensureLocationPermission();
    if (!ok) {
      print("Konum izni/servisi yok. Takip başlatılmadı.");
      return;
    }

    // Önce eski timer'ı durdur (yeniden başlatmalarda çakışmasın)
    _customerTimer?.cancel();

    // İlk konumu hemen gönder (isteğe bağlı)
    _sendOnceSafe();

    // Dakikada bir gönder
    _customerTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _sendOnceSafe();
    });
  }

  static void stopCustomerTracking() {
    _customerTimer?.cancel();
    _customerTimer = null;
    print("Müşteri konum takibi durduruldu.");
  }

  /// Konumu güvenli şekilde alıp gönder (izin/servis kapanırsa hata yakalar)
  static Future<void> _sendOnceSafe() async {
    try {
      // Servis veya izin sonradan kapanmış olabilir → tekrar kontrol et
      final ok = await _ensureLocationPermission();
      if (!ok) {
        print("Konum izni/servisi yok. Gönderim atlandı.");
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await sendLocationToBackend(position);
    } on PermissionDeniedException {
      // İzin reddedildi: sessizce bırak veya kullanıcıya snackbar gösterebilirsin.
      print("Kullanıcı konum iznini reddetti. Gönderim yapılmadı.");
    } on LocationServiceDisabledException {
      print("Konum servisi kapalı. Gönderim yapılmadı.");
    } catch (e) {
      // Ağ/timeout vb. tüm hataları yutmayın, loglayın
      print("Konum alınamadı/gönderilemedi: $e");
    }
  }

  static Future<void> sendLocationToBackend(Position pos) async {
    print("Konum gönderiliyor: ${pos.latitude}, ${pos.longitude}");
    // TODO: API çağrısı yap (try/catch ile)
  }
}
