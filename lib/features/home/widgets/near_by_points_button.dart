import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class NearbyPointsButton extends StatelessWidget {
  const NearbyPointsButton({super.key});

  Future<bool> _hasPermission() async {
    return (await Permission.locationWhenInUse.status).isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasPermission(),
      builder: (context, snapshot) {
        return _MinimalNearbyCard(
          onTap: () async {
            final status = await Permission.locationWhenInUse.status;

            if (status.isGranted) {
              if (context.mounted) context.pushNamed("nearbyPoints");
              return;
            }

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(tr("enable_location_permission_from_settings")),
                ),
              );
            }
          },
        );
      },
    );
  }
}

class _MinimalNearbyCard extends StatelessWidget {
  final VoidCallback onTap;
  const _MinimalNearbyCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.withOpacity(.18), width: 1),
        ),
        child: Row(
          children: [
            /// ICON (MINIMAL)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.my_location_rounded, color: primary, size: 18),
            ),

            const SizedBox(width: 14),

            /// TEXT (CLEAN)
            Expanded(
              child: Text(
                tr("nearby_tours"),
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
            ),

            /// MINIMAL ARROW
            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}
