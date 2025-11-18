import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';

class ModernField extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;

  const ModernField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool empty = value == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.l,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(color: Colors.black12.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.textPrimary.withOpacity(.8)),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Text(
                empty ? label : value!,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: empty ? FontWeight.w400 : FontWeight.w600,
                  color: empty ? AppColors.textLight : AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
