import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/profile/profile_status_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/features/profile/widget/language_select.dart';
import 'package:tour_booking/features/profile/widget/sign_out.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // initState içinde read kullanmak daha güvenlidir.
    Future.microtask(() => context.read<ProfileViewModel>().fetchProfile());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text("Profilim")),
      body: _buildBody(context, vm, textTheme),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProfileViewModel vm,
    TextTheme textTheme,
  ) {
    if (vm.isLoading && vm.profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.message != null && vm.profile == null) {
      return Center(child: Text("Hata: ${vm.message}"));
    }

    final profile = vm.profile;
    if (profile == null) {
      return const Center(child: Text("Profil bulunamadı"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProfileHeader(context, profile, textTheme),
          const SizedBox(height: 5),
          _buildSettingsSection(context, textTheme),
          const SizedBox(height: 5),
          _buildPhoneSection(context, profile, vm, textTheme),
          const SizedBox(height: 5),
          _buildPastOrdersButton(context),
          const SignOut(),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, TextTheme textTheme) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const LanguageSelector()],
        ),
      ),
    );
  }

  Widget _buildPastOrdersButton(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: FilledButton.icon(
          onPressed: () => context.push("/past-bookings"), // henüz tanımlamadık
          icon: const Icon(Icons.history, size: 20),
          label: const Text("Turlarım"),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    dynamic profile,
    TextTheme textTheme,
  ) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              profile.fullName,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              profile.email,
              style: textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneSection(
    BuildContext context,
    dynamic profile,
    ProfileViewModel vm,
    TextTheme textTheme,
  ) {
    final bool phoneConfirmed = profile.phoneNumberConfirmed;

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("İletişim Bilgileri", style: textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => _showEditDialog(context, vm),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text("Telefon: ${profile.phoneNumber}", style: textTheme.bodyLarge),
            const SizedBox(height: 12),
            _buildVerificationBadge(phoneConfirmed, textTheme),
            if (!phoneConfirmed) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: () => context.push("/verify-phone"),
                  icon: const Icon(Icons.phone_android),
                  label: const Text("Numarayı Şimdi Doğrula"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Doğrulama durumunu gösteren rozet (badge) widget'ı
  Widget _buildVerificationBadge(bool isVerified, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isVerified ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isVerified ? Colors.green.shade200 : Colors.orange.shade200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.verified_user : Icons.warning_amber_rounded,
            color: isVerified ? Colors.green.shade700 : Colors.orange.shade800,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            isVerified ? "Doğrulandı" : "Doğrulanmadı",
            style: textTheme.bodySmall?.copyWith(
              color: isVerified
                  ? Colors.green.shade800
                  : Colors.orange.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, ProfileViewModel vm) {
    final initialPhoneNumber = vm.profile?.phoneNumber ?? "";
    final controller = TextEditingController(text: initialPhoneNumber);

    // StatefulBuilder, dialog içindeki state'i yönetmek için harika bir yoldur.
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isButtonEnabled =
                controller.text.isNotEmpty &&
                controller.text != initialPhoneNumber;

            // Buton durumunu her metin değişikliğinde kontrol etmek için listener ekle
            void listener() {
              setState(() {
                isButtonEnabled =
                    controller.text.isNotEmpty &&
                    controller.text != initialPhoneNumber;
              });
            }

            controller.addListener(listener);

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text("Telefon Numarasını Düzenle"),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: "Yeni Telefon Numarası",
                ),
                keyboardType: TextInputType.phone,
                autofocus: true,
              ),
              actions: [
                TextButton(
                  child: const Text("İptal"),
                  onPressed: () {
                    controller.removeListener(listener);
                    Navigator.pop(dialogContext);
                  },
                ),
                FilledButton(
                  onPressed: isButtonEnabled
                      ? () async {
                          // Listener'ı kaldırmak iyi bir pratiktir.
                          controller.removeListener(listener);
                          context
                              .read<ProfileStatusViewModel>()
                              .setProfileComplete(false);
                          await vm.updatePhoneNumber(controller.text);
                          if (context.mounted) Navigator.pop(dialogContext);
                        }
                      : null, // Buton pasifse null ata
                  child: vm.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Kaydet"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
