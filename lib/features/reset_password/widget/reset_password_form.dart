import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';

class ResetPasswordForm extends StatefulWidget {
  final String email;
  final String token;

  const ResetPasswordForm({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _feedbackMessage;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _feedbackMessage = null;
    });

    final email = widget.email;
    final token = widget.token;
    final newPassword = _passwordController.text.trim();

    try {
      // TODO: Buraya gerçek HTTP çağrısı yapılacak
      // final response = await http.post(...)

      await Future.delayed(const Duration(seconds: 2)); // Simülasyon

      setState(() {
        _feedbackMessage = "Şifreniz başarıyla sıfırlandı.";
      });
    } catch (e) {
      setState(() {
        _feedbackMessage = "Bir hata oluştu. Lütfen tekrar deneyin.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text("Yeni şifrenizi girin."),
            const SizedBox(height: AppSpacing.elementSpacing),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Yeni Şifre"),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return "Şifre en az 6 karakter olmalıdır.";
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.elementSpacing),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    child: const Text("Şifreyi Sıfırla"),
                  ),
            if (_feedbackMessage != null) ...[
              const SizedBox(height: AppSpacing.sectionSpacing),
              Text(
                _feedbackMessage!,
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
