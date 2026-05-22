import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class AppBarStyles {
  // Title text style
  static TextStyle title(BuildContext context) {
    final text = context.textStyles;
    final scheme = context.colors;

    return text.titleMedium!.copyWith(
      fontWeight: FontWeight.w600,
      color: scheme.onSurface,
    );
  }

  // Background color
  static Color background(BuildContext context) {
    return context.colors.surface;
  }

  // Icon color
  static Color icon(BuildContext context) {
    return context.colors.onSurface;
  }
}
