import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

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
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
          ],
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? AppColors.accent : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, size: 20, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}
