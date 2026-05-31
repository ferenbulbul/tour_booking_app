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
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/features/auth/login/login_viewmodel.dart';
import 'package:tour_booking/features/auth/login/widget/social_login_button.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/navigation/app_router.dart';
import 'package:tour_booking/utils/password_validator.dart';
import 'package:flutter/material.dart' as ui;
import 'package:tour_booking/core/theme/app_theme_context.dart';

/// Shows the login bottom sheet.
/// Returns `true` if login succeeds, `null` if dismissed.
Future<bool?> showLoginBottomSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
    ),
    builder: (ctx) {
      return ChangeNotifierProvider(
        create: (_) => LoginViewModel(),
        child: const _LoginBottomSheetContent(),
      );
    },
  );
}

class _LoginBottomSheetContent extends StatefulWidget {
  const _LoginBottomSheetContent();

  @override
  State<_LoginBottomSheetContent> createState() =>
      _LoginBottomSheetContentState();
}

class _LoginBottomSheetContentState extends State<_LoginBottomSheetContent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _showPasswordStep = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
    final homeVm = context.read<HomeViewModel>();
    final profileVm = context.read<ProfileViewModel>();
    final navigator = Navigator.of(context);
    FocusScope.of(context).unfocus();

    final result = await vm.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (result.isSuccess && result.data != null) {
      final user = result.data!;
      await splashVM.saveAuthData(user);

      // Directly refresh home data & profile with new auth token
      homeVm.init();
      homeVm.loadCityTargets();
      profileVm.fetchProfile();

      // Pop sheet and navigate
      try { navigator.pop(true); } catch (e) { debugPrint('_LoginBottomSheetContentState._login: $e'); }

      if (user.role.toLowerCase() == UserRole.driver.name) {
        router.go(user.isFirstLogin ? '/change-password-driver' : '/driver');
      } else {
        router.go('/home');
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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── FIXED HEADER ──
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.m, AppSpacing.xxl, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: AppSpacing.xxxxl,
                  height: AppSpacing.xs,
                  decoration: BoxDecoration(
                    color: context.colors.outline,
                    borderRadius: BorderRadius.circular(AppRadius.xxs),
                  ),
                ),
                const SizedBox(height: AppSpacing.s),

                // Close button
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, semanticLabel: 'Close'),
                  ),
                ),
              ],
            ),
          ),

          // ── SCROLLABLE CONTENT ──
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, 0, AppSpacing.xxl, AppSpacing.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
              // Hosgeldin
              Text(
                'welcome_subtitle'.tr(),
                style: text.bodyMedium?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Social login (ust kisim)
              SocialLoginButtons(
                onSuccess: () {
                  if (mounted) Navigator.of(context).pop(true);
                },
              ),

              const SizedBox(height: AppSpacing.xl),

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

              const SizedBox(height: AppSpacing.xl),

              // Email / Sifre gecisi (yana kayma animasyonu)
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
                              onPressed: () {
                                Navigator.of(context).pop();
                                context.push('/forgot-password');
                              },
                              child: Text(
                                'forgot_password'.tr(),
                                style: text.labelLarge?.copyWith(
                                  color: scheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        key: const ValueKey('email'),
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

              const SizedBox(height: AppSpacing.l),

              // Button: email step or login
              PrimaryButton(
                text: _showPasswordStep
                    ? 'login'.tr()
                    : tr('continue_with_email'),
                onPressed: _showPasswordStep ? _login : _continueWithEmail,
                isLoading: isLoading,
              ),

              const SizedBox(height: AppSpacing.l),

              // Kayit ol
              Row(
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
                      onTap: () {
                        Navigator.of(context).pop();
                        context.push('/register');
                      },
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
              ),

              const SizedBox(height: AppSpacing.l),

              // Yasal kabul metni
              _buildTermsText(context),
            ],
          ),
        ),
          ),
        ],
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
        keyboardType: keyboardType ??
            (isPassword ? TextInputType.visiblePassword : TextInputType.text),
        inputFormatters:
            isPassword ? [PasswordValidator.passwordInputFormatter] : null,
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
