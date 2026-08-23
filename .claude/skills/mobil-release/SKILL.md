---
name: mobil-release
description: Mobil uygulamanın mağaza sürüm sürecini yürütür — sürüm önerisi, pubspec artışı, tag, build ve mağaza adımları. Kullanıcı "mobil sürüm çıkalım", "release atalım", "mağazaya güncelleme" dediğinde çağrılır.
---

# Mobil Release Süreci

Standart: `docs/surecler/release-checklist.md` → "Sürümleme standardı" bölümü.
(SemVer + tek monoton build sayacı, asla sıfırlanmaz, iOS+Android ortak.)

## Adımlar (sırayla yürüt)

1. **Değişiklikleri topla:** son `mobil-v*` tag'inden bu yana commit'leri listele
   (`git log <son-tag>..HEAD --oneline`). Kullanıcıya 2-3 cümlelik özet ver.
2. **Sürüm öner:** değişikliklere göre PATCH mi MINOR mü (MAJOR nadir) gerekçesiyle öner;
   build = mevcut build + 1 (pubspec'ten oku). Kullanıcı onaylasın.
3. **Ön kontroller:**
   - `.env.ios` / `.env.android` → `cloud` **prod** API URL mi? (ngrok/localhost KALMIŞSA DUR)
   - `flutter analyze` temiz mi?
   - Ödeme akışına dokunulduysa: prod'da en az bir uçtan uca başarılı tur görüldü mü?
4. **Sürümü bas:** `pubspec.yaml` güncelle → commit `release(mobil): x.y.z+N` → push.
   Ardından MUTLAKA `flutter build ios --config-only` çalıştır — Xcode sürümü
   pubspec'ten değil `ios/Flutter/Generated.xcconfig`'ten okur; tazelenmezse
   Archive ESKİ build numarasını kullanır (2026-08-24'te yaşandı: 33 yerine 31).
   (Tag `mobil-vx.y.z` mağazada GERÇEKTEN yayınlanınca atılır.)
5. **"Yenilikler" metni yaz:** TR + EN, kullanıcıya sun (mağaza paneline o yapıştıracak).
   Yeni izin/SDK eklendiyse App Privacy/Data Safety değişikliği gerekip gerekmediğini söyle.
6. **Build komutlarını ver/çalıştır:**
   - iOS: `flutter build ipa --release` → çıktı `build/ios/ipa/*.ipa` → Transporter ile yükle
     (ya da Xcode Organizer). Signing: Distribution cert + profile hazır olmalı.
   - Android: `flutter build appbundle --release` → `build/app/outputs/bundle/release/app-release.aab`
     → Play Console → Production (veya önce Internal testing).
7. **Mağaza adımlarını listele:** TestFlight internal → App Store review (review notu:
   "Payments are for real-world services (tours/transfers) via bank's hosted page — IAP not
   applicable" + demo hesap); Play'de kademeli yayın (%20 → %100) öner.
8. **Kayıt:** release-checklist'teki tarihçe satırını güncelle
   (hangi sürüm+build, hangi tarih, hangi mağaza).

## Kurallar
- Build sayacı HİÇBİR koşulda geri gitmez/sıfırlanmaz; yayınlanmayan build'ler sorun değildir.
- Yayınlanmış sürüm adı yeniden kullanılmaz; aynı sürüm adının build'i artabilir (yayınlanana dek).
- Mağaza panellerine elle sürüm yazılmaz — tek kaynak pubspec.
