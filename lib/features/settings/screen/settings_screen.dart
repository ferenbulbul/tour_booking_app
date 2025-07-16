import 'package:flutter/material.dart';
import 'package:tour_booking/features/settings/widgets/content_card.dart';
import 'package:tour_booking/features/settings/widgets/settings_header.dart';

// Gerekli widget'ları import ediyoruz

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Kartın AppBar'ın üzerine ne kadar bineceğini belirleyen sabit
    const double overlapAmount = 30.0;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // En iyi kaydırma deneyimi için CustomScrollView
      body: CustomScrollView(
        slivers: <Widget>[
          // --- SLIVER 1: KENDİN YAPTIĞIN, TAM KONTROLE SAHİP BAŞLIK ---
          const SettingsHeader(),

          // --- SLIVER 2: "TAŞMA" EFEKTİ İÇİN YARDIMCI SLIVER ---
          // Bu Sliver, sadece ilk kartın yukarı taşması için bir container görevi görür.
          SliverToBoxAdapter(
            child: Transform.translate(
              // Kartı dikeyde yukarı kaydırarak overlap efektini yaratıyoruz
              offset: const Offset(0, -overlapAmount),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ContentCard(
                  child: SizedBox(height: 220, width: double.infinity),
                ),
              ),
            ),
          ),

          // --- SLIVER 3: GERİ KALAN KARTLAR ---
          // Diğer kartları temiz bir şekilde listeliyoruz.
          SliverPadding(
            // Üstteki padding, ilk kartın kapladığı yerden dolayı oluşan boşluğu telafi eder.
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // İlk kart yukarıda olduğu için, diğer kartlar doğrudan listelenir
                const ContentCard(
                  child: SizedBox(height: 150, width: double.infinity),
                ),
                const SizedBox(height: 24),
                const ContentCard(
                  child: SizedBox(height: 180, width: double.infinity),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
