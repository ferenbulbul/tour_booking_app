import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
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

  // REGISTER ekranındaki password kuralları
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Şifre zorunludur.";
    final pwd = value.trim();

    if (pwd.length < 9) return "Şifre en az 9 karakter olmalıdır.";

    final upper = RegExp(r'[A-Z]');
    final lower = RegExp(r'[a-z]');
    final digit = RegExp(r'\d');
    final special = RegExp(r'[^A-Za-z0-9]');

    final errors = <String>[
      if (!upper.hasMatch(pwd)) "• En az 1 büyük harf (A–Z)",
      if (!lower.hasMatch(pwd)) "• En az 1 küçük harf (a–z)",
      if (!digit.hasMatch(pwd)) "• En az 1 rakam (0–9)",
      if (!special.hasMatch(pwd)) "• En az 1 özel karakter (!@#...)",
    ];

    return errors.isEmpty ? null : errors.join("\n");
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.trim().isEmpty) return "Şifre tekrarı zorunludur.";
    if (v.trim() != _passwordController.text.trim()) {
      return "Şifreler eşleşmiyor.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChangePasswordViewModel>();
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(title: const Text("Şifre Değiştir")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordField(
                label: "Yeni Şifre",
                controller: _passwordController,
                obscure: _isPasswordObscure,
                toggle: () =>
                    setState(() => _isPasswordObscure = !_isPasswordObscure),
                validator: _validatePassword,
                primaryColor: primaryColor,
              ),

              const SizedBox(height: 16),

              _buildPasswordField(
                label: "Şifre Tekrar",
                controller: _confirmController,
                obscure: _isConfirmObscure,
                toggle: () =>
                    setState(() => _isConfirmObscure = !_isConfirmObscure),
                validator: _validateConfirm,
                primaryColor: primaryColor,
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                text: "Şifreyi Güncelle",
                isLoading: vm.isLoading,
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final result = await vm.changePassword(
                    _passwordController.text.trim(),
                  );

                  if (!mounted) return;

                  if (result.isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Şifre başarıyla güncellendi."),
                      ),
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(vm.message ?? "İşlem başarısız.")),
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
