import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/features/driver_home_page/driver_viewmodel.dart';
import 'package:tour_booking/features/driver_home_page/widget/customer_info_list_view.dart';
import 'package:tour_booking/features/driver_home_page/widget/location_control_card.dart';
import 'package:tour_booking/features/home/widget/driver_location_status.dart';
import 'package:tour_booking/features/auth/login/google_viewmodel.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/services/driver/driver_service.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => DriverHomeViewModel(ctx.read<DriverService>()),
      child: const _DriverHomeScreenContent(),
    );
  }
}

class _DriverHomeScreenContent extends StatefulWidget {
  const _DriverHomeScreenContent();

  @override
  State<_DriverHomeScreenContent> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<_DriverHomeScreenContent> {
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
              title: Text(tr('driver_app_title')),
              actions: [
                IconButton(
                  tooltip: 'Refresh',
                  icon: const Icon(SolarIconsOutline.refresh, semanticLabel: 'Refresh'),
                  onPressed: vm.isLoading ? null : vm.refresh,
                ),
                IconButton(
                  tooltip: 'Log out',
                  icon: const Icon(SolarIconsOutline.logout, semanticLabel: 'Log out'),
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
                  horizontal: AppSpacing.l,
                  vertical: AppSpacing.xxl,
                ),
                children: [
                  if (_currentUserRole == null)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    if (isDriver) ...[
                      const DriverLocationStatus(),
                      const SizedBox(height: AppSpacing.m),
                      LocationControlCard(role: _currentUserRole!),
                      const SizedBox(height: AppSpacing.xxl),
                    ],

                    if (vm.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (vm.error != null)
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.xxl),
                        child: Text(
                          vm.error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.colors.error),
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
