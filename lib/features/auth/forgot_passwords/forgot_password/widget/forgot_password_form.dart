import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/features/auth/forgot_passwords/forgot_password/widget/forgot_password_view_model.dart';
import 'package:flutter/material.dart' as ui;

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<ForgotPasswordViewModel>();
    final email = _emailController.text.trim();

    final result = await vm.forgotPassword(email);

    if (!mounted) return;

    if (result.isSuccess) {
      UIHelper.showSuccess(context, vm.message ?? tr("success"));
      context.push('/verify-reset-code', extra: email);
    } else {
      UIHelper.showError(context, vm.errorMessage ?? tr("error_occurred"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: tr("email")),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return tr("email_required");
                }
                final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                if (!emailRegex.hasMatch(value.trim())) {
                  return tr("email_invalid");
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: 24),

          PrimaryButton(
            text: tr("send_code"),
            isLoading: vm.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
