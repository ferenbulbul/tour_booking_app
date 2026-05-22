import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/widgets/pin_theme_helper.dart';
import 'package:tour_booking/features/auth/email_verification/email_verification_viewmodel.dart';
import 'package:tour_booking/features/auth/login/widget/login_bottom_sheet.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

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
    final scheme = context.colors;
    final text = context.textStyles;

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

    final defaultPin = PinThemeHelper.defaultTheme(context);
    final focusedPin = PinThemeHelper.focusedTheme(context);

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: CommonAppBar(
        title: 'email_verification_title'.tr(),
        showBack: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Text(
              tr("enter_code_instruction"),
              style: text.bodyLarge?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.75),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.xxxl),

            // ⭐ PREMIUM PIN INPUT
            Pinput(
              length: 6,
              controller: _codeController,
              defaultPinTheme: defaultPin,
              focusedPinTheme: focusedPin,
              showCursor: true,
              cursor: PinThemeHelper.cursor(context, height: 20),
              keyboardType: TextInputType.number,
              onCompleted: (code) async {
                final ok = await vm.verifyCode(code);
                if (ok && mounted) {
                  // Update user data in SplashViewModel
                  // The guard will see "now confirmed" and auto-redirect to home
                  context.read<SplashViewModel>().updateEmailConfirmation(true);
                  context.go('/home');
                }
              },
            ),

            const SizedBox(height: AppSpacing.xxxl - 4),

            // ⭐ VERIFY BUTTON
            const SizedBox(height: AppSpacing.xl),

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
                      color: scheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),

            const SizedBox(height: AppSpacing.s),

            TextButton(
              onPressed: () async {
                final splashVM = context.read<SplashViewModel>();
                await splashVM.performFullSignOut();

                if (context.mounted) {
                  showLoginBottomSheet(context);
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
