import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  // ── Brand ──────────────────────────────────────────────
  static const primary = Color(0xFF182B40); // Tourlio Navy
  static const primaryDark = Color(0xFF0F1D2B);
  static const primaryLight = Color(0xFF2D4A66);

  // ── Accent ─────────────────────────────────────────────
  static const accent = Color(0xFFEC5807); // Tourlio Orange
  static const accentDark = Color(0xFFD44E06);
  static const accentLight = Color(0xFFFFA05C);

  // ── Background / Surface ──────────────────────────────
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceLight = Color(0xFFF9FAFB);
  static const surfaceDark = Color(0xFFF1F3F7);
  static const border = Color(0xFFE2E6EB);

  // ── Neutral ───────────────────────────────────────────
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  // ── Text ───────────────────────────────────────────────
  static const textPrimary = Color(0xFF182B40);
  static const textSecondary = Color(0xFF5A6B7D);
  static const textLight = Color(0xFF94A3B8);
  static const textOnDark = Color(0xFFFFFFFF);
  static const textOnAccent = Color(0xFFFFFFFF);

  // ── State ──────────────────────────────────────────────
  static const error = Color(0xFFEF4444);
  static const errorBg = Color(0xFFFEF2F2);
  static const success = Color(0xFF22C55E);
  static const successBg = Color(0xFFF0FDF4);
  static const info = Color(0xFF3B82F6);
  static const infoBg = Color(0xFFEFF6FF);
  static const warning = Color(0xFFF59E0B);
  static const warningBg = Color(0xFFFFFBEB);

  // ── Shimmer ───────────────────────────────────────────
  static const shimmerBase = Color(0xFFE0E0E0);
  static const shimmerHighlight = Color(0xFFF5F5F5);

  // ── Transparent ──────────────────────────────────────
  static const transparent = Color(0x00000000);

  // ── Difficulty colors ───────────────────────────────
  static const difficultyEasy = Color(0xFF4CAF50);
  static const difficultyMedium = Color(0xFFFF9800);
  static const difficultyHard = Color(0xFFE53935);

  // ── Misc semantic ──────────────────────────────────
  static const favorite = Color(0xFFEF4444);
  static const star = Color(0xFFFFC107);
  static const purple = Color(0xFF8B5CF6);

  // ── Confetti ─────────────────────────────────────────
  static const confettiGreen = Color(0xFFA5D6A7);
  static const confettiGold = Color(0xFFFFD54F);

  // ── Overlay / Opacity helpers ─────────────────────────
  static Color overlay({double opacity = 0.05}) =>
      black.withValues(alpha: opacity);
  static Color lightOverlay({double opacity = 0.1}) =>
      white.withValues(alpha: opacity);
}
