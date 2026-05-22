import 'package:flutter/material.dart';

/// ThemeExtension for colors not covered by Material 3 [ColorScheme].
/// Access via `Theme.of(context).extension<AppColorsExtension>()!`
/// or the convenience getter `context.ext`.
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.textLight,
    required this.surfaceDark,
    required this.surfaceLight,
    required this.success,
    required this.successBg,
    required this.info,
    required this.infoBg,
    required this.warning,
    required this.warningBg,
    required this.errorBg,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.star,
    required this.favorite,
    required this.purple,
    required this.difficultyEasy,
    required this.difficultyMedium,
    required this.difficultyHard,
    required this.confettiGreen,
    required this.confettiGold,
  });

  final Color textLight;
  final Color surfaceDark;
  final Color surfaceLight;
  final Color success;
  final Color successBg;
  final Color info;
  final Color infoBg;
  final Color warning;
  final Color warningBg;
  final Color errorBg;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color star;
  final Color favorite;
  final Color purple;
  final Color difficultyEasy;
  final Color difficultyMedium;
  final Color difficultyHard;
  final Color confettiGreen;
  final Color confettiGold;

  // ── Light theme values ──────────────────────────────────────
  static const light = AppColorsExtension(
    textLight: Color(0xFF94A3B8),
    surfaceDark: Color(0xFFF1F3F7),
    surfaceLight: Color(0xFFF9FAFB),
    success: Color(0xFF22C55E),
    successBg: Color(0xFFF0FDF4),
    info: Color(0xFF3B82F6),
    infoBg: Color(0xFFEFF6FF),
    warning: Color(0xFFF59E0B),
    warningBg: Color(0xFFFFFBEB),
    errorBg: Color(0xFFFEF2F2),
    shimmerBase: Color(0xFFE0E0E0),
    shimmerHighlight: Color(0xFFF5F5F5),
    star: Color(0xFFFFC107),
    favorite: Color(0xFFEF4444),
    purple: Color(0xFF8B5CF6),
    difficultyEasy: Color(0xFF4CAF50),
    difficultyMedium: Color(0xFFFF9800),
    difficultyHard: Color(0xFFE53935),
    confettiGreen: Color(0xFFA5D6A7),
    confettiGold: Color(0xFFFFD54F),
  );

  // ── Dark theme values ───────────────────────────────────────
  static const dark = AppColorsExtension(
    textLight: Color(0xFF6B7280),
    surfaceDark: Color(0xFF1E1E1E),
    surfaceLight: Color(0xFF242424),
    success: Color(0xFF4ADE80),
    successBg: Color(0xFF14532D),
    info: Color(0xFF60A5FA),
    infoBg: Color(0xFF1E3A5F),
    warning: Color(0xFFFBBF24),
    warningBg: Color(0xFF422006),
    errorBg: Color(0xFF450A0A),
    shimmerBase: Color(0xFF2A2A2A),
    shimmerHighlight: Color(0xFF3A3A3A),
    star: Color(0xFFFFC107),
    favorite: Color(0xFFEF4444),
    purple: Color(0xFFA78BFA),
    difficultyEasy: Color(0xFF66BB6A),
    difficultyMedium: Color(0xFFFFA726),
    difficultyHard: Color(0xFFEF5350),
    confettiGreen: Color(0xFFA5D6A7),
    confettiGold: Color(0xFFFFD54F),
  );

  @override
  AppColorsExtension copyWith({
    Color? textLight,
    Color? surfaceDark,
    Color? surfaceLight,
    Color? success,
    Color? successBg,
    Color? info,
    Color? infoBg,
    Color? warning,
    Color? warningBg,
    Color? errorBg,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? star,
    Color? favorite,
    Color? purple,
    Color? difficultyEasy,
    Color? difficultyMedium,
    Color? difficultyHard,
    Color? confettiGreen,
    Color? confettiGold,
  }) {
    return AppColorsExtension(
      textLight: textLight ?? this.textLight,
      surfaceDark: surfaceDark ?? this.surfaceDark,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      success: success ?? this.success,
      successBg: successBg ?? this.successBg,
      info: info ?? this.info,
      infoBg: infoBg ?? this.infoBg,
      warning: warning ?? this.warning,
      warningBg: warningBg ?? this.warningBg,
      errorBg: errorBg ?? this.errorBg,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      star: star ?? this.star,
      favorite: favorite ?? this.favorite,
      purple: purple ?? this.purple,
      difficultyEasy: difficultyEasy ?? this.difficultyEasy,
      difficultyMedium: difficultyMedium ?? this.difficultyMedium,
      difficultyHard: difficultyHard ?? this.difficultyHard,
      confettiGreen: confettiGreen ?? this.confettiGreen,
      confettiGold: confettiGold ?? this.confettiGold,
    );
  }

  @override
  AppColorsExtension lerp(covariant AppColorsExtension? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      textLight: Color.lerp(textLight, other.textLight, t)!,
      surfaceDark: Color.lerp(surfaceDark, other.surfaceDark, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      success: Color.lerp(success, other.success, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoBg: Color.lerp(infoBg, other.infoBg, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      star: Color.lerp(star, other.star, t)!,
      favorite: Color.lerp(favorite, other.favorite, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      difficultyEasy: Color.lerp(difficultyEasy, other.difficultyEasy, t)!,
      difficultyMedium: Color.lerp(difficultyMedium, other.difficultyMedium, t)!,
      difficultyHard: Color.lerp(difficultyHard, other.difficultyHard, t)!,
      confettiGreen: Color.lerp(confettiGreen, other.confettiGreen, t)!,
      confettiGold: Color.lerp(confettiGold, other.confettiGold, t)!,
    );
  }
}
