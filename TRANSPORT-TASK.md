# TourBooking - Transport Özelliği - Flutter Mobil

## Proje
- **Yol:** `/Users/erenbulbul/Applications/tour_booking_app`
- **Framework:** Flutter
- **Yapı:** Feature-based (`lib/features/`, `lib/core/`)
- **Network:** `lib/core/network/`
- **Theme:** `lib/core/theme/`
- **Widgets:** `lib/core/widgets/`

## API Bilgisi
- Production: `https://tourbooking-api-272954735037.europe-west2.run.app/api`
- Local: `http://localhost:8080/api`
- Auth: Bearer token (Header: `Authorization: Bearer {token}`)
- Dil: Header `Accept-Language: tr` (veya en, ar)
- Response formatı: `{ data: {...}, statusCode: 200, isSuccess: true, message: null }`

## Google Maps
- Flutter tarafında Google Maps SDK kullanılacak (anlık mesafe/rota gösterimi için)
- Backend ayrıca kendi API key'i ile mesafe doğrulaması yapıyor
- Flutter'da `google_maps_flutter` ve `google_directions_api` veya `flutter_polyline_points` paketleri kullanılabilir

---

## YAPILACAKLAR

### 1. Yeni Feature: `lib/features/transport/`

Mevcut feature pattern'ini takip et. Örnek olarak `lib/features/home/` veya `lib/features/bookings/` yapısına bak.

---

### 2. Ekran 1: Transport Ana Sayfa (`TransportScreen`)

**Öğeler:**
- Pickup noktası seçimi (harita + arama + önerilen lokasyonlar)
- Dropoff noktası seçimi (harita + arama + önerilen lokasyonlar)
- Tarih seçici (DatePicker)
- Saat seçici (TimePicker)
- "Araç Ara" butonu

**Önerilen Lokasyonlar API (Public):**
```
GET /api/mobile/transport/suggested-locations?cityId={guid}
Header: Accept-Language: tr

Response.data.locations: [
  {
    "id": "guid",
    "name": "İstanbul Havalimanı",
    "description": "Yeni havalimanı",
    "latitude": 41.2606,
    "longitude": 28.7419,
    "cityId": "guid",
    "districtId": "guid | null"
  }
]
```

**UX:** Kullanıcı haritada pin koyabilir veya önerilen lokasyonlardan seçebilir. Serbest adres girişi de olmalı (Google Places Autocomplete).

---

### 3. Ekran 2: Araç Listesi (`TransportVehicleListScreen`)

**Araç Arama API (Public):**
```
POST /api/mobile/transport/search-vehicles
Body: {
  "cityId": "guid",
  "districtId": "guid | null",
  "date": "2026-04-15",
  "startTime": "10:00",
  "estimatedDurationMinutes": 60
}

Response.data.vehicles: [
  {
    "vehicleId": "guid",
    "transportPricingId": "guid",    ← ÖNEMLİ: sonraki adımlarda bu kullanılacak
    "vehicleImage": "url",
    "licensePlate": "34 ABC 123",
    "seatCount": 4,
    "brandName": "Mercedes",
    "className": "Vito",
    "baseFee": 500.00,
    "pricePerKm": 15.50,
    "currency": "TRY",
    "driverName": "Ahmet Yılmaz",
    "agencyName": "ABC Transfer"
  }
]
```

**UI:**
- Kart listesi: Araç fotoğrafı, marka+model, koltuk sayısı, baz ücret, km başı ücret, sürücü adı, acenta adı
- Karta tıkla → fiyat hesaplama ekranına git

**Not:** `estimatedDurationMinutes` default 60 gönder veya kullanıcıdan "tahmini süre" sorabilirsin.

---

### 4. Ekran 3: Fiyat Hesaplama & Özet (`TransportSummaryScreen`)

**Fiyat Hesaplama API (Public):**
```
POST /api/mobile/transport/calculate-price
Body: {
  "transportPricingId": "guid",
  "pickupLatitude": 41.0082,
  "pickupLongitude": 28.9784,
  "dropoffLatitude": 41.2606,
  "dropoffLongitude": 28.7419
}

Response.data: {
  "distanceKm": 35.2,
  "estimatedDurationMinutes": 45,
  "baseFee": 500.00,
  "pricePerKm": 15.50,
  "totalPrice": 1045.60,
  "currency": "TRY"
}
```

