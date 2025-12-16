import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_radius.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final items = [
      {'icon': Icons.verified_outlined, 'text': 'Fully Insured & Licensed'},
      {'icon': Icons.person_outline, 'text': 'Professional Local Guides'},
      {'icon': Icons.support_agent_outlined, 'text': '24/7 Customer Support'},
      {'icon': Icons.price_check_outlined, 'text': 'Best Price Guarantee'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.s),

        /// FEATURE LIST
        Column(
          children: items.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.m),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
              child: Row(
                children: [
                  // ICON WRAPPER — theme-aware gradient
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          scheme.primary.withOpacity(0.18),
                          scheme.primary.withOpacity(0.06),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: scheme.primary,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: AppSpacing.m),

                  // TEXT
                  Expanded(
                    child: Text(
                      item['text'] as String,
                      style: textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withOpacity(.85),
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: AppSpacing.l),

        /// FOOTER
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
          decoration: BoxDecoration(
            color: scheme.surfaceVariant.withOpacity(.4),
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Text(
            '© 2025 TourBooking. All rights reserved.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withOpacity(.6),
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}
