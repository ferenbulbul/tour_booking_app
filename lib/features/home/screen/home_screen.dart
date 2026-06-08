import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';

import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';

import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/widgets/section_title.dart';
import 'package:tour_booking/features/home/widget/featured_tour_points.dart';
import 'package:tour_booking/features/home/widget/home_sliver_app_bar.dart';
import 'package:tour_booking/features/home/widget/popular_cities.dart';
import 'package:tour_booking/features/home/widget/tour_type.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/home/widget/continue_in_city.dart';
import 'package:tour_booking/features/home/widget/nearby_tour_points.dart';
import 'package:tour_booking/services/location/location_permission_service.dart';

import 'package:tour_booking/features/profile/permission_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';

import 'package:tour_booking/features/auth/login/widget/login_bottom_sheet.dart';
import 'package:tour_booking/features/location/location_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  UserRole? _currentRole;
  bool _initialized = false;
  SplashViewModel? _splashVm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize all startup tasks in safe order
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();

      // Listen for auth state changes (e.g., guest → customer after Google login)
      _splashVm = context.read<SplashViewModel>();
      _splashVm!.addListener(_onAuthStateChanged);
    });
  }

  @override
  void dispose() {
    _splashVm?.removeListener(_onAuthStateChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onAuthStateChanged() {
    final newRole = _splashVm?.role;
    if (newRole != null && newRole != _currentRole) {
      setState(() => _currentRole = newRole);
      if (mounted) {
        _refreshAfterAuth();
      }
    }
  }

  // ============================================================
  // INITIALIZE — Ensure everything starts in correct order
  // ============================================================
  Future<void> _initialize() async {
    if (_initialized) return;
    _initialized = true;

    // PROFILE & PERMISSIONS & PLAYER ID
    context.read<ProfileViewModel>().fetchProfile();
    context.read<PermissionsViewModel>().syncPlayerId();

    // ROLE LOAD
    _loadUserRole();

    // HOME DATA — fetch featured tours + continue-in-city targets
    final homeVm = context.read<HomeViewModel>();
    homeVm.init();
    homeVm.loadCityTargets();

    // LOCATION CHECK + NEARBY
    await _checkLocation();
    if (!mounted) return;
    _fetchNearbyIfPermitted();

    // ASK PERMISSIONS ONLY WHEN NEEDED
    await _askMissingPermissions();
    if (!mounted) return;

    // Show login bottom sheet after onboarding
    _maybeShowLoginSheet();
  }

  // Called when user transitions from guest to logged-in
  void _refreshAfterAuth() {
    context.read<HomeViewModel>().init();
    context.read<HomeViewModel>().loadCityTargets();
    context.read<ProfileViewModel>().fetchProfile();
    _fetchNearbyIfPermitted();
  }

  void _maybeShowLoginSheet() {
    final splashVm = context.read<SplashViewModel>();
    if (splashVm.shouldShowLoginSheet) {
      splashVm.clearLoginSheetFlag();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showLoginBottomSheet(context);
        }
      });
    }
  }

  // ============================================================
  // User Role Load
  // ============================================================
  void _loadUserRole() {
    final role = context.read<SplashViewModel>().role ?? UserRole.customer;
    setState(() => _currentRole = role);
  }

  // ============================================================
  // LOCATION CHECK
  // ============================================================
  Future<void> _checkLocation() async {
    if (_currentRole == null || _currentRole == UserRole.driver) return;

    await context.read<LocationViewModel>().checkAndHandleLocation(
      _currentRole!,
    );
  }

  // ============================================================
  // NEARBY — fetch nearby tours if location permission granted
  // ============================================================
  void _fetchNearbyIfPermitted() {
    final locVm = context.read<LocationViewModel>();
    final status = locVm.permissionStatus;
    final pos = locVm.currentPosition;
    if ((status == LocationPermissionStatus.grantedAlways ||
            status == LocationPermissionStatus.grantedWhenInUse) &&
        pos != null) {
      context.read<HomeViewModel>().fetchNearbyTourPoints(
            latitude: pos.latitude,
            longitude: pos.longitude,
          );
    }
  }

  // ============================================================
  // Ask only missing permissions
  // ============================================================
  Future<void> _askMissingPermissions() async {
    final accepted = await OneSignal.Notifications.requestPermission(false);
    if (accepted && mounted) {
      context.read<ProfileViewModel>().updateNotificationPreference(
        type: 'push',
        value: true,
      );
    }
  }

  // ============================================================
  // APP RESUME — refresh permissions + location + profile
  // ============================================================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<PermissionsViewModel>().loadPermissions();
      await _checkLocation();
      if (!mounted) return;
      _fetchNearbyIfPermitted();
    }
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    if (_currentRole == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final scheme = context.colors;
    final profileVm = context.watch<ProfileViewModel>();
    final splashVm = context.watch<SplashViewModel>();

    return Scaffold(
      backgroundColor: scheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
            // COLLAPSIBLE DARK HEADER
            HomeSliverAppBar(
              fullName: profileVm.profile?.fullName,
              isGuest: splashVm.isGuest,
            ),

            // FEATURED (edge-to-edge horizontal scroll)
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.sectionSpacing),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              sliver: SliverToBoxAdapter(
                child: SectionTitle(
                  title: tr("featured_tours"),
                  onMore: () => context.push('/all-featured'),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(top: AppSpacing.m),
              sliver: SliverToBoxAdapter(
                child: RepaintBoundary(child: FeaturedPointsWidget()),
              ),
            ),

            // NEARBY TOURS (includes own top spacing, hidden = no spacing)
            const SliverToBoxAdapter(
              child: RepaintBoundary(child: NearbyTourPointsWidget()),
            ),

            // CONTINUE IN CITY (each includes own top spacing)
            ...context.select<HomeViewModel, List<CityToursSection>>(
              (vm) => vm.citySections,
            ).map((section) => SliverToBoxAdapter(
              child: RepaintBoundary(
                child: LazyCitySection(
                  key: ValueKey('city_${section.cityId}'),
                  section: section,
                ),
              ),
            )),

            // POPULAR CITIES
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.sectionSpacing),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              sliver: SliverToBoxAdapter(
                child: SectionTitle(title: tr("popular_cities")),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(top: AppSpacing.m),
              sliver: SliverToBoxAdapter(
                child: RepaintBoundary(child: PopularCitiesWidget()),
              ),
            ),

            // CATEGORIES
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.sectionSpacing),
            ),
            _sliverSection(
              title: tr("categories"),
              body: const TourTypeWidget(),
            ),
          ],
        ),
    );
  }

  // ============================================================
  // REUSABLE SECTION BUILDER
  // ============================================================
  SliverPadding _sliverSection({
    required String title,
    String? subtitle,
    required Widget body,
    double bottomSpace = AppSpacing.sectionSpacing,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: title, subtitle: subtitle),
            const SizedBox(height: AppSpacing.m),
            RepaintBoundary(child: body),
            SizedBox(height: bottomSpace),
          ],
        ),
      ),
    );
  }
}
