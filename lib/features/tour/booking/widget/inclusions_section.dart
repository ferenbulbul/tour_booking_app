import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/models/tour_detail_sub_items/tour_detail_sub_items.dart';

class InclusionsSection extends StatelessWidget {
  final List<InclusionItem> inclusions;
  final bool showCard;

  const InclusionsSection({
    super.key,
    required this.inclusions,
    this.showCard = true,
  });

  @override
  Widget build(BuildContext context) {
    if (inclusions.isEmpty) return const SizedBox.shrink();

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: inclusions
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xxs),
                      child: Icon(
                        item.isIncluded ? Icons.check : Icons.close,
                        size: AppIconSize.m,
                        color: item.isIncluded
                            ? context.ext.success
                            : context.colors.error,
                        semanticLabel: item.isIncluded ? 'Included' : 'Not included',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: Text(
                        item.text,
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

    if (!showCard) return content;

    return content;
  }
}
