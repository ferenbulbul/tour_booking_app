import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/profile/screen/language_screen.dart';
import 'package:tour_booking/features/profile/screen/profile_screen.dart';
import 'package:tour_booking/features/profile/widget/profile_section.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/auth/login/widget/login_bottom_sheet.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/features/profile/widget/notification_preferences_sheet.dart';
import 'package:tour_booking/features/profile/widget/profile_menu_tile.dart';
import 'package:tour_booking/navigation/app_router.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class GuestProfileView extends StatelessWidget {
  const GuestProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar — "Login" button (similar to name area in logged-in profile)
          SliverAppBar(
            pinned: true,
            expandedHeight: 90,
            collapsedHeight: 66,
            automaticallyImplyLeading: false,
            backgroundColor: scheme.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final top = constraints.biggest.height;
                final statusBar = MediaQuery.of(context).padding.top;
                final maxExtent = 90.0 + statusBar;
                final minExtent = 66.0 + statusBar;
                final t = ((top - minExtent) / (maxExtent - minExtent))
                    .clamp(0.0, 1.0);

                final avatarSize = 32.0 + (16.0 * t); // 32 → 48
                final avatarRadius = 10.0 + (4.0 * t); // 10 → 14
                final iconSize = 18.0 + (6.0 * t); // 18 → 24

                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    statusBar + 8,
                    AppSpacing.screenPadding,
                    6,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Semantics(
                      button: true,
                      label: tr("login"),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _handleLogin(context),
                        child: Row(
                          children: [
                            Container(
                              width: avatarSize,
                              height: avatarSize,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    context.colors.primary,
                                    context.colors.primaryContainer,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius:
                                    BorderRadius.circular(avatarRadius),
                              ),
                              child: Icon(
                                SolarIconsOutline.user,
                                size: iconSize,
                                color: context.colors.onPrimary,
                                semanticLabel: 'Guest user',
                              ),
                            ),
                            const SizedBox(width: AppSpacing.m),
                            Text(
                              tr("login"),
                              style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: context.colors.secondary,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              SolarIconsOutline.arrowRight,
                              size: AppIconSize.l,
                              color:
                                  context.ext.textLight.withValues(alpha: 0.6),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSpacing.xl),

                ProfileSection(
                  title: tr("settings"),
                  children: [
                    ProfileTile(
                      icon: SolarIconsOutline.globus,
                      title: tr("language"),
                      trailingText: getLanguageName(context),
                      onTap: () => showLanguageSheet(context),
                    ),
                    ProfileTile(
                      icon: SolarIconsOutline.notificationUnread,
                      title: tr("notifications"),
                      onTap: () =>
                          showNotificationPreferencesSheet(context),
                    ),
                    AppearanceTile(),
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
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin(BuildContext context) async {
    // Bottom sheet handles navigation (home/driver) after successful login
    await showLoginBottomSheet(context);
  }
}
