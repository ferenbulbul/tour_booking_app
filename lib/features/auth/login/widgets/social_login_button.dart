import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/features/auth/login/widgets/google_view_model.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        // FACEBOOK (outline tarzı)
        // SizedBox(
        //   width: double.infinity,
        //   child: OutlinedButton(
        //     onPressed: () {
        //       context.go('/home');
        //     },
        //     style: OutlinedButton.styleFrom(
        //       minimumSize: const Size.fromHeight(48),
        //       side: BorderSide(color: scheme.primary),
        //       backgroundColor: scheme.surface,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //     ),
        //     child: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         const SizedBox(width: 8),
        //         Icon(Icons.facebook, color: scheme.primary, size: 26),
        //         const SizedBox(width: 12),
        //         Text(
        //           'login_with_facebook'.tr(),
        //           style: text.labelLarge?.copyWith(color: scheme.primary),
        //         ),
        //         const SizedBox(width: 8),
        //       ],
        //     ),
        //   ),
        // ),
        const SizedBox(height: AppSpacing.m),

        // GOOGLE
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () async {
              _showLoading(context);

              final result = await authVM.signIn(AuthProviderType.google);

              if (context.mounted) Navigator.of(context).pop();

              if (context.mounted) {
                if (result.isSuccess) {
                  context.go('/home');
                } else {
                  UIHelper.showError(
                    context,
                    result.error?.message?.tr() ??
                        'unexpected_error_occurred'.tr(),
                  );
                }
              }
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              side: BorderSide(color: scheme.primary),
              backgroundColor: scheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
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

        // APPLE (marka gereği siyah-beyaz bırakıyoruz)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              _showLoading(context);

              final result = await authVM.signIn(AuthProviderType.apple);

              if (context.mounted) Navigator.of(context).pop();

              if (context.mounted) {
                if (result.isSuccess) {
                  context.go('/home');
                } else {
                  UIHelper.showError(
                    context,
                    result.error?.message?.tr() ??
                        'unexpected_error_occurred'.tr(),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: scheme.onSecondary),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
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

  void _showLoading(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: scheme.primary)),
    );
  }
}
