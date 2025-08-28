import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:tour_booking/features/phone_verification/verify_phone_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_status_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ekran açılır açılmaz kod gönder
    Future.microtask(() => context.read<VerifyPhoneViewModel>().sendCode());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VerifyPhoneViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Telefon Doğrulama")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "Telefonunuza gelen doğrulama kodunu giriniz:",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Pinput alanı
            Pinput(length: 6, controller: _codeController, showCursor: true),

            const SizedBox(height: 24),

            vm.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      final code = _codeController.text;
                      if (code.length < 6) return;

                      final success = await vm.verifyCode(code);
                      if (success && context.mounted) {
                        await context.read<ProfileViewModel>().fetchProfile();
                        context
                            .read<ProfileStatusViewModel>()
                            .setProfileComplete(true);
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(vm.message ?? "Başarıyla Doğrulandı"),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(vm.message ?? "Hata oluştu")),
                        );
                      }
                    },
                    child: const Text("Onayla"),
                  ),

            const SizedBox(height: 24),

            // Resend tuşu ve timer
            Text(
              vm.canResend
                  ? "Süre doldu, tekrar gönderebilirsiniz."
                  : "Tekrar gönderebilmek için: ${vm.remainingSeconds ~/ 60}:${(vm.remainingSeconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: vm.canResend ? () => vm.sendCode() : null,
              child: const Text("Tekrar Gönder"),
            ),
          ],
        ),
      ),
    );
  }
}
