import 'package:flutter/material.dart';

class AppBarStyles {
  // Title text style
  static TextStyle title(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return text.titleMedium!.copyWith(
      fontWeight: FontWeight.w600,
      color: scheme.onSurface,
    );
  }

  // Background color
  static Color background(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  // Icon color
  static Color icon(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }
}
