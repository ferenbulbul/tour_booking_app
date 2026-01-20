import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';

import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/features/auth/register/widgets/register_view_model.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/models/register/register_request.dart';
import 'package:flutter/material.dart' as ui;

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool get _isPasswordValid {
    final v = _passwordValue;

    return v.length >= 9 &&
        RegExp(r'[A-Z]').hasMatch(v) &&
        RegExp(r'[a-z]').hasMatch(v) &&
        RegExp(r'\d').hasMatch(v) &&
        RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]{};:"\\|,.<>\/\?]').hasMatch(v);
  }

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
    if (!_formKey.currentState!.validate()) return;
    if (!_isPasswordValid) {
      setState(() => _passwordTouched = true);
      return;
    }
    if (_selectedPhone == null) {
      UIHelper.showError(context, tr("phone_required"));
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

      // 🔥 ESKİ HALİ: await splashVM.initializeApp(); (İnternete gidiyordu)

      // ✅ YENİ HALİ: Elimizdeki taze veriyi direkt modele basıyoruz.
      // Bu metod notifyListeners() tetiklediği için GoRouter anında /email-confirmed sayfasına uçuracak.

      await splashVM.saveAuthData(result.data!);
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
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

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
                  icon: Icons.person_outline,
                  validator: (v) =>
                      v!.isEmpty ? tr("first_name_required") : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _input(
                  controller: _lastName,
                  label: tr("last_name"),
                  icon: Icons.person_outline,
                  validator: (v) =>
                      v!.isEmpty ? tr("last_name_required") : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _input(
            controller: _email,
            label: tr("email"),
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return tr("email_required");
              final r = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
              if (!r.hasMatch(v)) return tr("email_invalid");
              return null;
            },
          ),

          const SizedBox(height: 16),

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

          const SizedBox(height: 16),

          // PASSWORD
          _input(
            controller: _password,
            label: tr("password"),
            icon: Icons.lock_outline,
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

          const SizedBox(height: 8),

          // 🔐 PASSWORD RULES (YENİ EKLENEN)
          if (_passwordTouched) ...[_PasswordRules(password: _passwordValue)],

          const SizedBox(height: 16),

          // CONFIRM PASSWORD
          _input(
            controller: _confirmPassword,
            label: tr("confirm_password"),
            icon: Icons.lock_outline,
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

          const SizedBox(height: 24),

          PrimaryButton(
            text: tr("register"),
            isLoading: vm.isLoading,
            onPressed: _submit,
          ),
        ],
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
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

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
            ? [
                FilteringTextInputFormatter.allow(
                  RegExp(
                    r'[A-Za-z0-9!@#\$%\^&\*\(\)_\+\-=\[\]{};:"\\|,.<>\/?]',
                  ),
                ),
              ]
            : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: scheme.onSurfaceVariant),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: scheme.onSurfaceVariant,
                  ),
                  onPressed: onToggle,
                )
              : null,
        ),
      ),
    );
  }
}

class _PasswordRules extends StatelessWidget {
  final String password;
  const _PasswordRules({required this.password});

  Widget _item(bool ok, String text) {
    return Row(
      children: [
        Icon(
          ok ? Icons.check_circle : Icons.cancel,
          size: 16,
          color: ok ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: ok ? Colors.green : Colors.red),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _item(password.length >= 9, tr("password_too_short")),
        _item(
          RegExp(r'[A-Z]').hasMatch(password),
          tr("password_must_include_upper"),
        ),
        _item(
          RegExp(r'[a-z]').hasMatch(password),
          tr("password_must_include_lower"),
        ),
        _item(
          RegExp(r'\d').hasMatch(password),
          tr("password_must_include_digit"),
        ),
        _item(
          RegExp(
            r'[!@#\$%\^&\*\(\)_\+\-=\[\]{};:"\\|,.<>\/\?]',
          ).hasMatch(password),
          tr("password_must_include_special"),
        ),
      ],
    );
  }
}
