import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/home/widgets/about_section.dart';
import 'package:tour_booking/features/home/widgets/driver_location_status.dart.dart';
import 'package:tour_booking/features/home/widgets/customer_location_info.dart';
import 'package:tour_booking/features/home/widgets/featured_tour_points.dart';
import 'package:tour_booking/features/home/widgets/search_section.dart';
import 'package:tour_booking/features/home/widgets/tour_type.dart';
import 'package:tour_booking/services/location/location_viewmodel.dart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  UserRole? _currentUserRole; // nullable yaptık

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserRole(); // Doğru çağrı
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleString = prefs.getString('user_role');
    if (roleString != null) {
      final role = UserRoleExtension.fromString(roleString);
      setState(() {
        _currentUserRole = role;
      });
      print("[HomeScreen] User role loaded: $_currentUserRole");

      // Role yüklendikten sonra location check yap
      _initialLocationCheck(role);
    } else {
      print("[HomeScreen] No user role found in SharedPreferences.");
    }
  }

  void _initialLocationCheck(UserRole role) {
    Provider.of<LocationViewModel>(
      context,
      listen: false,
    ).checkAndHandleLocation(role);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _currentUserRole != null) {
      print("Uygulama öne geldi, konum ve izinler tekrar kontrol ediliyor...");
      _initialLocationCheck(_currentUserRole!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Henüz role yüklenmediyse bekleme ekranı
    if (_currentUserRole == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'home'.tr()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_currentUserRole == UserRole.driver)
                const DriverLocationStatus()
              else
                const CustomerLocationInfo(),
              const SizedBox(height: 16),
              const SearchSection(),
              const SizedBox(height: 16),
              const TourTypeWidget(),
              const SizedBox(height: 24),
              const FeaturedPointsWidget(),
              const SizedBox(height: 24),
              const AboutSection(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
