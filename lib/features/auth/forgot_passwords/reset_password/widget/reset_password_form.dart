import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
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

  bool _obscure1 = true;
  bool _obscure2 = true;

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
    final scheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // New Password
          TextFormField(
            controller: _newPasswordController,
            obscureText: _obscure1,
            validator: _validatePassword,
            decoration: InputDecoration(
              labelText: tr("password"),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: scheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure1 ? Icons.visibility_off : Icons.visibility,
                  color: scheme.onSurfaceVariant,
                ),
                onPressed: () => setState(() => _obscure1 = !_obscure1),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Confirm Password
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscure2,
            validator: (v) => v == _newPasswordController.text
                ? null
                : tr("passwords_do_not_match"),
            decoration: InputDecoration(
              labelText: tr("confirm_password"),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: scheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure2 ? Icons.visibility_off : Icons.visibility,
                  color: scheme.onSurfaceVariant,
                ),
                onPressed: () => setState(() => _obscure2 = !_obscure2),
              ),
            ),
          ),

          const SizedBox(height: 24),

          vm.isLoading
              ? const CircularProgressIndicator()
              : PrimaryButton(
                  text: tr("reset_password"),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final result = await vm.resetPassword(
                      widget.email,
                      _newPasswordController.text.trim(),
                    );

                    if (result.isSuccess) {
                      UIHelper.showSuccess(
                        context,
                        tr("password_reset_success"),
                      );
                      context.go("/login");
                    } else {
                      UIHelper.showError(
                        context,
                        vm.message ?? tr("unexpected_error"),
                      );
                    }
                  },
                ),
        ],
      ),
    );
  }
}
