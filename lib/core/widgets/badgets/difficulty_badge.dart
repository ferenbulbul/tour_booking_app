import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';

class DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const DifficultyBadge(this.difficulty, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color baseBg;
    switch (difficulty.toLowerCase()) {
      case "kolay":
        baseBg = const Color(0xFF4CAF50);
        break;
      case "orta":
        baseBg = const Color(0xFFFF9800);
        break;
      case "zor":
        baseBg = const Color(0xFFE53935);
        break;
      default:
        baseBg = Colors.grey.shade600;
    }

    final bg = isDark ? baseBg.withOpacity(.22) : baseBg.withOpacity(.14);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: baseBg.withOpacity(isDark ? .35 : .28)),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}
