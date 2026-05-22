import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/widgets/pin_theme_helper.dart';
import 'package:tour_booking/features/auth/phone_verification/verify_phone_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

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
    final scheme = context.colors;
    final text = context.textStyles;

    final defaultPin = PinThemeHelper.defaultTheme(context);
    final focusedPin = PinThemeHelper.focusedTheme(context);

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: CommonAppBar(title: tr('phone_verification_title')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Text(
              tr('phone_verification_instruction'),
              style: text.bodyLarge?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.75),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.xxxl),

            Pinput(
              length: 6,
              controller: _codeController,
              defaultPinTheme: defaultPin,
              focusedPinTheme: focusedPin,
              showCursor: true,
              cursor: PinThemeHelper.cursor(context, height: 20),
              keyboardType: TextInputType.number,
              onCompleted: (code) => _verify(vm, code),
            ),

            const SizedBox(height: AppSpacing.xxxl - 4),

            vm.canResend
                ? TextButton(
                    onPressed: vm.sendCode,
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
                    "${vm.remainingSeconds ~/ 60}:"
                    "${(vm.remainingSeconds % 60).toString().padLeft(2, '0')}",
                    style: text.bodyMedium?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _verify(VerifyPhoneViewModel vm, String code) async {
    if (code.length < 6) {
      UIHelper.showWarning(context, tr("enter_valid_code"));
      return;
    }

    final ok = await vm.verifyCode(code);
    if (!mounted) return;

    if (ok) {
      await context.read<ProfileViewModel>().fetchProfile();
      if (!mounted) return;

      UIHelper.showSuccess(
        context,
        vm.message ?? tr('phone_verification_success'),
      );
      // Also close the update-phone page
      context.pop();
      context.pop();
    } else {
      UIHelper.showError(
        context,
        vm.message ?? tr('phone_verification_failed'),
      );
    }
  }
}
