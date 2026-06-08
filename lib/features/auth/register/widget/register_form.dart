import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';

import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/features/auth/register/register_viewmodel.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/models/register/register_request.dart';
import 'package:tour_booking/utils/password_validator.dart';
import 'package:flutter/material.dart' as ui;
import 'package:tour_booking/core/theme/app_theme_context.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool get _isPasswordValid => PasswordValidator.isValid(_passwordValue);

  final _formKey = GlobalKey<FormState>();
  String _passwordValue = "";
  bool _passwordTouched = false;
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _kvkkAccepted = false;
  bool _privacyAccepted = false;

  dynamic _selectedPhone;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_isPasswordValid) {
      setState(() => _passwordTouched = true);
      return;
    }
    if (_selectedPhone == null) {
      UIHelper.showError(context, tr("phone_required"));
      return;
    }
    if (!_kvkkAccepted || !_privacyAccepted) {
      UIHelper.showError(context, tr("terms_required"));
      return;
    }

    final vm = context.read<RegisterViewModel>();
    final splashVM = context.read<SplashViewModel>();
    FocusScope.of(context).unfocus();

    final req = RegisterRequest(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      email: _email.text.trim(),
      password: _password.text.trim(),
      phoneNumber: _selectedPhone.completeNumber,
      countryCode: _selectedPhone.countryCode,
      deviceId: null,
      deviceModel: null,
    );

    final result = await vm.register(req);

    if (!mounted) return;

    if (result.isSuccess && result.data != null) {
      UIHelper.showSuccess(context, tr("register_success"));

      // Push fresh data directly to the model instead of re-fetching from server.
      // This triggers notifyListeners() so GoRouter will navigate to /email-confirmed instantly.

      await splashVM.saveAuthData(result.data!);
      if (!mounted) return;
    } else {
      if (vm.validationErrors.isNotEmpty) {
        final message = vm.validationErrors.join('\n• ');
        UIHelper.showError(context, '• $message');
      } else if (vm.message != null) {
        UIHelper.showError(context, vm.message!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();
    final scheme = context.colors;
    final text = context.textStyles;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _input(
                  controller: _firstName,
                  label: tr("first_name"),
                  icon: SolarIconsOutline.user,
                  validator: (v) =>
                      v!.isEmpty ? tr("first_name_required") : null,
                ),
              ),
              const SizedBox(width: AppSpacing.l),
              Expanded(
                child: _input(
                  controller: _lastName,
                  label: tr("last_name"),
                  icon: SolarIconsOutline.user,
                  validator: (v) =>
                      v!.isEmpty ? tr("last_name_required") : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.l),

          _input(
            controller: _email,
            label: tr("email"),
            icon: SolarIconsOutline.letter,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return tr("email_required");
              final r = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
              if (!r.hasMatch(v)) return tr("email_invalid");
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.l),

          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: IntlPhoneField(
              invalidNumberMessage: tr("invalid_phone_number"),
              decoration: InputDecoration(labelText: tr("phone_number")),
              initialCountryCode: 'TR',
              style: text.bodyMedium,
              cursorColor: scheme.primary,
              onChanged: (p) => _selectedPhone = p,
              validator: (value) {
                if (value == null || value.number.isEmpty) {
                  return tr("phone_required");
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: AppSpacing.l),

          // PASSWORD
          _input(
            controller: _password,
            label: tr("password"),
            icon: SolarIconsOutline.lock,
            isPassword: true,
            isObscure: _obscurePassword,
            onToggle: () => setState(() {
              _obscurePassword = !_obscurePassword;
            }),
            validator: (v) {
              if (v == null || v.isEmpty) return tr("password_required");
              if (v.length < 8) return tr("password_too_short");
              return null;
            },
            onChanged: (v) {
              setState(() {
                _passwordValue = v;
                _passwordTouched = true;
              });
            },
          ),

          const SizedBox(height: AppSpacing.s),

          // PASSWORD RULES
          if (_passwordTouched) ...[PasswordRules(password: _passwordValue)],

          const SizedBox(height: AppSpacing.l),

          // CONFIRM PASSWORD
          _input(
            controller: _confirmPassword,
            label: tr("confirm_password"),
            icon: SolarIconsOutline.lock,
            isPassword: true,
            isObscure: _obscureConfirm,
            onToggle: () => setState(() {
              _obscureConfirm = !_obscureConfirm;
            }),
            validator: (v) {
              if (v != _password.text) return tr("passwords_do_not_match");
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.l),

          _legalCheckbox(
            value: _kvkkAccepted,
            label: tr("accept_kvkk"),
            onChanged: (v) => setState(() => _kvkkAccepted = v ?? false),
            onTap: () => context.push('/legal/kvkk'),
          ),

          const SizedBox(height: AppSpacing.xs),

          _legalCheckbox(
            value: _privacyAccepted,
            label: tr("accept_privacy"),
            onChanged: (v) => setState(() => _privacyAccepted = v ?? false),
            onTap: () => context.push('/legal/privacy-policy'),
          ),

          const SizedBox(height: AppSpacing.xl),

          PrimaryButton(
            text: tr("register"),
            isLoading: vm.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }

  Widget _legalCheckbox({
    required bool value,
    required String label,
    required ValueChanged<bool?> onChanged,
    required VoidCallback onTap,
  }) {
    final scheme = context.colors;

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: AppIconSize.xl - 2,
              height: AppIconSize.xl - 2,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: scheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                side: BorderSide(
                  color: scheme.onSurfaceVariant,
                  width: 1.5,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: AppSpacing.ms),
            Expanded(
              child: Semantics(
                button: true,
                label: 'View terms and conditions',
                child: GestureDetector(
                  onTap: onTap,
                  child: Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: scheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    ValueChanged<String>? onChanged,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onToggle,
    String? Function(String?)? validator,
  }) {
    final scheme = context.colors;
    final text = context.textStyles;

    final isLatinField =
        keyboardType == TextInputType.emailAddress || isPassword;

    return Directionality(
      textDirection: isLatinField
          ? ui.TextDirection.ltr
          : Directionality.of(context),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        keyboardType:
            keyboardType ??
            (isPassword ? TextInputType.visiblePassword : TextInputType.text),
        validator: validator,
        obscureText: isPassword ? isObscure : false,
        textAlign: isLatinField ? TextAlign.left : TextAlign.start,
        style: text.bodyMedium,
        cursorColor: scheme.primary,
        inputFormatters: isPassword
            ? [PasswordValidator.passwordInputFormatter]
            : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: scheme.onSurfaceVariant),
          suffixIcon: isPassword
              ? IconButton(
                  tooltip: 'Toggle password visibility',
                  icon: Icon(
                    isObscure
                        ? SolarIconsOutline.eyeClosed
                        : SolarIconsOutline.eye,
                    color: scheme.onSurfaceVariant,
                    semanticLabel: isObscure ? 'Show password' : 'Hide password',
                  ),
                  onPressed: onToggle,
                )
              : null,
        ),
      ),
    );
  }
}

