import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tour_booking/features/auth/forgot_passwords/forgot_password/widget/forgot_password_view_model.dart';

class ResetPasswordForm extends StatefulWidget {
  final String email;
  const ResetPasswordForm({super.key, required this.email});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return tr("password_required");
    if (value.length < 9) return tr("password_too_short");

    final upper = RegExp(r'[A-Z]');
    final lower = RegExp(r'[a-z]');
    final digit = RegExp(r'\d');
    final special = RegExp(r'[^A-Za-z0-9]');

    final errors = <String>[];
    if (!upper.hasMatch(value)) errors.add(tr("password_must_include_upper"));
    if (!lower.hasMatch(value)) errors.add(tr("password_must_include_lower"));
    if (!digit.hasMatch(value)) errors.add(tr("password_must_include_digit"));
    if (!special.hasMatch(value))
      errors.add(tr("password_must_include_special"));

    return errors.isEmpty ? null : errors.join("\n");
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: tr("password")),
            validator: _validatePassword,
          ),
          const SizedBox(height: AppSpacing.elementSpacing),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: tr("confirm_password")),
            validator: (value) {
              if (value != _newPasswordController.text) {
                return tr("passwords_do_not_match");
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.sectionSpacing),
          vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final result = await vm.resetPassword(
                      widget.email,
                      _newPasswordController.text.trim(),
                    );

                    if (result.isSuccess) {
                      UIHelper.showSuccess(context, vm.message!);
                      context.go('/login');
                    } else {
                      UIHelper.showError(context, vm.message!);
                    }
                  },
                  child: Text(tr("reset_password")),
                ),
        ],
      ),
    );
  }
}
