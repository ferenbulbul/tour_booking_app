import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/auth/change_password/change_password_viewmodel.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pwdCtrl = TextEditingController();
  final _pwd2Ctrl = TextEditingController();

  bool _ob1 = true;
  bool _ob2 = true;

  final _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{9,}$',
  );

  String? _pwdValidator(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Şifre zorunlu.';
    if (!_passwordRegex.hasMatch(value)) {
      return 'En az 9 karakter, 1 büyük, 1 küçük, 1 sayı ve 1 özel karakter içermeli.';
    }
    return null;
  }

  String? _confirmValidator(String? v) {
    if ((v ?? '').trim().isEmpty) return 'Şifre tekrarı zorunlu.';
    if (v!.trim() != _pwdCtrl.text.trim()) return 'Şifreler eşleşmiyor.';
    return null;
  }

  @override
  void dispose() {
    _pwdCtrl.dispose();
    _pwd2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePasswordViewModel(),
      child: Consumer<ChangePasswordViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Şifre Değiştir')),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _pwdCtrl,
                    obscureText: _ob1,
                    decoration: InputDecoration(
                      labelText: 'Yeni Şifre',
                      hintText: 'Min 9, A/a, 0-9, özel (!@#...)',
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _ob1 = !_ob1),
                        icon: Icon(
                          _ob1 ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: _pwdValidator,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _pwd2Ctrl,
                    obscureText: _ob2,
                    decoration: InputDecoration(
                      labelText: 'Şifre Tekrar',
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _ob2 = !_ob2),
                        icon: Icon(
                          _ob2 ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: _confirmValidator,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(context, vm),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: vm.isLoading
                          ? null
                          : () => _submit(context, vm),
                      child: vm.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Şifreyi Güncelle'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _RulesNote(),
                  if (vm.message != null || vm.validationErrors.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      _buildError(vm),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit(BuildContext context, ChangePasswordViewModel vm) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final result = await vm.changePassword(_pwdCtrl.text.trim());

    // Snackbar/UI sadece ekranda (VM içinde değil)
    if (!mounted) return;
    if (result.isSuccess) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Şifre güncellendi.')));
      Navigator.of(context).maybePop();
      context.go('/login');
    } else {
      final msg = vm.message ?? 'İşlem başarısız.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  String _buildError(ChangePasswordViewModel vm) {
    if (vm.validationErrors.isNotEmpty) {
      return vm.validationErrors.join('\n');
    }
    return vm.message ?? '';
  }
}

class _RulesNote extends StatelessWidget {
  const _RulesNote();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'Şifre kuralları:\n'
          '• En az 9 karakter\n'
          '• En az 1 büyük (A–Z)\n'
          '• En az 1 küçük (a–z)\n'
          '• En az 1 rakam (0–9)\n'
          '• En az 1 özel karakter (!@#\$%^&* vb.)',
        ),
      ),
    );
  }
}
