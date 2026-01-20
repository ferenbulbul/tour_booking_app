import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/features/auth/login/widgets/login_view_model.dart';
import 'package:tour_booking/features/auth/login/widgets/social_login_button.dart';
import 'package:flutter/material.dart' as ui;
import 'package:tour_booking/features/splash/splash_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final topInset = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: scheme.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              children: [
                SizedBox(height: topInset + 16),
                const _CleanHeader(),
                const SizedBox(height: 40),

                // --- PREMIUM CARD ---
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const _CleanLoginForm(),
                ),

                const SizedBox(height: 16),

                Text(
                  tr('or_continue_with'),
                  style: text.bodyMedium?.copyWith(
                    color: scheme.onSurface.withOpacity(0.6),
                  ),
                ),

                const SizedBox(height: 16),
                const SocialLoginButtons(),

                const SizedBox(height: 20),
                const _RegisterPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------
// HEADER
// --------------------------------------
class _CleanHeader extends StatelessWidget {
  const _CleanHeader();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: width * 0.20, // 🔥 banner oranı
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/header.png',

            alignment: Alignment.center,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'welcome_subtitle'.tr(),
          style: text.bodyMedium?.copyWith(
            color: scheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// --------------------------------------
// LOGIN FORM
// --------------------------------------
class _CleanLoginForm extends StatefulWidget {
  const _CleanLoginForm();

  @override
  State<_CleanLoginForm> createState() => _CleanLoginFormState();
}

class _CleanLoginFormState extends State<_CleanLoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

  void _login() async {
    final splashVM = Provider.of<SplashViewModel>(context, listen: false);
    final vm = Provider.of<LoginViewModel>(context, listen: false);
    FocusScope.of(context).unfocus();

    final result = await vm.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (result.isSuccess) {
      await splashVM.saveAuthData(result.data!);
    } else {
      if (vm.message != null) UIHelper.showError(context, vm.message!);
      if (vm.validationErrors.isNotEmpty) {
        UIHelper.showValidationErrors(context, vm.validationErrors);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final isLoading = context.watch<LoginViewModel>().isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // EMAIL
        _buildTextField(
          controller: _emailController,
          label: 'email'.tr(),
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 20),

        // PASSWORD
        _buildTextField(
          controller: _passwordController,
          label: 'password'.tr(),
          icon: Icons.lock_outline,
          isPassword: true,
          isObscure: _isObscure,
          onVisibilityToggle: () => setState(() => _isObscure = !_isObscure),
        ),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.push('/forgot-password'),
            child: Text(
              'forgot_password'.tr(),

              style: text.labelLarge?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        PrimaryButton(
          text: 'login'.tr(),
          onPressed: _login,
          isLoading: isLoading,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onVisibilityToggle,
    TextInputType? keyboardType,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: ui.TextDirection.ltr, // 🔥 KRİTİK
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? isObscure : false,
        keyboardType:
            keyboardType ??
            (isPassword ? TextInputType.visiblePassword : TextInputType.text),

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

        textAlign: TextAlign.left,
        cursorColor: scheme.primary,
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
                  onPressed: onVisibilityToggle,
                )
              : null,
        ),
      ),
    );
  }
}

// --------------------------------------
// REGISTER REDIRECT
// --------------------------------------
class _RegisterPrompt extends StatelessWidget {
  const _RegisterPrompt();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'dont_have_account'.tr(),
          style: text.bodyMedium?.copyWith(
            color: scheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () => context.push('/register'),
          child: Text(
            'create_account'.tr(),
            style: text.labelLarge?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
