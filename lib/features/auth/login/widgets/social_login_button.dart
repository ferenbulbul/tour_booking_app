import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/features/auth/login/widgets/google_view_model.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    return Column(
      children: [
        // Facebook
        ElevatedButton(
          onPressed: () {
            context.go('/home');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 12),
              Icon(Icons.facebook, color: AppColors.primary, size: 30),
              const SizedBox(width: 12),
              Text('login_with_facebook'.tr()),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Google
        ElevatedButton(
          onPressed: () async {
            _showLoading(context);

            final result = await authVM.signIn(AuthProviderType.google);

            if (context.mounted) Navigator.of(context).pop();

            if (context.mounted) {
              if (result.isSuccess) {
                context.go('/home');
              } else {
                _showError(context, result.error?.message);
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/google_logo.png',
                width: 25,
                height: 25,
              ),
              const SizedBox(width: 12),
              Text('login_with_google'.tr()),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Apple
        ElevatedButton(
          onPressed: () async {
            _showLoading(context);

            final result = await authVM.signIn(AuthProviderType.apple);

            if (context.mounted) Navigator.of(context).pop();

            if (context.mounted) {
              if (result.isSuccess) {
                context.go('/home');
              } else {
                _showError(context, result.error?.message);
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Apple butonu siyah
            foregroundColor: Colors.white, // Yazı beyaz
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.apple, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Text('Apple ile giriş yap'),
            ],
          ),
        ),
      ],
    );
  }

  void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  void _showError(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? "Bilinmeyen bir hata oluştu."),
        backgroundColor: Colors.red,
      ),
    );
  }
}
