import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

/// Shared PIN input theme used across verification screens.
class PinThemeHelper {
  PinThemeHelper._();

  static PinTheme defaultTheme(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return PinTheme(
      width: 52,
      height: 56,
      textStyle: text.titleLarge?.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 20,
        color: scheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outline.withOpacity(1)),
      ),
    );
  }

  static PinTheme focusedTheme(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return PinTheme(
      width: 52,
      height: 56,
      textStyle: text.titleLarge?.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 20,
        color: scheme.primary,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.primary, width: 2),
      ),
    );
  }

  static Widget cursor(BuildContext context, {double height = 22}) {
    return Container(
      width: 2,
      height: height,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
