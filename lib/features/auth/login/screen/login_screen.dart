import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/enum/user_role.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_elevation.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/features/auth/login/login_viewmodel.dart';
import 'package:tour_booking/features/auth/login/widget/social_login_button.dart';
import 'package:tour_booking/utils/password_validator.dart';
import 'package:flutter/material.dart' as ui;
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final text = context.textStyles;
    final topInset = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: scheme.surface,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              children: [
                SizedBox(height: topInset + AppSpacing.l),
                const _CleanHeader(),
                const SizedBox(height: AppSpacing.xxxxl),

                // Social login (ust kisim)
                const SocialLoginButtons(),

                const SizedBox(height: AppSpacing.xxl),

                // Ayirici
                Row(
                  children: [
                    Expanded(child: Divider(color: scheme.outlineVariant)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                      child: Text(
                        tr('or_continue_with'),
                        style: text.bodySmall?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: scheme.outlineVariant)),
                  ],
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Email + sifre form (kart icinde)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.xxl),
                    boxShadow: AppElevation.shadowLg,
                  ),
                  child: const _CleanLoginForm(),
                ),

                const SizedBox(height: AppSpacing.xl),
                const _RegisterPrompt(),

                const SizedBox(height: AppSpacing.l),
                _buildTermsText(context),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsText(BuildContext context) {
    final scheme = context.colors;
    final baseStyle = AppTextStyles.caption.copyWith(
      color: scheme.onSurface.withValues(alpha: 0.5),
      height: 1.4,
    );
    final linkStyle = baseStyle.copyWith(
      color: scheme.primary,
      decoration: TextDecoration.underline,
      decorationColor: scheme.primary,
    );

    final fullText = tr("terms_acceptance_text",
        namedArgs: {"terms": "{terms}", "privacy": "{privacy}"});
    final parts = fullText.split(RegExp(r'\{terms\}|\{privacy\}'));
    final termsLabel = tr("terms_and_conditions");
    final privacyLabel = tr("privacy_policy_accusative");

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: parts[0], style: baseStyle),
          TextSpan(
            text: termsLabel,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.push('/legal/kvkk'),
          ),
          if (parts.length > 1) TextSpan(text: parts[1], style: baseStyle),
          TextSpan(
            text: privacyLabel,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.push('/legal/privacy-policy'),
          ),
          if (parts.length > 2) TextSpan(text: parts[2], style: baseStyle),
        ],
      ),
      textAlign: TextAlign.center,
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
    final scheme = context.colors;
    final text = context.textStyles;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: width * 0.20,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.xxl)),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/header.png',
            alignment: Alignment.center,
            excludeFromSemantics: true,
          ),
        ),

        const SizedBox(height: AppSpacing.s),

        Text(
          'welcome_subtitle'.tr(),
          style: text.bodyMedium?.copyWith(
            color: scheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// --------------------------------------
// LOGIN FORM (iki adimli: email -> sifre)
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
  bool _showPasswordStep = false;

  void _continueWithEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      UIHelper.showError(context, tr("email_required"));
      return;
    }
    setState(() => _showPasswordStep = true);
  }

  void _login() async {
    final splashVM = Provider.of<SplashViewModel>(context, listen: false);
    final vm = Provider.of<LoginViewModel>(context, listen: false);
    FocusScope.of(context).unfocus();

    final result = await vm.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (result.isSuccess && result.data != null) {
      final user = result.data!;

      await splashVM.saveAuthData(result.data!);

      if (!mounted) return;

      if (user.role.toLowerCase() == UserRole.driver.name) {
        context.go(user.isFirstLogin ? '/change-password-driver' : '/driver');
      } else {
        context.go('/home');
      }
    } else {
      if (vm.message != null) {
        UIHelper.showError(context, vm.message!.tr());
      } else if (vm.validationErrors.isNotEmpty) {
        UIHelper.showValidationErrors(context, vm.validationErrors);
      } else {
        UIHelper.showError(context, tr('unexpected_error_occurred'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final text = context.textStyles;
    final isLoading = context.watch<LoginViewModel>().isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            final isForward = child.key == const ValueKey('password');
            final offsetTween = Tween<Offset>(
              begin: Offset(isForward ? 1.0 : -1.0, 0),
              end: Offset.zero,
            );
            return SlideTransition(
              position: offsetTween.animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: _showPasswordStep
              ? Column(
                  key: const ValueKey('password'),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      controller: _passwordController,
                      label: 'password'.tr(),
                      icon: SolarIconsOutline.lock,
                      isPassword: true,
                      isObscure: _isObscure,
                      onVisibilityToggle: () =>
                          setState(() => _isObscure = !_isObscure),
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
                  ],
                )
              : Column(
                  key: const ValueKey('email'),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      controller: _emailController,
                      label: 'email'.tr(),
                      icon: SolarIconsOutline.letter,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
        ),

        const SizedBox(height: AppSpacing.xxl),

        PrimaryButton(
          text: _showPasswordStep
              ? 'login'.tr()
              : tr('continue_with_email'),
          onPressed: _showPasswordStep ? _login : _continueWithEmail,
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
    final scheme = context.colors;

    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? isObscure : false,
        keyboardType:
            keyboardType ??
            (isPassword ? TextInputType.visiblePassword : TextInputType.text),
        inputFormatters: isPassword
            ? [PasswordValidator.passwordInputFormatter]
            : null,
        textAlign: TextAlign.left,
        cursorColor: scheme.primary,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: scheme.onSurfaceVariant),
          suffixIcon: isPassword
              ? IconButton(
                  tooltip: 'Toggle password visibility',
                  icon: Icon(
                    isObscure
                        ? SolarIconsOutline.eyeClosed
                        : SolarIconsOutline.eye,
                    color: scheme.onSurfaceVariant,
                    semanticLabel: isObscure ? 'Show password' : 'Hide password',
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
    final text = context.textStyles;
    final scheme = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'dont_have_account'.tr(),
          style: text.bodyMedium?.copyWith(
            color: scheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Semantics(
          button: true,
          label: 'Navigate to create account',
          child: GestureDetector(
            onTap: () => context.push('/register'),
            child: Text(
              'create_account'.tr(),
              style: text.labelLarge?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
