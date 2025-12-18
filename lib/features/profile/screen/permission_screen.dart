import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';

import 'package:tour_booking/features/profile/permission_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/models/profile/profile_response.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() {
      context.read<PermissionsViewModel>().loadPermissions();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<PermissionsViewModel>().loadPermissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileVm = context.watch<ProfileViewModel>();
    final permVm = context.watch<PermissionsViewModel>();
    final scheme = Theme.of(context).colorScheme;

    final profile = profileVm.profile;
    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: CommonAppBar(title: tr("permissions")),

      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.l),
        children: [
          _PhoneCard(profile: profile),
          const SizedBox(height: AppSpacing.xl),

          _LocationPermissionRow(vm: permVm),
        ],
      ),
    );
  }
}

// ------------------------------------------------------
// PREMIUM PHONE CARD
// ------------------------------------------------------

class _PhoneCard extends StatelessWidget {
  final ProfileResponse profile;

  const _PhoneCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final hasPhone = profile.phoneNumber.isNotEmpty;
    final verified = profile.phoneNumberConfirmed;

    final badgeColor = !hasPhone
        ? Colors.orange
        : verified
        ? Colors.green
        : Colors.orange;

    final badgeText = !hasPhone
        ? tr("not_entered")
        : verified
        ? tr("verified")
        : tr("not_verified");

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: scheme.surfaceVariant.withOpacity(.4),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: scheme.outlineVariant.withOpacity(.25)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.phone_iphone_rounded, size: 30, color: scheme.primary),
          const SizedBox(width: AppSpacing.m),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr("phone_number"),
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  hasPhone ? profile.phoneNumber : "—",
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w400,
                    color: scheme.onSurface,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  hasPhone
                      ? (verified
                            ? tr("phone_usage_info")
                            : tr("phone_not_verified"))
                      : tr("phone_required"),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(.15),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              TextButton(
                onPressed: () => context.push("/update-phone"),
                child: Text(hasPhone ? tr("update") : tr("add")),
              ),
              if (hasPhone && !verified)
                TextButton(
                  onPressed: () => context.push("/verify-phone"),
                  child: Text(tr("verify")),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------
//  🔥 LOCATION PERMISSION ROW
// ------------------------------------------------------

class _LocationPermissionRow extends StatelessWidget {
  final PermissionsViewModel vm;

  const _LocationPermissionRow({required this.vm});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final allowed = vm.locationAllowed;
    final permanentlyDenied = vm.locationPermanentlyDenied;

    return _PermissionRow(
      icon: Icons.location_on_outlined,
      title: tr("location"),
      subtitle: tr("location_required_for_suggestions"),
      allowed: allowed,
      permanentlyDenied: permanentlyDenied,
      onRequest: () async {
        if (permanentlyDenied) {
          openAppSettings();
        } else {
          await vm.requestLocation();
        }
      },
    );
  }
}

// ------------------------------------------------------
//  🔥 GENERIC PERMISSION ROW — THE PREMIUM ONE
// ------------------------------------------------------

class _PermissionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool allowed;
  final bool permanentlyDenied;
  final VoidCallback onRequest;

  const _PermissionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.allowed,
    required this.permanentlyDenied,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    String buttonText = permanentlyDenied ? tr("settings") : tr("allow");
    Color buttonColor = permanentlyDenied ? Colors.orange : scheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.l),
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: scheme.surfaceVariant.withOpacity(.35),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: scheme.outlineVariant.withOpacity(.25)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: scheme.primary),
          const SizedBox(width: AppSpacing.m),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          if (!allowed)
            TextButton(
              onPressed: onRequest,
              style: TextButton.styleFrom(foregroundColor: buttonColor),
              child: Text(buttonText),
            ),
        ],
      ),
    );
  }
}
