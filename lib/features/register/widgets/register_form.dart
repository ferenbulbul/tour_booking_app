import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final AuthService _authService = AuthService();

  void _register() async {
    // final success = await _authService.register(
    //   _nameController.text,
    //   _emailController.text,
    //   _passwordController.text,
    // );
    // if (success) {
    //   context.go('/home');
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Kayıt başarısız')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Ad Soyad',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.elementSpacing),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'E-posta',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.elementSpacing),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Şifre',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionSpacing),
        ElevatedButton(onPressed: _register, child: const Text('Kayıt Ol')),
      ],
    );
  }
}
