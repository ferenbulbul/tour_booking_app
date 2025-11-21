import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';

class UpdatePhoneScreen extends StatefulWidget {
  const UpdatePhoneScreen({super.key});

  @override
  State<UpdatePhoneScreen> createState() => _UpdatePhoneScreenState();
}

class _UpdatePhoneScreenState extends State<UpdatePhoneScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final profile = vm.profile;

    if (profile == null) {
      return const Scaffold(body: Center(child: Text("Profil bulunamadı")));
    }

    controller.text = profile.phoneNumber;

    return Scaffold(
      appBar: AppBar(title: const Text("Telefon Numarasını Güncelle")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Yeni Telefon Numarası",
                hintText: "+90...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final newNumber = controller.text.trim();

                  if (newNumber.isEmpty) return;

                  await vm.updatePhoneNumber(newNumber);

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        vm.message ?? "Telefon numaran güncellendi",
                      ),
                    ),
                  );

                  Navigator.of(context).pop(); // geri dön
                },
                child: const Text("Kaydet"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
