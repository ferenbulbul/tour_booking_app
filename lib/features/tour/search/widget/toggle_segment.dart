import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class PremiumToggle extends StatelessWidget {
  final int index;
  final Function(int) onChanged;

  const PremiumToggle({
    super.key,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _tab(tr("departure_point"), SolarIconsOutline.route, 0),
        const SizedBox(width: 8),
        _tab(tr("tour_point"), SolarIconsOutline.mapPoint, 1),
      ],
    );
  }

  Widget _tab(String text, IconData icon, int value) {
    final selected = index == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: selected ? AppColors.accent : AppColors.textLight,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: selected ? AppColors.accent : AppColors.textLight,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2.5,
              decoration: BoxDecoration(
                color: selected ? AppColors.accent : AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
