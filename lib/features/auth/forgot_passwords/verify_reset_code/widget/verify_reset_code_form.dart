import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/features/auth/forgot_passwords/forgot_password/widget/forgot_password_view_model.dart';

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

    if (ok.isSuccess && mounted) {
      context.go("/reset-password", extra: widget.email);
    } else {
      UIHelper.showError(context, vm.errorMessage ?? tr("unexpected_error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    // 🔥 PREMIUM PIN THEME (ince yazı!)
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          tr("enter_code_instruction"),
          style: text.bodyLarge?.copyWith(
            color: scheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 28),

        Center(
          child: Pinput(
            length: 6,
            controller: _codeController,
            defaultPinTheme: defaultPin,
            focusedPinTheme: focusedPin,
            showCursor: true,
            cursor: Container(width: 2, height: 22, color: scheme.primary),
            onCompleted: (_) => _verify(),
          ),
        ),

        const SizedBox(height: 32),

        PrimaryButton(text: tr("verify"), onPressed: _verify),

        const SizedBox(height: 28),

        // 🔥 TIMER & RESEND (TextButton gibi, underline yok)
        Center(
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
                    : scheme.onSurface.withOpacity(0.35),
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
