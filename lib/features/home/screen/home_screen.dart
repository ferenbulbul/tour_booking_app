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
import 'package:tour_booking/features/profile_warning_banner/profile_warning_banner.dart';
import 'package:tour_booking/services/location/location_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  UserRole? _currentUserRole;
  bool _locationChecked = false;
  bool _permissionsAsked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() {
      context.read<ProfileStatusViewModel>().init();
      context.read<PermissionsViewModel>().syncPlayerId();
    });
    _loadUserRole();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _askPermissionsOnce();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _askPermissionsOnce() async {
    if (_permissionsAsked) return;

    final prefs = await SharedPreferences.getInstance();
    final asked = prefs.getBool("asked_permissions") ?? false;

    if (!asked) {
      // 📍 KONUM
      await Permission.location.request();

      // 🔔 BİLDİRİM
      await OneSignal.Notifications.requestPermission(true);

      // tekrar sorma
      await prefs.setBool("asked_permissions", true);
    }

    _permissionsAsked = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      context.read<PermissionsViewModel>().loadPermissions();
    }
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final roleString = prefs.getString('user_role');
    final role = roleString != null
        ? UserRoleExtension.fromString(roleString)
        : UserRole.customer;

    setState(() => _currentUserRole = role);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialLocationCheck(role);
    });
  }

  void _initialLocationCheck(UserRole role) {
    if (_locationChecked) return;
    _locationChecked = true;

    context.read<LocationViewModel>().checkAndHandleLocation(role);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserRole == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.elementSpacing,
              ),
              sliver: const SliverToBoxAdapter(
                child: RepaintBoundary(child: HomeHeader()),
              ),
            ),

            // ⚠️ PROFILE WARNING
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    ProfileWarningBanner(
                      onAction: () => context.go('/profile'),
                    ),
                    const SizedBox(height: AppSpacing.sectionSpacing),
                  ],
                ),
              ),
            ),

            // 🔍 SEARCH BAR
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              sliver: const SliverToBoxAdapter(
                child: Column(
                  children: [
                    FakeSearchBar(),
                    SizedBox(height: AppSpacing.sectionSpacing),
                  ],
                ),
              ),
            ),

            // ⭐ FEATURED
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              sliver: const SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(title: "Featured Tours"),
                    SizedBox(height: AppSpacing.m),
                    RepaintBoundary(child: FeaturedPointsWidget()),
                    SizedBox(height: AppSpacing.sectionSpacing),
                  ],
                ),
              ),
            ),

            // 📍 NEARBY
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              sliver: const SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(
                      title: "Nearby Tours",
                      subtitle: "Find tours close to your current location",
                    ),
                    SizedBox(height: AppSpacing.s),
                    RepaintBoundary(child: NearbyPointsButton()),
                    SizedBox(height: AppSpacing.sectionSpacing),
                  ],
                ),
              ),
            ),

            // 🏷 CATEGORIES
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              sliver: const SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(title: "Categories"),
                    RepaintBoundary(child: TourTypeWidget()),
                    SizedBox(height: AppSpacing.sectionSpacing),
                  ],
                ),
              ),
            ),

            // ℹ️ ABOUT
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              sliver: const SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(title: "About Us"),
                    SizedBox(height: AppSpacing.s),
                    RepaintBoundary(child: AboutSection()),
                    SizedBox(height: AppSpacing.sectionSpacing * 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
