import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TOP ROW — Title + See All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Title + gradient bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: theme.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 6),

                // Gradient Accent Bar
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(.9),
                        theme.colorScheme.primary.withOpacity(.0),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ],
            ),

            /// SEE ALL BUTTON
            if (onMore != null)
              GestureDetector(
                onTap: onMore,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    "See All",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),

        /// SUBTITLE (optional)
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.outline,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }
}
