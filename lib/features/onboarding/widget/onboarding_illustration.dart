import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

/// Onboarding görselleri — asset yerine tema renkleriyle KOD İÇİNDE çizilir:
/// her yoğunlukta net, karanlık moda uyumlu, ek dosya/bakım yükü yok.
/// Kompozisyon: büyük tonlu daire + ana ikon + etrafında yüzen küçük rozetler
/// (uygulamanın genelindeki "tonlu daire" görsel diliyle aynı estetik).
class OnboardingIllustration extends StatelessWidget {
  final int index;

  const OnboardingIllustration({super.key, required this.index});

  static const List<_IllustrationSpec> _specs = [
    // 1 — Harika Turları Keşfet
    _IllustrationSpec(
      main: SolarIconsBold.compassBig,
      topRight: SolarIconsBold.mapPoint,
      bottomLeft: SolarIconsBold.star,
      bottomRight: SolarIconsBold.global,
    ),
    // 2 — Her Yere Transfer
    _IllustrationSpec(
      main: SolarIconsBold.bus,
      topRight: SolarIconsBold.routing,
      bottomLeft: SolarIconsBold.mapPoint,
      bottomRight: SolarIconsBold.mapArrowRight,
    ),
    // 3 — Kolay Rezervasyon (güvenli ödeme)
    _IllustrationSpec(
      main: SolarIconsBold.calendar,
      topRight: SolarIconsBold.card,
      bottomLeft: SolarIconsBold.checkCircle,
      bottomRight: SolarIconsBold.ticket,
    ),
    // 4 — Güvenle Seyahat Edin
    _IllustrationSpec(
      main: SolarIconsBold.shieldCheck,
      topRight: SolarIconsBold.headphonesRound,
      bottomLeft: SolarIconsBold.starFall,
      bottomRight: SolarIconsBold.userCheckRounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final spec = _specs[index.clamp(0, _specs.length - 1)];
    final secondary = context.colors.secondary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.biggest.shortestSide;
        final coreSize = side * 0.58;
        final chipSize = side * 0.22;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Dış halka (ince kontur)
            Container(
              width: coreSize * 1.35,
              height: coreSize * 1.35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: secondary.withValues(alpha: 0.10),
                  width: 1.5,
                ),
              ),
            ),
            // Ana tonlu daire + büyük ikon
            Container(
              width: coreSize,
              height: coreSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    secondary.withValues(alpha: 0.16),
                    secondary.withValues(alpha: 0.07),
                  ],
                ),
              ),
              child: Icon(spec.main, size: coreSize * 0.44, color: secondary),
            ),
            // Yüzen rozetler
            Positioned(
              top: side * 0.04,
              right: side * 0.10,
              child: _chip(context, spec.topRight, chipSize),
            ),
            Positioned(
              bottom: side * 0.10,
              left: side * 0.06,
              child: _chip(context, spec.bottomLeft, chipSize * 0.88),
            ),
            Positioned(
              bottom: side * 0.02,
              right: side * 0.16,
              child: _chip(context, spec.bottomRight, chipSize * 0.74),
            ),
          ],
        );
      },
    );
  }

  Widget _chip(BuildContext context, IconData icon, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: size * 0.5,
        color: context.colors.secondary,
      ),
    );
  }
}

class _IllustrationSpec {
  final IconData main;
  final IconData topRight;
  final IconData bottomLeft;
  final IconData bottomRight;

  const _IllustrationSpec({
    required this.main,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });
}
