import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Temadan stilleri ve renkleri alalım
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // --- DEĞİŞİKLİK: MAVİ ÜZERİNDEKİ METİN RENKLERİ ---
    // Beyaz renk için colorScheme.onPrimary kullanıyoruz
    final onPrimaryColor = colorScheme.onPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hoş Geldiniz',
          style: textTheme.headlineMedium?.copyWith(color: onPrimaryColor),
        ),
        const SizedBox(height: 8),
        Text(
          'Bugün size nasıl yardımcı olabiliriz?',
          style: textTheme.bodyMedium?.copyWith(
            color: onPrimaryColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                // TextField'ın içini beyaz yapmak için dekorasyonu güncelliyoruz
                decoration: InputDecoration(
                  hintText: 'Tur, otel veya aktivite ara...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor:
                      colorScheme.surface, // Arka planını beyaz yapıyoruz
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none, // Kenar çizgisi olmasın
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              // Butonun stilini de değiştirelim, lacivert üzerinde daha iyi dursun
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.surface, // Beyaz buton
                foregroundColor: colorScheme.primary, // Mavi yazı
              ),
              child: const Text('Ara'),
            ),
          ],
        ),
      ],
    );
  }
}
