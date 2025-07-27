import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/features/reset_password/widget/reset_password_view_model.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String token;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ResetPasswordViewModel>();

    // ✅ Başarı / hata mesajı varsa göster
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm.resultss) {
        if (vm.message != null) {
          UIHelper.showSuccess(context, vm.message!);
          vm.clearMessages();
        }
      }
      if (vm.message != null) {
        UIHelper.showError(context, vm.message!);
        vm.clearMessages();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Şifreyi Sıfırla')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('E-posta: ${widget.email}'),
              const SizedBox(height: 12),

              // ✅ Yeni şifre alanı
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Yeni Şifre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Şifre en az 8 karakter olmalı';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // ✅ Şifre onay alanı
              TextFormField(
                controller: _confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifreyi Onayla',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Şifreler eşleşmiyor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // ✅ Buton ve loading
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;

                          final result = await vm.resetPassword(
                            widget.email,
                            widget.token,
                            _passwordController.text,
                          );

                          if (result.isSuccess && mounted) {
                            context.go('/login');
                          }
                        },
                  child: vm.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text('Şifreyi Sıfırla'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
