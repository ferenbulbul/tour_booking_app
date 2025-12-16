import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class ProfileSection extends StatelessWidget {
  final String title;

  const ProfileSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s, left: AppSpacing.xs),
      child: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface.withOpacity(.65),
        ),
      ),
    );
  }
}
