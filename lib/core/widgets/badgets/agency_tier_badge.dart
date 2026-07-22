import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

/// Acenta seviye rozeti (Gold, Premium, Elit...). Renk backend'den
/// hex string olarak gelir (#RRGGBB); parse edilemezse gri kullanılır.
///
/// [filled] true iken fotoğraf üzerinde okunabilmesi için dolgulu
/// (renkli zemin + beyaz yazı) çizilir; false iken hafif tonlu pill.
class AgencyTierBadge extends StatelessWidget {
  final String tierName;
  final String? badgeColor;
  final bool filled;

  const AgencyTierBadge({
    super.key,
    required this.tierName,
    this.badgeColor,
    this.filled = false,
  });

  static const _fallbackColor = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    final color = _parseHex(badgeColor) ?? _fallbackColor;
    final foreground = filled ? Colors.white : color;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: filled
            ? color.withValues(alpha: 0.9)
            : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: filled
            ? null
            : Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            SolarIconsBold.medalRibbonStar,
            size: 11,
            color: foreground,
            semanticLabel: 'Agency tier',
          ),
          const SizedBox(width: 3),
          Text(
            tierName,
            style: AppTextStyles.caption.copyWith(
              fontSize: 11,
              color: foreground,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }

  static Color? _parseHex(String? hex) {
    if (hex == null) return null;
    var value = hex.replaceFirst('#', '');
    if (value.length == 6) value = 'FF$value';
    if (value.length != 8) return null;
    final parsed = int.tryParse(value, radix: 16);
    return parsed == null ? null : Color(parsed);
  }
}
