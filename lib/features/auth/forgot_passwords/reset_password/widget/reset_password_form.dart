import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/features/auth/forgot_passwords/forgot_password_viewmodel.dart';
import 'package:tour_booking/utils/password_validator.dart';
import 'package:flutter/material.dart' as ui;
import 'package:tour_booking/core/theme/app_theme_context.dart';

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

  String? _validatePassword(String? value) =>
      PasswordValidator.validateTranslated(value);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();
    final scheme = context.colors;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // New Password
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: TextFormField(
              controller: _newPasswordController,
              obscureText: _obscure1,
              validator: _validatePassword,
              keyboardType: TextInputType.visiblePassword,
              inputFormatters: [PasswordValidator.passwordInputFormatter],
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                labelText: tr("password"),
                prefixIcon: Icon(
                  SolarIconsOutline.lock,
                  color: scheme.onSurfaceVariant,
                  semanticLabel: 'Password',
                ),
                suffixIcon: IconButton(
                  tooltip: 'Toggle password visibility',
                  icon: Icon(
                    _obscure1 ? SolarIconsOutline.eyeClosed : SolarIconsOutline.eye,
                    color: scheme.onSurfaceVariant,
                    semanticLabel: _obscure1 ? 'Show password' : 'Hide password',
                  ),
                  onPressed: () => setState(() => _obscure1 = !_obscure1),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.l),

          // Confirm Password
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscure2,
              validator: (v) => v == _newPasswordController.text
                  ? null
                  : tr("passwords_do_not_match"),
              keyboardType: TextInputType.visiblePassword,
              inputFormatters: [PasswordValidator.passwordInputFormatter],
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                labelText: tr("confirm_password"),
                prefixIcon: Icon(
                  SolarIconsOutline.lock,
                  color: scheme.onSurfaceVariant,
                  semanticLabel: 'Confirm password',
                ),
                suffixIcon: IconButton(
                  tooltip: 'Toggle password visibility',
                  icon: Icon(
                    _obscure2 ? SolarIconsOutline.eyeClosed : SolarIconsOutline.eye,
                    color: scheme.onSurfaceVariant,
                    semanticLabel: _obscure2 ? 'Show password' : 'Hide password',
                  ),
                  onPressed: () => setState(() => _obscure2 = !_obscure2),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

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
                      context.go("/home");
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
