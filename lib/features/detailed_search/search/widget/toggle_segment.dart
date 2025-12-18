import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(.06)
            : Colors.black.withOpacity(.04),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(.12)
              : Colors.black.withOpacity(.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _item(tr("departure_point"), Icons.my_location, 0, isDark),
          _item(tr("tour_point"), Icons.location_on_outlined, 1, isDark),
        ],
      ),
    );
  }

  Widget _item(String text, IconData icon, int value, bool isDark) {
    final selected = index == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.black54),
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : (isDark ? Colors.white70 : Colors.black54),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
