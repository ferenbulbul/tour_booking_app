import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/driver_home_page/driver_viewmodel.dart';
import 'package:tour_booking/features/driver_home_page/widget/customer_info_list_view.dart';
import 'package:tour_booking/features/home/widget/driver_location_status.dart';
import 'package:tour_booking/features/location/location_viewmodel.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/services/location/location_permission_service.dart';

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
                  const SizedBox(height: AppSpacing.l),
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
                    activeTourBookingId: vm.activeTourBookingId,
                    onStartTour: (bookingId) async {
                      final locationVm = context.read<LocationViewModel>();

                      // Step 1: Check & request basic (whenInUse) permission
                      var status =
                          await locationVm.checkAndHandleLocation(
                        UserRole.driver,
                        requestIfDenied: true,
                      );

                      if (!context.mounted) return;

                      // Step 2: If whenInUse granted but always not,
                      // show rationale then request always via system dialog
                      if (status ==
                          LocationPermissionStatus.grantedWhenInUse) {
                        final proceed =
                            await _showAlwaysPermissionRationale(context);
                        if (!proceed || !context.mounted) return;

                        status = await locationVm.requestAlwaysAndTrack();
                        if (!context.mounted) return;
                      }

                      // Step 3: Final check
                      if (status ==
                          LocationPermissionStatus.grantedAlways) {
                        // Turu backend'de başlat; başarısız olursa takibi durdur
                        final ok = await vm.startTour(bookingId);
                        if (!context.mounted) return;
                        if (!ok) {
                          context.read<LocationViewModel>().stopTracking();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                vm.startError ?? tr('error_generic'),
                              ),
                            ),
                          );
                        }
                      } else {
                        _showBgPermissionRequiredDialog(context, status);
                      }
                    },
                    onEndTour: () {
                      vm.endTour();
                      context.read<LocationViewModel>().stopTracking();
                    },
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Rationale dialog shown BEFORE the system "always" permission dialog.
  /// Returns true if the user taps "Devam Et", false if dismissed.
  Future<bool> _showAlwaysPermissionRationale(BuildContext context) async {
    final scheme = context.colors;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: context.ext.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: Icon(
                  SolarIconsOutline.mapPoint,
                  size: 28,
                  color: context.ext.info,
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                tr('driver_always_rationale_title'),
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                tr('driver_always_rationale_message'),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: scheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(
                    tr('continue'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return result ?? false;
  }

  /// Error dialog shown when the user still doesn't have "always" permission
  /// after the system dialog.
  void _showBgPermissionRequiredDialog(
    BuildContext context,
    LocationPermissionStatus status,
  ) {
    final scheme = context.colors;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: scheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: Icon(
                  SolarIconsOutline.mapPointRemove,
                  size: 28,
                  color: scheme.error,
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                tr('driver_bg_required_title'),
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                tr('driver_bg_required_message'),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: scheme.onSurfaceVariant,
                          padding: EdgeInsets.zero,
                          side: BorderSide(color: scheme.outline),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.medium),
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          tr('cancel'),
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: scheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.m),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.medium),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          openAppSettings();
                        },
                        child: Text(
                          tr('driver_bg_required_settings'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
