import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onMore;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title + See All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Title
            Flexible(
              child: Text(
                title,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
            ),

            /// SEE ALL (optional)
            if (onMore != null)
              Semantics(
                button: true,
                label: 'See all',
                child: GestureDetector(
                  onTap: onMore,
                  child: Text(
                    tr("see_all"),
                    style: text.labelLarge?.copyWith(
                      color: context.colors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),

        /// Subtitle (optional)
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.s),
          Text(
            subtitle!,
            style: text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }
}
