# TourBooking Mobil (tour_booking)

Flutter müşteri + sürücü uygulaması. Provider (ViewModel'ler) + manuel
ServiceLocator DI (`lib/core/di/service_locator.dart`), go_router
(`lib/navigation/app_router.dart`, deep link destekli), easy_localization
(tr/en/ar, `assets/translations/`), OneSignal push, Firebase auth/analytics.

## Dokümantasyon (ÖNEMLİ)

Platformun merkezi dokümantasyonu API reposundadır:
`/Users/erenbulbul/TourBooking/docs/README.md` — modül bazlıdır ve bu projeyi de
kapsar. Bu repoya özel mimari doküman: `/Users/erenbulbul/TourBooking/docs/mimari/mobil.md`.

**Kural: Bir modülde değişiklik yaptıktan sonra ilgili
`TourBooking/docs/moduller/<modul>.md` dosyasını güncelle** (API reposundaki
`/docs-guncelle` skill'i bunu otomatikleştirir).

## Kardeş projeler

- API (.NET 8): `/Users/erenbulbul/TourBooking`
- Backoffice (React): `/Users/erenbulbul/Tourbook-Backoffice`

## Komutlar ve ortam

- Çalıştırma: `flutter run` — ortam dosyaları platforma göre yüklenir:
  `.env.android` / `.env.ios` (anahtarlar: `cloud` = API base URL, `PLACES_API_KEY`).
- Sürüm: `pubspec.yaml` `version: x.y.z+build` (store release öncesi artır).
- iOS: Podfile'da `PERMISSION_NOTIFICATIONS=1` zorunludur (permission_handler
  bildirimi ancak böyle görür).

## Konvansiyonlar

- Yeni ekran: `lib/features/<modul>/` altında screen + ViewModel,
  `main.dart` AppProviders'a ChangeNotifierProvider kaydı,
  `lib/navigation/routes/` altına route, üç dile çeviri
  (`assets/translations/tr.json` + en + ar).
- API çağrıları `lib/services/` altındaki servislerden `ApiClient` ile yapılır
  (token cache + 401 refresh + Accept-Language orada).
- UI metinleri çeviri anahtarlarıyla (tr/en/ar), kod İngilizce.
