import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _feedbackMessage;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _feedbackMessage = null;
    });

    final email = _emailController.text.trim();

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simülasyon

      setState(() {
        _feedbackMessage =
            "Eğer bu e-posta adresi kayıtlıysa, sıfırlama e-postası gönderildi.";
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
            const Text(
              "E-posta adresinizi girin, size şifre sıfırlama bağlantısı gönderelim.",
            ),
            const SizedBox(height: AppSpacing.elementSpacing),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "E-posta"),
              validator: (value) {
                if (value == null || value.isEmpty) return "E-posta girin";
                if (!value.contains("@")) return "Geçerli e-posta girin";
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.elementSpacing),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submit,
                    child: const Text("Gönder"),
                  ),
            if (_feedbackMessage != null) ...[
              const SizedBox(height: AppSpacing.sectionSpacing),
              Text(
                _feedbackMessage!,
                style: const TextStyle(color: Colors.green),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
