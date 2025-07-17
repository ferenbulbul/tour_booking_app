import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/features/email_verification/widget/email_verification_view_model.dart';

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

    final pinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('email_verification_title'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'enter_code_instruction'.tr(),
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            /// ✅ Kutucuklu kod giriş
            Pinput(
              length: 6,
              controller: _codeController,
              defaultPinTheme: pinTheme,
              keyboardType: TextInputType.number,
              onCompleted: (code) async {
                final result = await vm.verifyCode(code);
                if (result && mounted) {
                  context.go('/home');
                }
              },
            ),

            const SizedBox(height: 24),

            /// ✅ Alternatif doğrula butonu (isteğe bağlı)
            ElevatedButton(
              onPressed: () async {
                final code = _codeController.text.trim();
                if (code.length != 6) {
                  UIHelper.showError(context, 'code_must_be_6_digits'.tr());
                  return;
                }
                final result = await vm.verifyCode(code);
                if (result && mounted) {
                  context.go('/home');
                }
              },
              child: Text('verify'.tr()),
            ),

            const SizedBox(height: 24),

            /// ⏱ Geri sayım veya tekrar gönder
            if (vm.resendCooldown == 0)
              TextButton(
                onPressed: vm.resendCode,
                child: Text('resend_code'.tr()),
              )
            else
              Text(
                '${'resend_in_prefix'.tr()} ${vm.resendCooldown ~/ 60}:${(vm.resendCooldown % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
