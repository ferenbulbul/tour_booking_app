import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';

import 'package:tour_booking/features/home/widgets/home_header.dart';
import 'package:tour_booking/core/widgets/section_title.dart';
import 'package:tour_booking/features/home/widgets/about_section.dart';
import 'package:tour_booking/features/home/widgets/featured_tour_points.dart';
import 'package:tour_booking/features/home/widgets/near_by_points_button.dart';
import 'package:tour_booking/features/home/widgets/search_section.dart';
import 'package:tour_booking/features/home/widgets/tour_type.dart';

import 'package:tour_booking/features/profile/permission_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_status_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/features/profile_warning_banner/profile_warning_banner.dart';

import 'package:tour_booking/services/location/location_viewmodel.dart';

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

    final prefs = await SharedPreferences.getInstance();

    // PROFILE & PERMISSIONS & PLAYER ID
    context.read<ProfileStatusViewModel>().init();
    context.read<ProfileViewModel>().fetchProfile();
    context.read<PermissionsViewModel>().syncPlayerId();

    // ROLE LOAD
    await _loadUserRole(prefs);

    // LOCATION CHECK
    _checkLocation();

    // ASK PERMISSIONS ONLY WHEN NEEDED
    await _askMissingPermissions();
  }

  // ============================================================
  // 🔥 User Role Load
  // ============================================================
  Future<void> _loadUserRole(SharedPreferences prefs) async {
    final str = prefs.getString('user_role');
    final role = str != null
        ? UserRoleExtension.fromString(str)
        : UserRole.customer;

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
  // 🔥 Ask only missing permissions
  // ============================================================
  Future<void> _askMissingPermissions() async {
    final locationStatus = await Permission.location.status;

    if (!locationStatus.isGranted) {
      await Permission.location.request();
    }

    await OneSignal.Notifications.requestPermission(false);
  }

  // ============================================================
  // 🔥 APP RESUME → izin + konum + profil yenile
  // ============================================================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<PermissionsViewModel>().loadPermissions();
      _checkLocation(); // kullanıcı ayarlardan konumu açarsa çalışsın
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // HEADER
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.elementSpacing,
              ),
              sliver: const SliverToBoxAdapter(
                child: RepaintBoundary(child: HomeHeader()),
              ),
            ),

            // PROFILE WARNING
            SliverToBoxAdapter(
              child: Consumer<ProfileStatusViewModel>(
                builder: (_, vm, __) {
                  final show =
                      vm.isComplete == false && !vm.dismissedThisSession;

                  if (!show) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                    ),
                    child: Column(
                      children: [
                        ProfileWarningBanner(
                          onAction: () => GoRouter.of(
                            context,
                          ).push('/settings/permissions'),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  );
                },
              ),
            ),

            // SEARCH BAR
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              sliver: const SliverToBoxAdapter(
                child: Column(
                  children: [
                    FakeSearchBar(),
                    SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),

            // FEATURED
            _sliverSection(
              title: tr("featured_tours"),
              body: const FeaturedPointsWidget(),
            ),

            // NEARBY
            _sliverSection(
              title: tr("nearby_tours"),
              subtitle: tr("find_tours_nearby"),
              body: const NearbyPointsButton(),
            ),

            // CATEGORIES
            _sliverSection(
              title: tr("categories"),
              body: const TourTypeWidget(),
            ),

            // ABOUT US
            _sliverSection(
              title: tr("about_us"),
              body: const AboutSection(),
              bottomSpace: AppSpacing.m,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 🔥 REUSABLE SECTION BUILDER
  // ============================================================
  SliverPadding _sliverSection({
    required String title,
    String? subtitle,
    required Widget body,
    double bottomSpace = AppSpacing.xxl,
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
