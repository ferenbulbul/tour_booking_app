import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/auth/phone_verification/verify_phone_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_status_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<VerifyPhoneViewModel>().sendCode());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VerifyPhoneViewModel>();
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    // ⭐ PIN THEMES — ince, modern, premium
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
      appBar: CommonAppBar(title: 'phone_verification_title'.tr()),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'phone_verification_instruction'.tr(),
              style: text.bodyLarge?.copyWith(
                color: scheme.onSurface.withOpacity(0.75),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // ⭐ PREMIUM PIN INPUT
            Center(
              child: Pinput(
                length: 6,
                controller: _codeController,
                defaultPinTheme: defaultPin,
                focusedPinTheme: focusedPin,
                showCursor: true,
                cursor: Container(width: 2, height: 22, color: scheme.primary),
              ),
            ),

            const SizedBox(height: 32),

            // ⭐ ONAYLA BUTTON
            PrimaryButton(
              text: "Onayla",
              isLoading: vm.isLoading,
              onPressed: () async {
                final code = _codeController.text.trim();
                if (code.length < 6) {
                  UIHelper.showWarning(
                    context,
                    "Lütfen geçerli bir kod girin.",
                  );
                  return;
                }

                final ok = await vm.verifyCode(code);
                if (!mounted) return;

                if (ok) {
                  await context.read<ProfileViewModel>().fetchProfile();
                  context.read<ProfileStatusViewModel>().setProfileComplete(
                    true,
                  );

                  UIHelper.showSuccess(
                    context,
                    vm.message ?? 'phone_verification_success'.tr(),
                  );
                  context.pop();
                } else {
                  UIHelper.showError(
                    context,
                    vm.message ?? 'phone_verification_success'.tr(),
                  );
                }
              },
            ),

            const SizedBox(height: 28),

            // ⭐ TIMER TEXT + TIKLANABİLİR RESEND
            GestureDetector(
              onTap: vm.canResend ? vm.sendCode : null,
              child: Center(
                child: Text(
                  vm.canResend
                      ? 'resend_code'.tr()
                      : "${'resend_in_prefix'.tr()} "
                            "${vm.remainingSeconds ~/ 60}:${(vm.remainingSeconds % 60).toString().padLeft(2, '0')}",
                  style: text.bodyMedium?.copyWith(
                    color: vm.canResend
                        ? scheme.primary
                        : scheme.onSurface.withOpacity(0.6),
                    fontWeight: vm.canResend
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
