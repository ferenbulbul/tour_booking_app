import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/features/forgot_passwords/forgot_password/widget/forgot_password_view_model.dart';

class VerifyResetCodeForm extends StatefulWidget {
  final String email;
  const VerifyResetCodeForm({super.key, required this.email});

  @override
  State<VerifyResetCodeForm> createState() => _VerifyResetCodeFormState();
}

class _VerifyResetCodeFormState extends State<VerifyResetCodeForm> {
  final _codeController = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    context.read<ForgotPasswordViewModel>().startCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    final vm = context.read<ForgotPasswordViewModel>();
    final code = _codeController.text.trim();

    if (code.length != 6) {
      UIHelper.showError(context, 'Kod 6 haneli olmalıdır');
      return;
    }

    final result = await vm.verifyPasswordCode(widget.email, code);

    if (result.isSuccess) {
      context.go('/reset-password', extra: widget.email);
    } else {
      UIHelper.showError(
        context,
        vm.errorMessage ?? 'Kod doğrulama başarısız.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();

    final pinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Column(
      children: [
        const Text(
          'Lütfen e-postanıza gelen 6 haneli kodu girin.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 32),

        /// ✅ Pinput
        Pinput(
          length: 6,
          controller: _codeController,
          defaultPinTheme: pinTheme,
          keyboardType: TextInputType.number,
          onCompleted: (_) => _verifyCode(),
        ),

        const SizedBox(height: 24),

        ElevatedButton(onPressed: _verifyCode, child: const Text('Doğrula')),

        const SizedBox(height: 24),

        /// ⏱ Geri sayım veya tekrar gönder
        vm.resendCooldown == 0
            ? TextButton(
                onPressed: () {
                  vm.resendResetCode(widget.email);
                },
                child: const Text("Yeniden Gönder"),
              )
            : Text(
                "Yeniden gönderilebilir: ${vm.resendCooldown ~/ 60}:${(vm.resendCooldown % 60).toString().padLeft(2, '0')}",
                style: const TextStyle(color: Colors.grey),
              ),
      ],
    );
  }
}
