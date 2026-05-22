import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.xxxxxl + AppSpacing.s,
                height: AppSpacing.xxxxxl + AppSpacing.s,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [context.colors.primary, context.colors.primaryContainer],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: Icon(
                  SolarIconsOutline.user,
                  size: AppIconSize.xxl,
                  color: context.colors.onPrimary,
                  semanticLabel: 'Profile',
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      email,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (!phoneVerified) ...[
            const SizedBox(height: AppSpacing.m),
            Semantics(
              button: true,
              label: 'Verify phone number',
              child: InkWell(
              onTap: () => context.push('/settings/permissions'),
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.ms,
                ),
                decoration: BoxDecoration(
                  color: context.ext.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(
                    color: context.ext.warning.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      SolarIconsOutline.smartphone,
                      size: AppIconSize.ml,
                      color: context.ext.warning,
                      semanticLabel: 'Phone not verified',
                    ),
                    const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: Text(
                        tr("phone_not_verified"),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: context.ext.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      SolarIconsOutline.arrowRight,
                      size: AppIconSize.m,
                      color: context.ext.warning.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
            ),
            ),
          ],
        ],
      ),
    );
  }
}
