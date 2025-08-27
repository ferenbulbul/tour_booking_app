import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/features/driver_home_page/driver_viewmodel.dart';
import 'package:tour_booking/features/home/widgets/driver_location_status.dart';
import 'package:tour_booking/features/login/widgets/google_view_model.dart';
import 'package:tour_booking/features/login/widgets/login_view_model.dart';
import 'package:tour_booking/services/location/location_viewmodel.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage>
    with WidgetsBindingObserver {
  late final DriverHomeViewModel _vm;
  UserRole? _currentUserRole;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _vm = DriverHomeViewModel();

    // sayfa açılır açılmaz sadece refresh + rol yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _vm.refresh();
      _loadUserRole();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _vm.dispose();
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

    // ÖNEMLİ: Driver için ilk girişte izin istemiyoruz, butondan isteyeceğiz.
    // Customer olsaydı burada nazik akışla isteyebilirdik (istersen açarsın):
    // if (role == UserRole.customer) {
    //   Provider.of<LocationViewModel>(context, listen: false)
    //       .checkAndHandleLocation(role);
    // }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Uygulama tekrar öne geldiğinde otomatik sorma; driver için butonla yönetiyoruz.
    // Eğer müşteri tarafında otomatik kontrol istiyorsan burayı role == customer ile kullanabilirsin.
    // if (state == AppLifecycleState.resumed && _currentUserRole == UserRole.customer) {
    //   Provider.of<LocationViewModel>(context, listen: false)
    //       .checkAndHandleLocation(UserRole.customer, isCalledFromResumed: true);
    // }
  }

  @override
  Widget build(BuildContext context) {
    // LocationViewModel üstte bir Provider olarak verilmiş olmalı (MultiProvider vs.)
    final locationVm = context.watch<LocationViewModel>();

    return ChangeNotifierProvider.value(
      value: _vm,
      child: Consumer<DriverHomeViewModel>(
        builder: (context, vm, _) {
          final isDriver = _currentUserRole == UserRole.driver;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Driver Home'),
              actions: [
                IconButton(
                  tooltip: 'Yenile',
                  onPressed: vm.isLoading ? null : vm.refresh,
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  tooltip: 'Çıkış yap',
                  onPressed: () async {
                    // önce düzgün çıkış, sonra navigate
                    final loginVm = context.read<GoogleViewModel>();
                    await loginVm
                        .signOut(); // senin imzana göre Result dönebilir, uyarlayabilirsin
                    if (!mounted) return;
                    context.go('/login');
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),

            body: RefreshIndicator(
              onRefresh: vm.refresh,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                children: [
                  if (_currentUserRole == null)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    // DRIVER için konum başlat/durdur
                    if (isDriver) ...[
                      const DriverLocationStatus(), // mevcut durumun görseli
                      const SizedBox(height: 12),
                      _LocationControlCard(role: _currentUserRole!),
                      const SizedBox(height: 24),
                    ],

                    // boş durum içerikleri
                    const SizedBox(height: 60),
                    const Icon(Icons.inbox, size: 72),
                    const SizedBox(height: 12),
                    const Text(
                      'Şimdilik içerik yok',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Yukarıdan yenileyebilir veya hazır olduğunuzu bildirebilirsiniz.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            // İstersen burada başka FAB aksiyonları kullanabilirsin
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                // TODO: örn. vardiya başlat / yeni görevlere bak
              },
              icon: const Icon(Icons.local_taxi),
              label: const Text('Hazırım'),
            ),
          );
        },
      ),
    );
  }
}

/// Driver için konum izni/akışı butonla yönetilen kart.
/// - İlk girişte sormaz.
/// - "Konumu Başlat" → izinleri ister ve stream’i başlatır.
/// - "Konumu Durdur" → stream’i kapatır.
class _LocationControlCard extends StatelessWidget {
  const _LocationControlCard({required this.role});
  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final locationVm = context.watch<LocationViewModel>();
    final tracking = locationVm.isTracking;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Konum Paylaşımı',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              tracking
                  ? 'Konum paylaşımı AKTİF.'
                  : 'Konum paylaşımı PASİF. Başlatmak için butona bas.',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(tracking ? Icons.stop : Icons.play_arrow),
                  label: Text(tracking ? 'Konumu Durdur' : 'Konumu Başlat'),
                  onPressed: () async {
                    if (tracking) {
                      // Durdur
                      locationVm.stopTracking();
                    } else {
                      // Başlat (butonla iste): Driver için izni ve stream’i tetikle
                      await locationVm.checkAndHandleLocation(role);
                    }
                  },
                ),
                const SizedBox(width: 12),
                // iOS/Android ayarlar kısayolu istersen:
                OutlinedButton.icon(
                  icon: const Icon(Icons.settings),
                  label: const Text('Ayarlar'),
                  onPressed: () {
                    // permission_handler'daki openAppSettings()
                    openAppSettings();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
