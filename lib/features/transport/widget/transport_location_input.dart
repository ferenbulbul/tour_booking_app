import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class TransportLocationInput extends StatelessWidget {
  final String label;
  final String? address;
  final Color dotColor;
  final VoidCallback onTap;

  const TransportLocationInput({
    super.key,
    required this.label,
    this.address,
    required this.dotColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasAddress = address != null && address!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasAddress
                ? dotColor.withOpacity(0.4)
                : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hasAddress ? address! : label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 15,
                  fontWeight: hasAddress ? FontWeight.w600 : FontWeight.w400,
                  color: hasAddress
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.my_location_rounded,
              size: 18,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}
