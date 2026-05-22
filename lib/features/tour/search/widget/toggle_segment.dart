import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

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
        _tab(context, tr("departure_point"), SolarIconsOutline.route, 0),
        const SizedBox(width: AppSpacing.s),
        _tab(context, tr("tour_point"), SolarIconsOutline.mapPoint, 1),
      ],
    );
  }

  Widget _tab(BuildContext context, String text, IconData icon, int value) {
    final selected = index == value;

    return Expanded(
      child: Semantics(
        button: true,
        label: text,
        child: GestureDetector(
          onTap: () => onChanged(value),
          child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.ms),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: AppIconSize.ml,
                    color: selected ? context.colors.secondary : context.ext.textLight,
                    semanticLabel: text,
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Text(
                    text,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: selected ? context.colors.secondary : context.ext.textLight,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2.5,
              decoration: BoxDecoration(
                color: selected ? context.colors.secondary : context.colors.outline,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
