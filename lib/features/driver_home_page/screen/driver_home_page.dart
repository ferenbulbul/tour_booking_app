import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/features/driver_home_page/driver_viewmodel.dart';
import 'package:tour_booking/features/driver_home_page/widget/customer_info_list_view.dart';
import 'package:tour_booking/features/driver_home_page/widget/location_control_card.dart';
import 'package:tour_booking/features/home/widgets/driver_location_status.dart';
import 'package:tour_booking/features/auth/login/widgets/google_view_model.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/services/driver/driver_service.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  late final DriverHomeViewModel _vm;
  UserRole? _currentUserRole;

  @override
  void initState() {
    super.initState();
    _vm = DriverHomeViewModel(context.read<DriverService>());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _vm.refresh();
      _loadUserRole();
    });
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final roleString = prefs.getString('user_role');
    setState(() {
      _currentUserRole = roleString != null
          ? UserRoleExtension.fromString(roleString)
          : UserRole.customer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: Consumer<DriverHomeViewModel>(
        builder: (context, vm, _) {
          final isDriver = _currentUserRole == UserRole.driver;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Tourlio Sürücü'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: vm.isLoading ? null : vm.refresh,
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await context.read<AuthViewModel>().signOut();
                    await context.read<SplashViewModel>().initializeApp();
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
                      CustomerInfoListView(items: vm.customerList),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
