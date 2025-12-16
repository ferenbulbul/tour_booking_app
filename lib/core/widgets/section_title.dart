import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

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
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title + See All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Title + accent bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                ),

                const SizedBox(height: 2),

                /// Soft gradient accent line
                Container(
                  width: 38,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: [
                        scheme.primary.withOpacity(0.9),
                        scheme.primary.withOpacity(0.1),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ],
            ),

            /// SEE ALL (optional)
            if (onMore != null)
              GestureDetector(
                onTap: onMore,
                child: Text(
                  "See All",
                  style: text.labelLarge?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),

        /// Subtitle (optional)
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: text.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant.withOpacity(0.9),
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }
}
