import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/driver_home_page/driver_viewmodel.dart';
import 'package:tour_booking/features/driver_home_page/widget/customer_info_list_view.dart';
import 'package:tour_booking/features/driver_home_page/widget/location_control_card.dart';
import 'package:tour_booking/features/home/widget/driver_location_status.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class DriverDashboardTab extends StatelessWidget {
  const DriverDashboardTab({super.key, required this.role});

  final UserRole? role;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    return Consumer<DriverHomeViewModel>(
      builder: (context, vm, _) {
        final isDriver = role == UserRole.driver;

        return RefreshIndicator(
          onRefresh: vm.refresh,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.xl,
            ),
            children: [
              if (role == null)
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.massive),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (isDriver) ...[
                  const DriverLocationStatus(),
                  const SizedBox(height: AppSpacing.m),
                  LocationControlCard(role: role!),
                  const SizedBox(height: AppSpacing.xxl),
                ],

                if (vm.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.huge),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (vm.error != null)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Text(
                      vm.error!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: scheme.error,
                      ),
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
        );
      },
    );
  }
}
