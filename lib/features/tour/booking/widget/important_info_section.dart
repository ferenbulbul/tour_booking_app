import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/models/tour_detail_sub_items/tour_detail_sub_items.dart';

class ImportantInfoSection extends StatelessWidget {
  final List<ImportantInfoItem> items;
  final bool showTitle;

  const ImportantInfoSection({
    super.key,
    required this.items,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
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
  }
}
