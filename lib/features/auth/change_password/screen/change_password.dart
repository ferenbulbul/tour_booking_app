import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/auth/change_password/change_password_viewmodel.dart';

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

  // 🔹 Validator → KEY üretir, UI .tr() yapar
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'password_required';

    final pwd = value.trim();
    if (pwd.length < 9) return 'password_too_short';

    final upper = RegExp(r'[A-Z]');
    final lower = RegExp(r'[a-z]');
    final digit = RegExp(r'\d');
    final special = RegExp(r'[^A-Za-z0-9]');

    final errors = <String>[
      if (!upper.hasMatch(pwd)) 'password_must_include_upper',
      if (!lower.hasMatch(pwd)) 'password_must_include_lower',
      if (!digit.hasMatch(pwd)) 'password_must_include_digit',
      if (!special.hasMatch(pwd)) 'password_must_include_special',
    ];

    return errors.isEmpty ? null : errors.join('\n');
  }

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
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: CommonAppBar(title: 'reset_password'.tr()),
      body: Padding(
        padding: const EdgeInsets.all(20),
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

              const SizedBox(height: 16),

              _buildPasswordField(
                label: 'confirm_password'.tr(),
                controller: _confirmController,
                obscure: _isConfirmObscure,
                toggle: () =>
                    setState(() => _isConfirmObscure = !_isConfirmObscure),
                validator: (v) => _validateConfirm(v)?.tr(),
                primaryColor: primaryColor,
              ),

              const SizedBox(height: 24),

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

              const SizedBox(height: 12),
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
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: primaryColor,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400], size: 22),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey[400],
          ),
          onPressed: toggle,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }
}
