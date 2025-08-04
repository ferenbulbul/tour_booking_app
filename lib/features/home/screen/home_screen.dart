import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/home/widgets/about_section.dart';
import 'package:tour_booking/features/home/widgets/business_location_status.dart.dart';
import 'package:tour_booking/features/home/widgets/categories_section.dart';
import 'package:tour_booking/features/home/widgets/customer_location_info.dart';
import 'package:tour_booking/features/home/widgets/featured_section.dart';
import 'package:tour_booking/features/home/widgets/search_section.dart';
import 'package:tour_booking/services/auth/location_viewmodel.dart.dart';

// === YENİ WIDGET'LARI BURADA IMPORT EDİYORUZ ===

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // Rolü buradan değiştirerek test edebilirsin
  // final UserRole _currentUserRole = UserRole.business;
  final UserRole _currentUserRole = UserRole.customer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialLocationCheck();
  }

  void _initialLocationCheck() {
    Provider.of<LocationViewModel>(
      context,
      listen: false,
    ).checkAndHandleLocation(_currentUserRole);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("Uygulama öne geldi, konum ve izinler tekrar kontrol ediliyor...");
      _initialLocationCheck();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'home'.tr()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_currentUserRole == UserRole.business)
                const BusinessLocationStatus()
              else
                const CustomerLocationInfo(),

              const SizedBox(height: 16),

              const SearchSection(),
              const SizedBox(height: 24),
              const FeaturedSection(),
              const SizedBox(height: 24),
              const CategoriesSection(),
              const SizedBox(height: 24),
              const AboutSection(),
            ],
          ),
        ),
      ),
    );
  }
}
