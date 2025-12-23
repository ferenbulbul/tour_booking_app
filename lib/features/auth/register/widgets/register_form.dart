import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/features/auth/register/widgets/register_view_model.dart';
import 'package:tour_booking/models/register/register_request.dart';
import 'package:flutter/material.dart' as ui;

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

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

    if (_selectedPhone == null) {
      UIHelper.showError(context, tr("phone_required"));
      return;
    }

    final vm = context.read<RegisterViewModel>();
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

    if (result.isSuccess) {
      UIHelper.showSuccess(context, tr("register_success"));
      context.go("/email-confirmed");
    } else {
      if (vm.message != null) UIHelper.showError(context, vm.message!);
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
          // First + Last name
          Row(
            children: [
              Expanded(
                child: _input(
                  controller: _firstName,
                  label: tr("first_name"),
                  icon: Icons.person_outline,
                  validator: (v) => v!.isEmpty ? tr("required") : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _input(
                  controller: _lastName,
                  label: tr("last_name"),
                  icon: Icons.person_outline,
                  validator: (v) => v!.isEmpty ? tr("required") : null,
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

          // Phone Number
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
          ),

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
        keyboardType:
            keyboardType ??
            (isPassword ? TextInputType.visiblePassword : TextInputType.text),
        validator: validator,
        obscureText: isPassword ? isObscure : false,
        textAlign: isLatinField ? TextAlign.left : TextAlign.start,
        style: text.bodyMedium,
        cursorColor: scheme.primary,

        // 🔒 Password için ASCII zorunlu
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
