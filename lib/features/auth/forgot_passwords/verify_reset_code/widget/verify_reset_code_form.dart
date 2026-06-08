import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/core/widgets/pin_theme_helper.dart';
import 'package:tour_booking/features/auth/forgot_passwords/forgot_password_viewmodel.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class VerifyResetCodeForm extends StatefulWidget {
  final String email;
  const VerifyResetCodeForm({super.key, required this.email});

  @override
  State<VerifyResetCodeForm> createState() => _VerifyResetCodeFormState();
}

class _VerifyResetCodeFormState extends State<VerifyResetCodeForm> {
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ForgotPasswordViewModel>().startCooldown();
  }

  Future<void> _verify() async {
    final vm = context.read<ForgotPasswordViewModel>();
    final code = _codeController.text.trim();

    if (code.length != 6) {
      UIHelper.showError(context, tr("code_must_be_6_digits"));
      return;
    }

    final ok = await vm.verifyPasswordCode(widget.email, code);
    if (!mounted) return;

    if (ok.isSuccess) {
      context.go("/reset-password", extra: widget.email);
    } else {
      UIHelper.showError(context, vm.errorMessage ?? tr("unexpected_error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();
    final scheme = context.colors;
    final text = context.textStyles;

    final defaultPin = PinThemeHelper.defaultTheme(context);
    final focusedPin = PinThemeHelper.focusedTheme(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          tr("enter_code_instruction"),
          style: text.bodyLarge?.copyWith(
            color: scheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.xxxl - 4),

        Center(
          child: Pinput(
            length: 6,
            controller: _codeController,
            defaultPinTheme: defaultPin,
            focusedPinTheme: focusedPin,
            showCursor: true,
            cursor: PinThemeHelper.cursor(context),
            onCompleted: (_) => _verify(),
          ),
        ),

        const SizedBox(height: AppSpacing.xxxl),

        PrimaryButton(text: tr("verify"), onPressed: _verify),

        const SizedBox(height: AppSpacing.xxxl - 4),

        // TIMER & RESEND (no underline, TextButton style)
        Center(
          child: Semantics(
            button: true,
            label: 'Resend verification code',
            child: GestureDetector(
              onTap: vm.resendCooldown == 0
                  ? () => vm.resendResetCode(widget.email)
                  : null,
              child: Text(
                vm.resendCooldown == 0
                    ? tr("resend_code")
                    : "${tr("resend_in_prefix")} "
                          "${vm.resendCooldown ~/ 60}:"
                          "${(vm.resendCooldown % 60).toString().padLeft(2, '0')}",
                style: text.labelLarge?.copyWith(
                  color: vm.resendCooldown == 0
                      ? scheme.primary
                      : scheme.onSurface.withValues(alpha: 0.35),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
