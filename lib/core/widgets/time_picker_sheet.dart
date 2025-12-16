import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';

class TimePickerSheet extends StatelessWidget {
  final List<String> times;
  final String initial;
  final Function(String) onSelected;

  const TimePickerSheet({
    super.key,
    required this.times,
    required this.initial,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        ),
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            /// Handle Bar
            Container(
              width: 42,
              height: 5,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(.22)
                    : Colors.black.withOpacity(.18),
                borderRadius: BorderRadius.circular(40),
              ),
            ),

            /// Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.l,
                vertical: 6,
              ),
              child: Text(
                "Saat Seçin",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: 8),
            Divider(
              height: 1,
              color: isDark
                  ? Colors.white.withOpacity(.08)
                  : Colors.black.withOpacity(.06),
            ),

            /// LIST
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.l,
                  vertical: 10,
                ),
                itemCount: times.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.s),
                itemBuilder: (context, index) {
                  final time = times[index];
                  final isSelected = time == initial;

                  return InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    onTap: () {
                      onSelected(time);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        color: isSelected
                            ? AppColors.primary.withOpacity(.10)
                            : (isDark
                                  ? Colors.white.withOpacity(.04)
                                  : Colors.grey.shade100),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 1.3,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isSelected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          if (isSelected) const SizedBox(width: 10),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
