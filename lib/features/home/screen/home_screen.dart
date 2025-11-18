import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/features/home/widgets/home_header.dart'; // ⭐ Premium Header

import 'package:tour_booking/core/widgets/section_title.dart';
import 'package:tour_booking/features/home/widgets/about_section.dart';
import 'package:tour_booking/features/home/widgets/featured_tour_points.dart';
import 'package:tour_booking/features/home/widgets/near_by_points_button.dart';
import 'package:tour_booking/features/home/widgets/search_section.dart';
import 'package:tour_booking/features/home/widgets/tour_type.dart';
import 'package:tour_booking/features/profile/profile/profile_status_viewmodel.dart';
import 'package:tour_booking/features/profile_warning_banner/profile_warning_banner.dart';
import 'package:tour_booking/services/location/location_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  UserRole? _currentUserRole;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserRole();
    Future.microtask(() => context.read<ProfileStatusViewModel>().init());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final roleString = prefs.getString('user_role');
    final role = roleString != null
        ? UserRoleExtension.fromString(roleString)
        : UserRole.customer;

    setState(() => _currentUserRole = role);
    _initialLocationCheck(role);
  }

  void _initialLocationCheck(UserRole role) {
    context.read<LocationViewModel>().checkAndHandleLocation(role);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserRole == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      // ❌ Eskisini siliyoruz → appBar: ModernBlurAppBar(...),
      // ✔ Premium header artık body içinde olacak.
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.elementSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ⭐ PREMIUM HEADER
              const HomeHeader(),

              // PROFILE WARNING
              ProfileWarningBanner(onAction: () => context.go('/profile')),
              const SizedBox(height: AppSpacing.sectionSpacing),

              // 🔍 SEARCH BAR
              const FakeSearchBar(),
              const SizedBox(height: AppSpacing.sectionSpacing),

              // ⭐ FEATURED TOURS
              const SectionTitle(title: "Featured Tours"),
              const SizedBox(height: AppSpacing.m),
              const FeaturedPointsWidget(),
              const SizedBox(height: AppSpacing.sectionSpacing),

              // 📍 NEARBY TOURS
              const SectionTitle(
                title: "Nearby Tours",
                subtitle: "Find tours close to your current location",
              ),
              const SizedBox(height: AppSpacing.s),
              const NearbyPointsButton(),
              const SizedBox(height: AppSpacing.sectionSpacing),

              // 🏷 CATEGORIES
              const SectionTitle(title: "Categories"),
              const TourTypeWidget(),
              const SizedBox(height: AppSpacing.sectionSpacing),

              // ℹ️ ABOUT SECTION
              const SectionTitle(title: "About Us"),
              const SizedBox(height: AppSpacing.s),
              const AboutSection(),

              const SizedBox(height: AppSpacing.sectionSpacing * 2),
            ],
          ),
        ),
      ),
    );
  }
}
