import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/profile/screen/profile_screen.dart';
import 'package:tour_booking/features/profile/widget/profile_section.dart';
import 'package:tour_booking/features/auth/login/widget/login_bottom_sheet.dart';
import 'package:tour_booking/features/profile/widget/profile_menu_tile.dart';

class GuestProfileView extends StatelessWidget {
  const GuestProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            const SizedBox(height: AppSpacing.l),

            InkWell(
              onTap: () async {
                final result = await showLoginBottomSheet(context);
                if (result == true && context.mounted) {
                  context.go('/home');
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        SolarIconsOutline.user,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Text(
                      tr("login"),
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      SolarIconsOutline.arrowRight,
                      size: 20,
                      color: AppColors.textLight.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            ProfileSection(
              title: tr("settings"),
              children: [
                ProfileTile(
                  icon: SolarIconsOutline.globus,
                  title: tr("language"),
                  trailingText: getLanguageName(context),
                  onTap: () => context.push("/settings/language"),
                ),
                ProfileTile(
                  icon: SolarIconsOutline.settingsMinimalistic,
                  title: tr("permissions"),
                  onTap: () => context.push("/settings/permissions"),
                  showDivider: false,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),

            ProfileSection(
              title: tr("legal_info"),
              children: [
                ProfileTile(
                  icon: SolarIconsOutline.shieldCheck,
                  title: tr("privacy_policy"),
                  onTap: () => context.push('/legal/privacy-policy'),
                ),
                ProfileTile(
                  icon: SolarIconsOutline.documentText,
                  title: tr("kvkk_text"),
                  onTap: () => context.push('/legal/kvkk'),
                ),
                ProfileTile(
                  icon: SolarIconsOutline.billList,
                  title: tr("sales_agreement"),
                  onTap: () => context.push('/legal/sales-agreement'),
                  showDivider: false,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
