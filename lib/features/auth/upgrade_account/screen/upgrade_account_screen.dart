import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/auth/upgrade_account/upgrade_account_viewmodel.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/utils/password_validator.dart';
import 'package:flutter/material.dart' as ui;

class UpgradeAccountScreen extends StatefulWidget {
  const UpgradeAccountScreen({super.key});

  @override
  State<UpgradeAccountScreen> createState() => _UpgradeAccountScreenState();
}

class _UpgradeAccountScreenState extends State<UpgradeAccountScreen> {
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

  bool get _isPasswordValid => PasswordValidator.isValid(_passwordValue);

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

    final vm = context.read<UpgradeAccountViewModel>();
    final splashVM = context.read<SplashViewModel>();
    FocusScope.of(context).unfocus();

    String? phoneNumber;
    String? countryCode;
    if (_selectedPhone != null) {
      phoneNumber = _selectedPhone.completeNumber;
      countryCode = _selectedPhone.countryCode;
    }

    final result = await vm.upgradeAccount(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      email: _email.text.trim(),
      password: _password.text.trim(),
      phoneNumber: phoneNumber,
      countryCode: countryCode,
    );

    if (!mounted) return;

    if (result.isSuccess && result.data != null) {
      UIHelper.showSuccess(context, tr("upgrade_account_success"));
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
    final vm = context.watch<UpgradeAccountViewModel>();
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: CommonAppBar(title: tr("upgrade_account_title")),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  tr("upgrade_account_subtitle"),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodyMedium?.copyWith(
                    color: scheme.onSurface.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // --- FORM CARD ---
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withOpacity(0.05),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
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
                            const SizedBox(width: 16),
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

                        const SizedBox(height: 16),

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
                          ),
                        ),

                        const SizedBox(height: 16),

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

                        const SizedBox(height: 8),

                        if (_passwordTouched) ...[PasswordRules(password: _passwordValue)],

                        const SizedBox(height: 16),

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

                        const SizedBox(height: 24),

                        PrimaryButton(
                          text: tr("upgrade_account_button"),
                          isLoading: vm.isLoading,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
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
            ? [PasswordValidator.passwordInputFormatter]
            : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: scheme.onSurfaceVariant),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isObscure
                        ? SolarIconsOutline.eyeClosed
                        : SolarIconsOutline.eye,
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

