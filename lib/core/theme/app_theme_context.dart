import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors_extension.dart';

/// Convenience getters on [BuildContext] for theme access.
///
/// Usage:
/// ```dart
/// final colors = context.colors;       // ColorScheme
/// final ext = context.ext;             // AppColorsExtension
/// final textStyles = context.textStyles; // TextTheme
/// ```
extension AppThemeContext on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  AppColorsExtension get ext => Theme.of(this).extension<AppColorsExtension>()!;
  TextTheme get textStyles => Theme.of(this).textTheme;
}
