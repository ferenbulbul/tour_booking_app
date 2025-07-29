import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/features/forgot_passwords/forgot_password/widget/forgot_password_view_model.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _emailController = TextEditingController();

  Future<void> _submit() async {
    final vm = context.read<ForgotPasswordViewModel>();
    final email = _emailController.text.trim();

    final result = await vm.forgotPassword(email);

    if (result.isSuccess) {
      UIHelper.showSuccess(context, vm.message ?? 'Kod gönderildi');
      context.push('/verify-reset-code', extra: email);
    } else {
      UIHelper.showError(context, vm.errorMessage ?? 'Bir hata oluştu');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'E-posta'),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.sectionSpacing),
        vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: _submit,
                child: const Text('Kodu Gönder'),
              ),
      ],
    );
  }
}
