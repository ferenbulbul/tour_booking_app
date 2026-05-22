import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/models/tour_detail_sub_items/tour_detail_sub_items.dart';

class HighlightsSection extends StatelessWidget {
  final List<HighlightItem> highlights;
  final bool showTitle;
  final bool showCard;

  const HighlightsSection({
    super.key,
    required this.highlights,
    this.showTitle = true,
    this.showCard = true,
  });

  @override
  Widget build(BuildContext context) {
    if (highlights.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: highlights
          .map((h) => Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Container(
                        width: AppSpacing.xsm,
                        height: AppSpacing.xsm,
                        decoration: BoxDecoration(
                          color: context.colors.onSurfaceVariant,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Text(
                        h.text,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: context.colors.onSurface,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
