import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/auth/change_password/change_password_viewmodel.dart';
import 'package:tour_booking/utils/password_validator.dart';
import 'package:flutter/material.dart' as ui;
import 'package:tour_booking/core/theme/app_theme_context.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isPasswordObscure = true;
  bool _isConfirmObscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) => PasswordValidator.validate(value);

  String? _validateConfirm(String? v) {
    if (v == null || v.trim().isEmpty) return 'password_required';
    if (v.trim() != _passwordController.text.trim()) {
      return 'passwords_do_not_match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChangePasswordViewModel>();
    final primaryColor = Theme.of(context).primaryColor;
    final scheme = context.colors;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: CommonAppBar(title: 'reset_password'.tr()),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordField(
                label: 'new_password'.tr(),
                controller: _passwordController,
                obscure: _isPasswordObscure,
                toggle: () =>
                    setState(() => _isPasswordObscure = !_isPasswordObscure),
                validator: (v) {
                  final key = _validatePassword(v);
                  if (key == null) return null;
                  return key.split('\n').map((e) => e.tr()).join('\n');
                },
                primaryColor: primaryColor,
              ),

              const SizedBox(height: AppSpacing.l),

              _buildPasswordField(
                label: 'confirm_password'.tr(),
                controller: _confirmController,
                obscure: _isConfirmObscure,
                toggle: () =>
                    setState(() => _isConfirmObscure = !_isConfirmObscure),
                validator: (v) => _validateConfirm(v)?.tr(),
                primaryColor: primaryColor,
              ),

              const SizedBox(height: AppSpacing.xxl),

              PrimaryButton(
                text: 'update_password'.tr(),
                isLoading: vm.isLoading,
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final result = await vm.changePassword(
                    _passwordController.text.trim(),
                  );

                  if (!mounted) return;

                  if (result.isSuccess) {
                    UIHelper.showSuccess(
                      context,
                      'password_updated_success'.tr(),
                    );
                    Navigator.of(context).pop();
                  } else {
                    UIHelper.showError(
                      context,
                      vm.message?.tr() ?? 'operation_failed'.tr(),
                    );
                  }
                },
              ),

              const SizedBox(height: AppSpacing.m),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
    required FormFieldValidator<String>? validator,
    required Color primaryColor,
  }) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,

        // ASCII-only enforcement (important)
        keyboardType: TextInputType.visiblePassword,
        inputFormatters: [PasswordValidator.passwordInputFormatter],
        style: TextStyle(
          color: context.colors.onSurface,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: primaryColor,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: context.ext.surfaceDark,
          labelStyle: AppTextStyles.labelLarge.copyWith(color: context.ext.textLight),
          prefixIcon: Icon(
            SolarIconsOutline.lock,
            color: context.ext.textLight,
            size: AppSpacing.xxl - 2,
            semanticLabel: 'Password',
          ),
          suffixIcon: IconButton(
            tooltip: 'Toggle password visibility',
            icon: Icon(
              obscure
                  ? SolarIconsOutline.eyeClosed
                  : SolarIconsOutline.eye,
              color: context.ext.textLight,
              semanticLabel: obscure ? 'Show password' : 'Hide password',
            ),
            onPressed: toggle,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppSpacing.l + 2,
            horizontal: AppSpacing.xl,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }
}
