import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
    final vmAuth = context.watch<AuthViewModel>();

    if (vm.isLoading && vm.profile == null) {
      return ProfileSkeleton();
    }

    final p = vm.profile;
    if (p == null) {
      return const Scaffold(body: Center(child: Text("Profil bulunamadı")));
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // HEADER
            ProfileHeader(
              name: p.fullName,
              email: p.email,
              phoneVerified: p.phoneNumberConfirmed,
            ),

            const SizedBox(height: 30),

            // ------------------------------
            // HESAP AYARLARI
            // ------------------------------
            const ProfileSection(title: "Hesap Ayarları"),
            ProfileTile(
              icon: Icons.language_rounded,
              title: "Dil",
              trailingText: context.locale.languageCode == "tr"
                  ? "Türkçe"
                  : "English",
              onTap: () => context.push("/settings/language"),
            ),
            ProfileTile(
              icon: Icons.tune_rounded,
              title: "İzinler",
              subtitle: "Konum ve telefon doğrulamasını yönet",
              onTap: () => context.push("/settings/permissions"),
            ),

            const SizedBox(height: 30),

            // ------------------------------
            // GÜVENLİK
            // ------------------------------
            const ProfileSection(title: "Güvenlik"),
            ProfileTile(
              icon: Icons.lock_outline,
              title: "Şifre Değiştir",
              onTap: () {
                context.push('/change-password');
              },
            ),

            // ------------------------------
            // DİĞER
            // ------------------------------
            const ProfileSection(title: "Diğer"),
            ProfileTile(
              icon: Icons.delete_forever_rounded,
              title: "Hesabı Sil",
              titleColor: Colors.red.shade700,
              iconColor: Colors.red.shade700,
              onTap: () {
                // TODO: Hesap silme flow
              },
            ),
            ProfileTile(
              icon: Icons.logout,
              title: "Çıkış Yap",
              titleColor: Colors.red.shade700,
              iconColor: Colors.red.shade700,
              onTap: () {
                vmAuth.signOut();
                context.push("/login");
              },
            ),
          ],
        ),
      ),
    );
  }
}
