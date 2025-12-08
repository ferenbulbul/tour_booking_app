import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
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

  // 🔥 Uygulama ayarlardan dönünce burada tetiklenir
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // sayfa tekrar ekrana geldi → izinleri tazele
      context.read<PermissionsViewModel>().loadPermissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileVm = context.watch<ProfileViewModel>();
    final permVm = context.watch<PermissionsViewModel>();

    final profile = profileVm.profile;
    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "İzinler",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 14),

          _PhoneCard(profile: profile),
          const SizedBox(height: 24),

          _LocationPermissionRow(vm: permVm),
        ],
      ),
    );
  }
}

class _PhoneCard extends StatelessWidget {
  final ProfileResponse profile;

  const _PhoneCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final hasPhone = profile.phoneNumber.isNotEmpty;
    final verified = profile.phoneNumberConfirmed;

    final badgeColor = !hasPhone
        ? Colors.orange
        : verified
        ? Colors.green
        : Colors.orange;

    final badgeText = !hasPhone
        ? "Girilmedi"
        : verified
        ? "Doğrulandı"
        : "Doğrulanmadı";

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.phone_iphone_rounded,
            size: 28,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasPhone
                      ? "Telefon Numarası"
                      : "Telefon Numarası (Girilmedi)",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  hasPhone ? profile.phoneNumber : "—",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  hasPhone
                      ? (verified
                            ? "Bu numara rezervasyon hatırlatmaları için kullanılacaktır."
                            : "Numaran yanlış olabilir. Doğrulamadan önce güncelleyebilirsin.")
                      : "Lütfen telefon numarası ekleyin.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: 11,
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
                child: Text(hasPhone ? "Güncelle" : "Ekle"),
              ),
              if (hasPhone && !verified)
                TextButton(
                  onPressed: () => context.push("/verify-phone"),
                  child: const Text("Doğrula"),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------
//  🔥 Bildirim izni satırı
// ------------------------------------------------------

// ------------------------------------------------------
//  🔥 Konum izni satırı
// ------------------------------------------------------

class _LocationPermissionRow extends StatelessWidget {
  final PermissionsViewModel vm;

  const _LocationPermissionRow({required this.vm});

  @override
  Widget build(BuildContext context) {
    final allowed = vm.locationAllowed;
    final permanentlyDenied = vm.locationPermanentlyDenied;

    return _PermissionRow(
      icon: Icons.location_on_outlined,
      title: "Konum",
      subtitle: "Konuma göre öneriler sunabilmek için gerekli",
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
//  🔥 Tekli satır component
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
    // buton metni ve rengi
    String buttonText = permanentlyDenied ? "Ayarlar" : "Aç";
    Color buttonColor = permanentlyDenied ? Colors.orange : AppColors.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 26, color: AppColors.primary),
        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

        // 🔥 Açık ise buton YOK
        if (!allowed)
          TextButton(
            onPressed: onRequest,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              foregroundColor: buttonColor,
            ),
            child: Text(buttonText),
          ),
      ],
    );
  }
}
