import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/home/widgets/about_section.dart';
import 'package:tour_booking/features/home/widgets/customer_location_info.dart';
import 'package:tour_booking/features/home/widgets/driver_location_status.dart.dart';
import 'package:tour_booking/features/home/widgets/featured_tour_points.dart';
// SearchLocationPage'i import ettiğinden emin ol

import 'package:tour_booking/features/home/widgets/search_section.dart';
import 'package:tour_booking/features/home/widgets/tour_type.dart';

import 'package:tour_booking/services/location/location_viewmodel.dart.dart'; // Örnek dosya yolu

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
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final roleString = prefs.getString('user_role');
    if (roleString != null) {
      final role = UserRoleExtension.fromString(roleString);
      setState(() => _currentUserRole = role);
      _initialLocationCheck(role);
    } else {
      // Rol bulunamazsa varsayılan olarak customer ata ve devam et
      final defaultRole = UserRole.customer;
      setState(() => _currentUserRole = defaultRole);
      _initialLocationCheck(defaultRole);
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
      _initialLocationCheck(_currentUserRole!);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserRole == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'home'.tr()),
      body: SafeArea(
        // Ana widget'ı Stack yapıyoruz
        child: Stack(
          children: [
            // --- KATMAN 1: Altta kalacak ve kaydırılacak olan içerik ---
            // Bu SingleChildScrollView, ARAMA WIDGET'I DIŞINDA her şeyi içerir.
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Konum durumu widget'ı
                  if (_currentUserRole == UserRole.driver)
                    const DriverLocationStatus()
                  else
                    //const CustomerLocationInfo(),
                    // SearchLocationPage'in kaplayacağı yer kadar boşluk bırakıyoruz.
                    // Yüksekliği, arama çubuğunun yüksekliğine göre ayarla.
                    const SizedBox(
                      height: 70,
                    ), // Arama çubuğu ve altındaki boşluk için.
                  // Arama çubuğunun ALTINDAKİ diğer widget'lar
                  const TourTypeWidget(),
                  const SizedBox(height: 24),
                  const FeaturedPointsWidget(),
                  const SizedBox(height: 24),
                  const AboutSection(),
                ],
              ),
            ),

            // --- KATMAN 2: Her şeyin üzerine gelecek olan arama widget'ı ---
            // Padding ile onu kenarlardan hizalıyoruz.
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: SearchLocationPage(),
            ),
          ],
        ),
      ),
    );
  }
}

// UserRoleExtension tanımını buraya ekliyorum (eğer başka bir yerde değilse)
