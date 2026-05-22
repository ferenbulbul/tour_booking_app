import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.s),
          child: Text(
            title.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: context.ext.textLight,
              letterSpacing: 0.8,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
