import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class PickerField extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;
  final bool glass;

  const PickerField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.glass = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final isEmpty = value == null || value!.isEmpty;

    // HYBRID MODE → Blur YOK, sadece yarı transparan arka plan
    final bgColor = glass
        ? (isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.white.withOpacity(0.12))
        : scheme.surface;

    final borderColor = glass
        ? Colors.white.withOpacity(0.18)
        : scheme.outlineVariant.withOpacity(0.30);

    final shadowColor = Colors.black.withOpacity(glass ? 0.04 : 0.08);

    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: glass ? 1 : 0.9),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 3, // hafif shadow → performans dostu
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textPrimary.withOpacity(0.8), size: 20),
          const SizedBox(width: 12),

          // TEXT
          Expanded(
            child: Text(
              value ?? label,
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 15,
                fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
                color: isEmpty
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
            ),
          ),

          const SizedBox(width: 6),

          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15,
            color: AppColors.textSecondary.withOpacity(0.8),
          ),
        ],
      ),
    );

    // glass: true olsa da widget yapısı aynı, sadece style değişiyor
    return GestureDetector(onTap: onTap, child: content);
  }
}
