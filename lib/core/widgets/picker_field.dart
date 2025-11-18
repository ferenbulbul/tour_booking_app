import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';

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
    final isEmpty = value == null || value!.isEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: glass ? Colors.white.withOpacity(0.18) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: glass ? Colors.white.withOpacity(.35) : Colors.grey.shade300,
          ),
          boxShadow: glass
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value ?? label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
                  color: isEmpty
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(
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
