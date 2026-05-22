import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

const durationFilters = {
  '1_az': '1 saatten az',
  '1_4': '1-4 saat',
  '4_8': '4-8 saat',
  '8_plus': '8+ saat',
};

const ratingFilters = {
  '4_plus': '4+ Puan',
  '3_plus': '3+ Puan',
  '2_plus': '2+ Puan',
  '1_plus': '1+ Puan',
};

/// Generic filter item with [avgRating], [durationHours], [durationMinutes], [tourTypeName].
/// Extend or implement this in your DTO adapters if needed.
typedef FilterExtractor<T> = ({
  double? avgRating,
  int? ratingCount,
  int? durationHours,
  int? durationMinutes,
  String tourTypeName,
});

bool matchesDurationFilter(String? filter, int? durationHours, int? durationMinutes) {
  if (filter == null) return true;
  final totalMinutes = (durationHours ?? 0) * 60 + (durationMinutes ?? 0);
  switch (filter) {
    case '1_az':
      return totalMinutes > 0 && totalMinutes < 60;
    case '1_4':
      return totalMinutes >= 60 && totalMinutes < 240;
    case '4_8':
      return totalMinutes >= 240 && totalMinutes < 480;
    case '8_plus':
      return totalMinutes >= 480;
    default:
      return true;
  }
}

bool matchesRatingFilter(String? filter, double? avgRating) {
  if (filter == null) return true;
  final rating = avgRating ?? 0;
  switch (filter) {
    case '4_plus':
      return rating >= 4;
    case '3_plus':
      return rating >= 3;
    case '2_plus':
      return rating >= 2;
    case '1_plus':
      return rating >= 1;
    default:
      return true;
  }
}

void showFilterModal({
  required BuildContext context,
  required String title,
  required Map<String, String> options,
  required String? selected,
  required ValueChanged<String?> onSelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.l, AppSpacing.xl, AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: AppSpacing.xxxxl,
                  height: AppSpacing.xs,
                  decoration: BoxDecoration(
                    color: context.colors.outline,
                    borderRadius: BorderRadius.circular(AppSpacing.xxs),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              FilterOption(
                label: "Tümü",
                isSelected: selected == null,
                onTap: () {
                  onSelected(null);
                  Navigator.pop(ctx);
                },
              ),
              ...options.entries.map((e) => FilterOption(
                    label: e.value,
                    isSelected: selected == e.key,
                    onTap: () {
                      onSelected(e.key);
                      Navigator.pop(ctx);
                    },
                  )),
            ],
          ),
        ),
      );
    },
  );
}

class FilterChipButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const FilterChipButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Filter by $label',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
          decoration: BoxDecoration(
            color: isActive ? context.colors.secondary : context.colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: isActive ? null : Border.all(color: context.colors.outline, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isActive ? context.colors.onSecondary : context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: AppIconSize.m,
                color: isActive ? context.colors.onSecondary : context.colors.onSurfaceVariant,
                semanticLabel: 'Expand filter',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Filter option $label',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.m, horizontal: AppSpacing.xs),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected ? context.colors.secondary : context.colors.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_rounded, size: AppIconSize.l, color: context.colors.secondary, semanticLabel: 'Selected'),
            ],
          ),
        ),
      ),
    );
  }
}
