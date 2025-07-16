import 'package:flutter/material.dart';
import 'dart:math' as math;

// Bu sınıf, SliverPersistentHeader'ın nasıl davranacağını tanımlar.
class _SettingsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;

  _SettingsHeaderDelegate({required this.minHeight, required this.maxHeight});

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Küçülme ilerlemesini hesapla (0.0 = tam geniş, 1.0 = tam küçülmüş)
    final progress = shrinkOffset / (maxExtent - minExtent);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Geniş haldeki büyük başlığın opaklığı. Küçüldükçe kaybolur.
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Opacity(
              opacity: 1.0 - progress,
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Daralmış haldeki (AppBar) başlığın opaklığı. Küçüldükçe ortaya çıkar.
          Center(
            child: Opacity(
              opacity: progress,
              child: Text(
                'Settings',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
            ),
          ),
          // Her zaman görünen actions butonu
          Positioned(
            top: MediaQuery.of(context).padding.top, // Status bar boşluğu
            right: 4,
            child: IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SettingsHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight;
  }
}

// Bu, dışarıdan kullanacağımız asıl widget'ımız.
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true, // Başlığın tepede sabitlenmesini sağlar
      delegate: _SettingsHeaderDelegate(
        minHeight: 100.0, // Daralmış haldeki yükseklik
        maxHeight: 200.0, // Genişlemiş haldeki yükseklik
      ),
    );
  }
}
