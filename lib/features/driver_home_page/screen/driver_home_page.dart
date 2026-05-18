import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/features/driver_home_page/driver_viewmodel.dart';
import 'package:tour_booking/features/driver_home_page/widget/customer_info_list_view.dart';
import 'package:tour_booking/features/driver_home_page/widget/location_control_card.dart';
import 'package:tour_booking/features/home/widget/driver_location_status.dart';
import 'package:tour_booking/features/auth/login/google_viewmodel.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/services/driver/driver_service.dart';

class DriverHomePage extends StatelessWidget {
  const DriverHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => DriverHomeViewModel(ctx.read<DriverService>()),
      child: const _DriverHomePageContent(),
    );
  }
}

class _DriverHomePageContent extends StatefulWidget {
  const _DriverHomePageContent();

  @override
  State<_DriverHomePageContent> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<_DriverHomePageContent> {
  UserRole? _currentUserRole;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DriverHomeViewModel>().refresh();
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
  Widget build(BuildContext context) {
    return Consumer<DriverHomeViewModel>(
      builder: (context, vm, _) {
        final isDriver = _currentUserRole == UserRole.driver;

        return Scaffold(
            appBar: AppBar(
              title: const Text('Tourlio Sürücü'),
              actions: [
                IconButton(
                  icon: const Icon(SolarIconsOutline.refresh),
                  onPressed: vm.isLoading ? null : vm.refresh,
                ),
                IconButton(
                  icon: const Icon(SolarIconsOutline.logout),
                  onPressed: () async {
                    final splashVm = context.read<SplashViewModel>();
                    final authVm = context.read<AuthViewModel>();
                    await splashVm.performFullSignOut(
                      socialCleanup: () => authVm.socialSignOut(),
                    );
                  },
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
                    if (isDriver) ...[
                      const DriverLocationStatus(),
                      const SizedBox(height: 12),
                      LocationControlCard(role: _currentUserRole!),
                      const SizedBox(height: 24),
                    ],

                    if (vm.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (vm.error != null)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          vm.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    else
                      CustomerInfoListView(
                        items: vm.customerList,
                        onCompleteDropoff: vm.completeDropoff,
                      ),
                  ],
                ],
              ),
            ),
          );
      },
    );
  }
}
