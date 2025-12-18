import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/features/auth/login/widgets/google_view_model.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/features/profile/widget/profil_header.dart';
import 'package:tour_booking/features/profile/widget/profile_section.dart';
import 'package:tour_booking/features/profile/widget/profile_skleton.dart';
import 'package:tour_booking/features/profile/widget/profile_title.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProfileViewModel>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final authVm = context.watch<AuthViewModel>();
    final scheme = Theme.of(context).colorScheme;

    if (vm.isLoading && vm.profile == null) {
      return const ProfileSkeleton();
    }

    final p = vm.profile;
    if (p == null) {
      return Scaffold(body: Center(child: Text(tr("profile_not_found"))));
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            // HEADER
            ProfileHeader(
              name: p.fullName,
              email: p.email,
              phoneVerified: p.phoneNumberConfirmed,
            ),

            const SizedBox(height: AppSpacing.xl),

            // HESAP AYARLARI
            ProfileSection(title: tr("account_settings")),

            ProfileTile(
              icon: Icons.language_rounded,
              title: tr("language"),
              trailingText: context.locale.languageCode == "tr"
                  ? "Türkçe"
                  : "English",
              onTap: () => context.push("/settings/language"),
            ),

            ProfileTile(
              icon: Icons.tune_rounded,
              title: tr("permissions"),
              subtitle: tr("manage_location_and_phone_verification"),
              onTap: () => context.push("/settings/permissions"),
            ),

            const SizedBox(height: AppSpacing.xl),

            // GÜVENLİK
            ProfileSection(title: tr("security")),

            ProfileTile(
              icon: Icons.lock_outline,
              title: tr("change_password"),
              onTap: () => context.push('/change-password'),
            ),

            const SizedBox(height: AppSpacing.xl),

            // DİĞER
            ProfileSection(title: tr("other")),

            ProfileTile(
              icon: Icons.delete_forever_rounded,
              title: tr("delete_account"),
              titleColor: AppColors.error,
              iconColor: AppColors.error,
              onTap: () {
                // TODO hesap silme flow
              },
            ),

            ProfileTile(
              icon: Icons.logout_rounded,
              title: tr("logout"),
              titleColor: AppColors.error,
              iconColor: AppColors.error,
              onTap: () {
                authVm.signOut();
                context.go("/login");
              },
            ),
          ],
        ),
      ),
    );
  }
}
