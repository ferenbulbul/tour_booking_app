import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/features/auth/login/widgets/google_view_model.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/features/profile/widget/profil_header.dart';
import 'package:tour_booking/features/profile/widget/profile_section.dart';
import 'package:tour_booking/features/profile/widget/profile_skleton.dart';
import 'package:tour_booking/features/profile/widget/profile_title.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';

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

    return Stack(
      children: [
        Scaffold(
          backgroundColor: scheme.surface,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                ProfileHeader(
                  name: p.fullName,
                  email: p.email,
                  phoneVerified: p.phoneNumberConfirmed,
                ),

                const SizedBox(height: AppSpacing.xl),

                ProfileSection(title: tr("account_settings")),

                ProfileTile(
                  icon: Icons.language_rounded,
                  title: tr("language"),
                  trailingText: getLanguageName(context),
                  onTap: () => context.push("/settings/language"),
                ),

                ProfileTile(
                  icon: Icons.tune_rounded,
                  title: tr("permissions"),
                  subtitle: tr("manage_location_and_phone_verification"),
                  onTap: () => context.push("/settings/permissions"),
                ),

                const SizedBox(height: AppSpacing.xl),

                ProfileSection(title: tr("security")),

                ProfileTile(
                  icon: Icons.lock_outline,
                  title: tr("change_password"),
                  onTap: () => context.push('/change-password'),
                ),

                const SizedBox(height: AppSpacing.xl),

                ProfileSection(title: tr("other")),

                ProfileTile(
                  icon: Icons.delete_forever_rounded,
                  title: tr("delete_account"),
                  titleColor: AppColors.error,
                  iconColor: AppColors.error,
                  onTap: () => _showDeleteAccountDialog(context),
                ),

                ProfileTile(
                  icon: Icons.logout_rounded,
                  title: tr("logout"),
                  titleColor: AppColors.error,
                  iconColor: AppColors.error,
                  onTap: () async {
                    // 1. Servislerden çıkış yap (Tokenları siler)
                    await authVm.signOut();

                    // 2. SplashViewModel'i uyandır (Yeni yazdığın fonksiyonu çalıştırır)
                    // Bu fonksiyon token'ın silindiğini görecek ve _isLoggedIn = false yapacak.
                    await context.read<SplashViewModel>().initializeApp();

                    // 3. context.go("/login") DEMENE GEREK YOK!
                    // initializeApp bitince GoRouter bekçisi durumu anlayıp seni kapı dışarı edecek.
                  },
                ),
              ],
            ),
          ),
        ),

        // 🔒 FULLSCREEN LOADING
        if (vm.isLoading)
          Container(
            color: Colors.black.withOpacity(0.35),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final profileVm = context.read<ProfileViewModel>();
    final authVm = context.read<AuthViewModel>();
    final splashVm = context.read<SplashViewModel>(); // 🔥 Bunu ekledik

    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ICON (Tasarımın aynı kalıyor)
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  size: 28,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 14),
              // TITLE
              Text(
                tr("delete_account"),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              // MESSAGE
              Text(tr("delete_account_warning"), textAlign: TextAlign.center),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(true),
                      child: Text(tr("common_yes")),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(false),
                      child: Text(tr("common_cancel")),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).then((confirmed) async {
      if (confirmed != true) return;

      // 1. Backend tarafında hesabı sil
      final success = await profileVm.deleteAccount();

      if (!context.mounted) return;

      // Mesaj yönetimi
      final msg = profileVm.message ?? tr("error_generic");
      if (success) {
        UIHelper.showSuccess(context, msg.tr());

        // 2. 🔥 KRİTİK: Lokal verileri ve Firebase oturumunu temizle
        // Az önce AuthViewModel'de yazdığımız fonksiyonu çağırıyoruz
        await authVm.deleteAccount();

        // 3. 🔥 Router bekçisini uyandır.
        // Tokenlar silindiği için otomatik olarak /login sayfasına fırlatılacaksın.
        await splashVm.initializeApp();
      } else {
        UIHelper.showError(context, msg.tr());
      }
    });
  }
}

String getLanguageName(BuildContext context) {
  switch (context.locale.languageCode) {
    case 'tr':
      return 'Türkçe';
    case 'en':
      return 'English';
    case 'ar':
      return 'العربية';
    default:
      return 'English';
  }
}
