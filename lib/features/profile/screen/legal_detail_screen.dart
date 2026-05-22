import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_elevation.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class LegalDetailScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalDetailScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: CommonAppBar(title: title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.25),
            ),
            boxShadow: AppElevation.shadowSm,
          ),
          child: SelectableText(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.6,
              color: scheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
