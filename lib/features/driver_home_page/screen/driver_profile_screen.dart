import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_elevation.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/features/auth/login/google_viewmodel.dart';
import 'package:tour_booking/features/driver_home_page/driver_profile_viewmodel.dart';
import 'package:tour_booking/features/profile/screen/language_screen.dart';
import 'package:tour_booking/features/profile/screen/profile_screen.dart';
import 'package:tour_booking/features/profile/widget/profile_menu_tile.dart';
import 'package:tour_booking/features/profile/widget/profile_section.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/models/driver_profile/driver_profile.dart';
import 'package:tour_booking/models/driver_vehicle/driver_vehicle.dart';
import 'package:tour_booking/services/driver/driver_service.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          DriverProfileViewModel(context.read<DriverService>())..fetchProfile(),
      child: const _DriverProfileContent(),
    );
  }
}

class _DriverProfileContent extends StatelessWidget {
  const _DriverProfileContent();

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final vm = context.watch<DriverProfileViewModel>();

    if (vm.isLoading && vm.profile == null) {
      return Scaffold(
        backgroundColor: scheme.surface,
        appBar: AppBar(
          backgroundColor: scheme.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        body: const _ProfileSkeleton(),
      );
    }

    if (vm.error != null && vm.profile == null) {
      return Scaffold(
        backgroundColor: scheme.surface,
        appBar: AppBar(
          backgroundColor: scheme.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Text(
              vm.error!,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: scheme.error,
              ),
            ),
          ),
        ),
      );
    }

    final profile = vm.profile;
    if (profile == null) {
      return Scaffold(
        backgroundColor: scheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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

                final avatarSize = 32.0 + (24.0 * t);
                final avatarRadius = 10.0 + (6.0 * t);
                final iconSize = 18.0 + (8.0 * t);
                final nameSize = 14.0 + (4.0 * t);
                final emailOpacity = t;

                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding + 48,
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
                            borderRadius: BorderRadius.circular(avatarRadius),
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
                                profile.fullName,
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
                                    profile.email,
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

                // Stats row
                _StatsRow(profile: profile),

                const SizedBox(height: AppSpacing.xxl),

                // Vehicle info
                _VehicleSection(vehicle: profile.vehicle),

                const SizedBox(height: AppSpacing.xxl),

                // Settings
                ProfileSection(
                  title: tr('settings'),
                  children: [
                    ProfileTile(
                      icon: SolarIconsOutline.globus,
                      title: tr('language'),
                      trailingText: getLanguageName(context),
                      onTap: () => showLanguageSheet(context),
                    ),
                    ProfileTile(
                      icon: SolarIconsOutline.lock,
                      title: tr('change_password'),
                      onTap: () => context.push('/change-password-driver'),
                    ),
                    AppearanceTile(),
                  ],
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Other
                ProfileSection(
                  title: tr('other'),
                  children: [
                    ProfileTile(
                      icon: SolarIconsOutline.logout,
                      title: tr('logout'),
                      titleColor: context.colors.error,
                      iconColor: context.colors.error,
                      showDivider: false,
                      onTap: () async {
                        final splashVm = context.read<SplashViewModel>();
                        final authVm = context.read<AuthViewModel>();
                        await splashVm.performFullSignOut(
                          socialCleanup: () => authVm.socialSignOut(),
                        );
                        if (context.mounted) context.go('/');
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

// ─────────────────────────────────────────────────────────────
// VEHICLE SECTION
// ─────────────────────────────────────────────────────────────
class _VehicleSection extends StatelessWidget {
  const _VehicleSection({required this.vehicle});
  final DriverVehicle? vehicle;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    if (vehicle == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: AppElevation.shadowSm,
          border: Border.all(
            color: scheme.outline.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Icon(
                SolarIconsOutline.bus,
                size: AppIconSize.xl,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              tr('driver_no_vehicle_assigned'),
              style: AppTextStyles.bodyMedium.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    final v = vehicle!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: AppElevation.shadowSm,
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.medium),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: Icon(
                    SolarIconsOutline.bus,
                    size: AppIconSize.l,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.ms),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${v.brand} ${v.model}',
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                      ),
                      if (v.plate.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xxxs),
                        Text(
                          v.plate,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: scheme.onSurfaceVariant,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Details grid
          Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _VehicleInfoItem(
                        icon: SolarIconsOutline.usersGroupRounded,
                        label: tr('driver_vehicle_seats'),
                        value: v.seatCount.toString(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: _VehicleInfoItem(
                        icon: SolarIconsOutline.calendar,
                        label: tr('driver_vehicle_year'),
                        value: v.year > 0 ? v.year.toString() : '-',
                      ),
                    ),
                  ],
                ),
                if (v.vehicleType.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.m),
                  Row(
                    children: [
                      Expanded(
                        child: _VehicleInfoItem(
                          icon: SolarIconsOutline.tag,
                          label: tr('driver_vehicle_type'),
                          value: v.vehicleType,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleInfoItem extends StatelessWidget {
  const _VehicleInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.ms),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppIconSize.m,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxs),
                Text(
                  value,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STATS ROW
// ─────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.profile});
  final DriverProfile profile;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.star_rounded,
            iconColor: context.ext.star,
            label: tr('driver_avg_rating'),
            value: profile.averageRating > 0
                ? profile.averageRating.toStringAsFixed(1)
                : '-',
          ),
        ),
        const SizedBox(width: AppSpacing.ms),
        Expanded(
          child: _StatCard(
            icon: SolarIconsOutline.routing,
            iconColor: scheme.primary,
            label: tr('driver_total_trips'),
            value: profile.totalTrips.toString(),
          ),
        ),
        const SizedBox(width: AppSpacing.ms),
        Expanded(
          child: _StatCard(
            icon: SolarIconsOutline.chatRoundLike,
            iconColor: context.ext.success,
            label: tr('driver_total_ratings'),
            value: profile.totalRatings.toString(),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.ms,
        vertical: AppSpacing.ml,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: AppElevation.shadowSm,
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: AppIconSize.l, color: iconColor),
          const SizedBox(height: AppSpacing.s),
          Text(
            value,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SKELETON
// ─────────────────────────────────────────────────────────────
class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.ext.shimmerBase,
      highlightColor: context.ext.shimmerHighlight,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          children: [
            // Header skeleton
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 18,
                        width: 160,
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: 120,
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            // Stats row skeleton
            Row(
              children: List.generate(
                3,
                (_) => Expanded(
                  child: Container(
                    height: 90,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            // Section skeleton
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
