import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final bool phoneVerified;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.phoneVerified,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // --- AVATAR ---
        CircleAvatar(
          radius: 45,
          backgroundColor: scheme.primary.withOpacity(0.12),
          child: Icon(Icons.person_rounded, size: 52, color: scheme.primary),
        ),

        const SizedBox(height: AppSpacing.m),

        // --- NAME ---
        Text(
          name,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 6),

        // --- EMAIL ---
        Text(
          email,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 8),

        // --- PHONE BADGE (opsiyonel premium dokunuş) ---
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: (phoneVerified ? AppColors.success : AppColors.warning)
                .withOpacity(.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            phoneVerified ? "Telefon Doğrulandı" : "Telefon Doğrulanmadı",
            style: AppTextStyles.labelSmall.copyWith(
              color: phoneVerified ? AppColors.success : AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