**UI:**
- Google Maps ile pickup→dropoff rota çizgisi (polyline)
- Mesafe: 35.2 km
- Tahmini süre: 45 dakika
- Fiyat detayı: Baz Ücret: ₺500 + (35.2 km × ₺15.50) = ₺1,045.60
- Toplam: ₺1,045.60
- "Rezervasyon Yap" butonu (login gerektirir)

**Google Maps SDK:**
- Anlık olarak haritada rota göster
- `flutter_polyline_points` veya benzeri paket ile rota çiz
- Backend'den gelen fiyatı göster (backend doğrulanmış fiyat)

---

### 5. Booking Oluşturma (Auth Gerekli - Customer)

**API:**
```
POST /api/mobile/transport/create-booking
Header: Authorization: Bearer {token}
Body: {
  "transportPricingId": "guid",
  "date": "2026-04-15",
  "pickupTime": "10:00",
  "pickupAddress": "Taksim Meydanı",
  "pickupLatitude": 41.0370,
  "pickupLongitude": 28.9850,
  "dropoffAddress": "İstanbul Havalimanı",
  "dropoffLatitude": 41.2606,
  "dropoffLongitude": 28.7419
}

Response.data: {
  "bookingId": "guid"    ← bunu mevcut ödeme akışına gönder
}
```

**Akış:**
1. Login kontrolü (yoksa login'e yönlendir)
2. create-booking çağır → bookingId al
3. Mevcut Iyzico ödeme akışına yönlendir (bookingId ile)
4. Ödeme başarılı → başarı ekranı

---

### 6. Sürücü: Yolcu Bırakma (Auth Gerekli - Driver)

**Sürücü paneline eklenecek** (mevcut sürücü ekranlarını kontrol et)

**API:**
```
POST /api/mobile/transport/complete-dropoff
Header: Authorization: Bearer {token}
Body: {
  "bookingId": "guid"
}

Response.data: {
  "success": true,
  "message": "Yolcu bırakıldı, araç tekrar müsait."
}
```

**UI:**
- Sürücünün aktif transport booking'leri listesi
- Her booking kartında "Yolcu Bırakıldı" butonu
- Butona basınca onay dialog → API çağrısı → başarı mesajı
- Bu işlem sonrası araç tekrar müsait olur

**Not:** Sürücü booking'lerini görmek için mevcut booking listesi endpoint'leri kullanılabilir. Booking'de `bookingType: 1` olanlar transport.

---

### 7. Müşteri Booking Geçmişi Güncelleme

Mevcut booking geçmişi ekranında (`lib/features/bookings/`) transport booking'ler de gösterilecek.

Mevcut endpoint'e yeni alanlar eklendi:
```
GET /api/mobile/customer-booking?type=upcoming
Response'daki her booking'de artık:
- bookingType: 0 = Tour, 1 = Transport
- pickupAddress: "Taksim Meydanı" (sadece transport)
- dropoffAddress: "İstanbul Havalimanı" (sadece transport)
- distanceKm: 35.2 (sadece transport)
- pickupTime: "10:00" (sadece transport)
```

**UI:**
- `bookingType == 1` ise transport kartı göster (farklı tasarım)
- Transport kartında: pickup → dropoff, mesafe, saat bilgisi
- `bookingType == 0` ise mevcut tur kartı (değişiklik yok)

---

## ÖNEMLİ NOTLAR
- `transportPricingId` araç arama sonucundan alınır ve sonraki tüm adımlarda kullanılır
- `customerId` ve `driverUserId` token'dan backend'de otomatik alınır, body'de GÖNDERME
- Fiyat: Flutter'da anlık gösterim (Google Maps SDK), backend'de doğrulama (create-booking sırasında)
- Mevcut proje pattern'lerini incele ve aynı şekilde yaz (widget yapısı, network çağrıları, state yönetimi)
- Ödeme akışı mevcut Iyzico checkout ile aynı (sadece bookingId gerekli)
