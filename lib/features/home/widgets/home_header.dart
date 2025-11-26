import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Row(
        children: [
          /// LEFT SIDE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello,  👋",
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "TourRent",
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT SIDE: Avatar (LIGHT THEME DOĞRU HALİ)
          // CircleAvatar(
          //   radius: 22,
          //   backgroundColor: Colors.grey.shade200, // açık gri zemin
          //   child: Icon(
          //     Icons.notifications,
          //     color: AppColors.textPrimary, // koyu gri ikon
          //     size: 24,
          //   ),
          // ),
        ],
      ),
    );
  }
}
