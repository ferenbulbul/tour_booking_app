import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/auth/login/google_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/features/profile/widget/profile_section.dart';
import 'package:tour_booking/features/profile/widget/profile_skeleton.dart';
import 'package:tour_booking/features/profile/widget/guest_profile_view.dart';
import 'package:tour_booking/features/profile/screen/language_screen.dart';
import 'package:tour_booking/features/profile/theme_viewmodel.dart';
import 'package:tour_booking/features/profile/widget/notification_preferences_sheet.dart';
import 'package:tour_booking/features/profile/widget/profile_menu_tile.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final splash = context.read<SplashViewModel>();
      if (!splash.isGuest) {
        context.read<ProfileViewModel>().fetchProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final splash = context.watch<SplashViewModel>();

    if (splash.isGuest) {
      return const GuestProfileView();
    }

    final vm = context.watch<ProfileViewModel>();
    final authVm = context.watch<AuthViewModel>();

    // Trigger profile fetch after login (profile was never loaded as guest)
    if (vm.profile == null && !vm.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.read<ProfileViewModel>().fetchProfile();
      });
    }

    if (vm.profile == null) {
      return const ProfileSkeleton();
    }

    final p = vm.profile!;

    const expandedHeight = 90.0;
    const collapsedHeight = 66.0;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: expandedHeight,
            collapsedHeight: collapsedHeight,
            automaticallyImplyLeading: false,
            backgroundColor: scheme.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final top = constraints.biggest.height;
                final statusBar = MediaQuery.of(context).padding.top;
                final maxExtent = expandedHeight + statusBar;
                final minExtent = collapsedHeight + statusBar;
                final t = ((top - minExtent) / (maxExtent - minExtent))
                    .clamp(0.0, 1.0);

                final avatarSize = 32.0 + (24.0 * t); // 32 → 56
                final avatarRadius = 10.0 + (6.0 * t); // 10 → 16
                final iconSize = 18.0 + (8.0 * t); // 18 → 26
                final nameSize = 14.0 + (4.0 * t); // 14 → 18
                final emailOpacity = t;

                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    statusBar + 8,
                    AppSpacing.screenPadding,
                    6,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
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
                            semanticLabel: 'Profile',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.m),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.fullName,
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: nameSize,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (emailOpacity > 0.05) ...[
                                const SizedBox(height: AppSpacing.xxs),
                                Opacity(
                                  opacity: emailOpacity,
                                  child: Text(
                                    p.email,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: context.colors.onSurfaceVariant,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // CONTENT
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSpacing.xl),

                ProfileSection(
                  title: tr("account"),
                  children: [
                    ProfileTile(
                      icon: SolarIconsOutline.userCircle,
                      title: tr("personal_info"),
                      subtitle: p.fullName,
                      onTap: () => context.push('/personal-info'),
                      showDivider: false,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xxl),

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
                      icon: SolarIconsOutline.lock,
                      title: tr("change_password"),
                      onTap: () => context.push('/change-password'),
                    ),
                    ProfileTile(
                      icon: SolarIconsOutline.notificationUnread,
                      title: tr("notifications"),
                      onTap: () => showNotificationPreferencesSheet(context),
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

                ProfileSection(
                  title: tr("other"),
                  children: [
                    ProfileTile(
                      icon: SolarIconsOutline.logout,
                      title: tr("logout"),
                      titleColor: context.colors.error,
                      iconColor: context.colors.error,
                      showDivider: false,
                      onTap: () async {
                        final splashVm = context.read<SplashViewModel>();
                        final profileVm = context.read<ProfileViewModel>();
                        profileVm.clear();
                        await splashVm.performFullSignOut(
                          socialCleanup: () => authVm.socialSignOut(),
                        );
                        if (context.mounted) context.go('/home');
                      },
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
}

String getLanguageName(BuildContext context) {
  return tr('language_name');
}

class AppearanceTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeVM = context.watch<ThemeViewModel>();
    final scheme = context.colors;

    String label;
    switch (themeVM.themeMode) {
      case ThemeMode.system:
        label = tr('theme_system');
      case ThemeMode.light:
        label = tr('theme_light');
      case ThemeMode.dark:
        label = tr('theme_dark');
    }

    return ProfileTile(
      icon: SolarIconsOutline.sun,
      title: tr('appearance'),
      trailingText: label,
      showDivider: false,
      onTap: () => _showThemePicker(context, themeVM, scheme),
    );
  }

  void _showThemePicker(
    BuildContext context,
    ThemeViewModel themeVM,
    ColorScheme scheme,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.l),
        ),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.l,
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                tr('appearance'),
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              _themeOption(context, themeVM, ThemeMode.system,
                  SolarIconsOutline.smartphone, tr('theme_system')),
              _themeOption(context, themeVM, ThemeMode.light,
                  SolarIconsOutline.sun, tr('theme_light')),
              _themeOption(context, themeVM, ThemeMode.dark,
                  SolarIconsOutline.moon, tr('theme_dark')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _themeOption(
    BuildContext context,
    ThemeViewModel themeVM,
    ThemeMode mode,
    IconData icon,
    String label,
  ) {
    final isSelected = themeVM.themeMode == mode;
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(icon,
          color: isSelected ? scheme.primary : scheme.onSurfaceVariant),
      title: Text(
        label,
        style: AppTextStyles.labelLarge.copyWith(
          color: isSelected ? scheme.primary : scheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: isSelected
          ? Icon(SolarIconsOutline.checkCircle,
              color: scheme.primary, size: 22)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.s),
      ),
      onTap: () {
        themeVM.setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }
}
