import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/features/auth/login/google_viewmodel.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onSuccess;

  const SocialLoginButtons({super.key, this.onSuccess});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final splashVM = Provider.of<SplashViewModel>(context, listen: false);

    final scheme = context.colors;
    final text = context.textStyles;

    final googleButtonStyle = OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(AppSpacing.xxxxxl),
      side: BorderSide(color: scheme.primary),
      backgroundColor: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.medium)),
    );

    final appleButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: scheme.onInverseSurface,
      minimumSize: const Size.fromHeight(AppSpacing.xxxxxl),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.medium)),
    );

    return Column(
      children: [
        // GOOGLE
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _handleSocialSignIn(
              context, authVM, splashVM, AuthProviderType.google,
            ),
            style: googleButtonStyle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/google_logo.png',
                  width: AppIconSize.xl - 2,
                  height: AppIconSize.xl - 2,
                  semanticLabel: 'Google',
                ),
                const SizedBox(width: AppSpacing.m),
                Text(
                  'login_with_google'.tr(),
                  style: text.labelLarge?.copyWith(color: scheme.primary),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.m),

        // APPLE
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _handleSocialSignIn(
              context, authVM, splashVM, AuthProviderType.apple,
            ),
            style: appleButtonStyle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.apple, color: scheme.onInverseSurface, size: AppIconSize.xxl - 2, semanticLabel: 'Apple'),
                const SizedBox(width: AppSpacing.m),
                Text(
                  tr('sign_in_with_apple'),
                  style: text.labelLarge?.copyWith(color: scheme.onInverseSurface),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSocialSignIn(
    BuildContext context,
    AuthViewModel authVM,
    SplashViewModel splashVM,
    AuthProviderType type,
  ) async {
    _showLoading(context);

    final result = await authVM.signIn(type);

    if (context.mounted) Navigator.of(context).pop();

    if (context.mounted) {
      if (result.isSuccess) {
        await splashVM.saveAuthData(result.data!);
        onSuccess?.call();
      } else {
        UIHelper.showError(
          context,
          result.error?.message.tr() ?? 'unexpected_error_occurred'.tr(),
        );
      }
    }
  }

  void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.xxxl - 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: AppIconSize.xxxl,
                width: AppIconSize.xxxl,
                child: const CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                'common_loading'.tr(),
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
