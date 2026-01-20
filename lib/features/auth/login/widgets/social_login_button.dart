import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/features/auth/login/widgets/google_view_model.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart'; // 🔥 Ekle

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthViewModel ve SplashViewModel'i alıyoruz
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final splashVM = Provider.of<SplashViewModel>(
      context,
      listen: false,
    ); // 🔥 Ekle

    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    // Ortak buton stilini bir değişkene alarak kod fazlalığını azaltalım
    final googleButtonStyle = OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      side: BorderSide(color: scheme.primary),
      backgroundColor: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    final appleButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    return Column(
      children: [
        // GOOGLE
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _handleSocialSignIn(
              context,
              authVM,
              splashVM,
              AuthProviderType.google,
            ),
            style: googleButtonStyle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/google_logo.png',
                  width: 22,
                  height: 22,
                ),
                const SizedBox(width: 12),
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
              context,
              authVM,
              splashVM,
              AuthProviderType.apple,
            ),
            style: appleButtonStyle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.apple, color: Colors.white, size: 26),
                const SizedBox(width: 12),
                Text(
                  tr('sign_in_with_apple'),
                  style: text.labelLarge?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 🔥 Mantığı tek bir yere topladık (Kod tekrarını engelledik)
  Future<void> _handleSocialSignIn(
    BuildContext context,
    AuthViewModel authVM,
    SplashViewModel splashVM,
    AuthProviderType type,
  ) async {
    _showLoading(context);

    final result = await authVM.signIn(type);

    if (context.mounted) Navigator.of(context).pop(); // Loading'i kapat

    if (context.mounted) {
      if (result.isSuccess) {
        // 🔥 KRİTİK: Manuel context.go yerine SplashVM'i uyandırıyoruz
        // Router bu sayede "Evet token geldi" diyor ve bizi doğru yere (veya deep linke) atıyor.
        await splashVM.saveAuthData(result.data!);
      } else {
        UIHelper.showError(
          context,
          result.error?.message?.tr() ?? 'unexpected_error_occurred'.tr(),
        );
      }
    }
  }

  void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }
}
