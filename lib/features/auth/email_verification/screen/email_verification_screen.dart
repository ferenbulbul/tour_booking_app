import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import 'package:provider/provider.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/auth/email_verification/widget/email_verification_view_model.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final vm = context.read<EmailVerificationViewModel>();
      await vm.initializeVerification();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EmailVerificationViewModel>();
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm.message != null) {
        UIHelper.showSuccess(context, vm.message!);
        vm.clearMessages();
      }
      if (vm.errorMessage != null) {
        UIHelper.showError(context, vm.errorMessage!);
        vm.clearMessages();
      }
    });

    // ⭐ PIN THEMES — Aynı VerifyPhoneScreen
    final defaultPin = PinTheme(
      width: 52,
      height: 56,
      textStyle: text.titleLarge?.copyWith(
        fontWeight: FontWeight.w400, // İNCE yazı
        fontSize: 20,
        color: scheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outline.withOpacity(1)),
      ),
    );

    final focusedPin = defaultPin.copyWith(
      textStyle: text.titleLarge?.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 20,
        color: scheme.primary,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.primary, width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: CommonAppBar(
        title: 'email_verification_title'.tr(),
        showBack: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              tr("enter_code_instruction"),
              style: text.bodyLarge?.copyWith(
                color: scheme.onSurface.withOpacity(0.75),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // ⭐ PREMIUM PIN INPUT
            Pinput(
              length: 6,
              controller: _codeController,
              defaultPinTheme: defaultPin,
              focusedPinTheme: focusedPin,
              showCursor: true,
              cursor: Container(width: 2, height: 20, color: scheme.primary),
              keyboardType: TextInputType.number,
              onCompleted: (code) async {
                final ok = await vm.verifyCode(code);
                if (ok && mounted) {
                  // 🔥 SplashViewModel'deki kullanıcı verisini güncelle
                  // Böylece bekçi "Tamam artık onaylı" deyip seni otomatik içeri alacak
                  context.read<SplashViewModel>().updateEmailConfirmation(true);
                  context.go('/home');
                }
              },
            ),

            const SizedBox(height: 28),

            // ⭐ VERIFY BUTTON
            const SizedBox(height: 20),

            // ⭐ RESEND SECTION
            vm.resendCooldown == 0
                ? TextButton(
                    onPressed: vm.resendCode,
                    child: Text(
                      tr("resend_code"),
                      style: text.labelLarge?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Text(
                    "${tr("resend_in_prefix")} "
                    "${vm.resendCooldown ~/ 60}:"
                    "${(vm.resendCooldown % 60).toString().padLeft(2, '0')}",
                    style: text.bodyMedium?.copyWith(
                      color: scheme.onSurface.withOpacity(0.6),
                    ),
                  ),

            const SizedBox(height: 8),

            TextButton(
              onPressed: () async {
                // 1. SplashViewModel üzerinden oturumu temizle
                // Not: SplashViewModel'de signOut veya clearAuth gibi bir metodun olduğunu varsayıyorum
                final splashVM = context.read<SplashViewModel>();

                // Auth verilerini temizle ki bekçi (isLoggedIn) artık false dönsün
                await splashVM
                    .signOut(); // veya tokenStorage.clearTokens() + notifyListeners()

                // 2. Şimdi login'e gidebiliriz, bekçi artık engel olmaz
                if (context.mounted) {
                  context.go('/login');
                }
              },
              child: Text(
                'back_to_login'.tr(),
                style: text.labelLarge?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
