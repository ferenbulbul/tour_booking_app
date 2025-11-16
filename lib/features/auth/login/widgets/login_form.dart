import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/features/auth/login/widgets/login_view_model.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    final vm = Provider.of<LoginViewModel>(context, listen: false);
    final result = await vm.login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    final roleString = result.data?.role;
    final role = UserRoleExtension.fromString(roleString);

    if (result.isSuccess) {
      final data = result.data!;
      final bool emailConfirmed = data.emailConfirmed == true;
      final bool isFirstLogin = data.isFirstLogin == true;

      if (!context.mounted) return;

      // --- DRIVER AKIŞI ---
      if (role == UserRole.driver) {
        if (isFirstLogin) {
          context.go('/change-password');
        } else {
          context.go('/driver'); // ← driver ana sayfanın route’u
        }
        return; // başka navigasyonları engelle
      }

      // --- DİĞER ROLLER ---
      if (!emailConfirmed) {
        context.go('/email-confirmed');
        return;
      }

      context.go('/home');
    } else {
      if (vm.message != null) {
        UIHelper.showError(context, vm.message!);
      }
      if (vm.validationErrors.isNotEmpty) {
        UIHelper.showValidationErrors(context, vm.validationErrors);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: 'email'.tr()),
        ),
        const SizedBox(height: AppSpacing.elementSpacing),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: 'password'.tr()),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              context.push('/forgot-password');
            },
            child: Text(
              'forgot_password'.tr(),
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).primaryColor,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionSpacing),
        ElevatedButton(onPressed: _login, child: const Text('login').tr()),
      ],
    );
  }
}
