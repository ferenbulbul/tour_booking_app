import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';

import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';

import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/widgets/section_title.dart';
import 'package:tour_booking/features/home/widget/featured_tour_points.dart';
import 'package:tour_booking/features/home/widget/popular_cities.dart';
import 'package:tour_booking/features/home/widget/search_section.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Tüm başlangıç işlemlerini güvenli sırayla başlatıyoruz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ============================================================
  // 🔥 INITIALIZE — Her şeyin doğru sırayla başlaması
  // ============================================================
  Future<void> _initialize() async {
    if (_initialized) return;
    _initialized = true;

    // PROFILE & PERMISSIONS & PLAYER ID
    context.read<ProfileViewModel>().fetchProfile();
    context.read<PermissionsViewModel>().syncPlayerId();

    // ROLE LOAD
    _loadUserRole();

    // CONTINUE IN CITY — sadece hedef şehirleri belirle (API çağrısı yok)
    context.read<HomeViewModel>().loadCityTargets();

    // LOCATION CHECK + NEARBY
    await _checkLocation();
    _fetchNearbyIfPermitted();

    // ASK PERMISSIONS ONLY WHEN NEEDED
    await _askMissingPermissions();

    // Onboarding sonrasi login bottom sheet goster
    _maybeShowLoginSheet();
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
  // 🔥 User Role Load
  // ============================================================
  void _loadUserRole() {
    final role = context.read<SplashViewModel>().role ?? UserRole.customer;
    setState(() => _currentRole = role);
  }

  // ============================================================
  // 🔥 LOCATION CHECK
  // ============================================================
  Future<void> _checkLocation() async {
    if (_currentRole == null) return;

    await context.read<LocationViewModel>().checkAndHandleLocation(
      _currentRole!,
    );
  }

  // ============================================================
  // 🔥 NEARBY — konum izni varsa yakın turları getir
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
  // 🔥 Ask only missing permissions
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
  // 🔥 APP RESUME → izin + konum + profil yenile
  // ============================================================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      context.read<PermissionsViewModel>().loadPermissions();
      await _checkLocation();
      _fetchNearbyIfPermitted();
    }
  }

  // ============================================================
  // 🔥 UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    if (_currentRole == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // FIXED TOP BAR — notification icon + search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding, 12, AppSpacing.screenPadding, 16,
              ),
              child: Row(
                children: [
                  const Expanded(child: FakeSearchBar()),
                  const SizedBox(width: AppSpacing.m),
                  GestureDetector(
                    onTap: () {
                      // TODO: bildirimler sayfası
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: const Icon(
                        SolarIconsOutline.bell,
                        color: AppColors.textPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // SCROLLABLE CONTENT
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
            // FEATURED (edge-to-edge horizontal scroll)
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.s),
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
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.sectionSpacing),
            ),

            // NEARBY TOURS (konum izni varsa)
            const SliverToBoxAdapter(
              child: RepaintBoundary(child: NearbyTourPointsWidget()),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.sectionSpacing),
            ),

            // CONTINUE IN CITY — lazy loaded: her bölüm görünürse kendi turlarını çeker
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
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.sectionSpacing),
            ),

            // CATEGORIES
            _sliverSection(
              title: tr("categories"),
              body: const TourTypeWidget(),
              bottomSpace: AppSpacing.m,
            ),
          ],
        ),
      ), // Expanded
    ], // Column
      ),
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
