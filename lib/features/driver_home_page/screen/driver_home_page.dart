import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/features/driver_home_page/driver_viewmodel.dart';
import 'package:tour_booking/features/driver_home_page/driver_past_orders_viewmodel.dart';
import 'package:tour_booking/features/driver_home_page/driver_profile_viewmodel.dart';
import 'package:tour_booking/features/driver_home_page/widget/driver_dashboard_tab.dart';
import 'package:tour_booking/features/driver_home_page/widget/driver_past_orders_tab.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/services/driver/driver_service.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final driverService = context.read<DriverService>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DriverHomeViewModel(driverService),
        ),
        ChangeNotifierProvider(
          create: (_) => DriverPastOrdersViewModel(driverService),
        ),
        ChangeNotifierProvider(
          create: (_) => DriverProfileViewModel(driverService),
        ),
      ],
      child: const _DriverHomeScreenContent(),
    );
  }
}

class _DriverHomeScreenContent extends StatefulWidget {
  const _DriverHomeScreenContent();

  @override
  State<_DriverHomeScreenContent> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<_DriverHomeScreenContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  UserRole? _currentUserRole;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DriverHomeViewModel>().refresh();
      context.read<DriverPastOrdersViewModel>().fetchPastBookings();
      context.read<DriverProfileViewModel>().fetchProfile();
      _loadUserRole();
    });
  }

  void _loadUserRole() {
    final role = context.read<SplashViewModel>().role ?? UserRole.customer;
    setState(() {
      _currentUserRole = role;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshCurrentTab() {
    switch (_tabController.index) {
      case 0:
        context.read<DriverHomeViewModel>().refresh();
        break;
      case 1:
        context.read<DriverPastOrdersViewModel>().fetchPastBookings();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/header_white.png',
              height: 28,
              fit: BoxFit.contain,
            ),
            Text(
              tr('driver_panel'),
              style: AppTextStyles.labelSmall.copyWith(
                color: scheme.onPrimary.withValues(alpha: 0.7),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: Icon(
              SolarIconsOutline.refresh,
              size: AppIconSize.xl,
              color: scheme.onPrimary,
              semanticLabel: 'Refresh',
            ),
            onPressed: _refreshCurrentTab,
          ),
          IconButton(
            tooltip: tr('driver_tab_profile'),
            icon: Icon(
              SolarIconsOutline.user,
              size: AppIconSize.xl,
              color: scheme.onPrimary,
              semanticLabel: 'Profile',
            ),
            onPressed: () => context.push('/driver-profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          const SizedBox(height: AppSpacing.xs),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                DriverDashboardTab(role: _currentUserRole),
                const DriverPastOrdersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.m,
        AppSpacing.screenPadding,
        0,
      ),
      child: Container(
        height: AppSpacing.xxxxl,
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: context.colors.primary,
            borderRadius: BorderRadius.circular(AppSpacing.ms),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerHeight: 0,
          labelColor: context.colors.onPrimary,
          unselectedLabelColor: context.colors.onSurfaceVariant,
          labelStyle: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTextStyles.labelMedium,
          labelPadding: EdgeInsets.zero,
          padding: const EdgeInsets.all(AppSpacing.xxxs),
          tabs: [
            Tab(text: tr('driver_tab_dashboard')),
            Tab(text: tr('driver_tab_past_orders')),
          ],
        ),
      ),
    );
  }
}
