import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/auth/login/google_viewmodel.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/features/profile/widget/delete_account_dialog.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final profile = vm.profile;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: CommonAppBar(title: tr('personal_info')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: [
            _ReadOnlyField(
              label: tr('full_name'),
              value: profile.fullName,
            ),
            const SizedBox(height: AppSpacing.m),

            _ReadOnlyField(
              label: tr('email'),
              value: profile.email,
            ),
            const SizedBox(height: AppSpacing.m),

            _PhoneField(
              label: profile.phoneNumber.isNotEmpty
                  ? tr('phone_number')
                  : tr('add_phone_number'),
              value: profile.phoneNumber.isNotEmpty
                  ? profile.phoneNumber
                  : tr("not_entered"),
              isEmpty: profile.phoneNumber.isEmpty,
              onTap: () => context.push("/update-phone"),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleDeleteAccount(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  tr("delete_account"),
                  style: text.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.m),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDeleteAccount(BuildContext context) async {
    final profileVm = context.read<ProfileViewModel>();
    final authVm = context.read<AuthViewModel>();
    final splashVm = context.read<SplashViewModel>();

    final confirmed = await showDeleteAccountDialog(context);
    if (confirmed != true) return;

    final success = await profileVm.deleteAccount();
    if (!context.mounted) return;

    final msg = profileVm.message ?? tr("error_generic");
    if (success) {
      UIHelper.showSuccess(context, msg.tr());
      await splashVm.performAccountDeletion(
        socialCleanup: () => authVm.socialDeleteAccount(),
      );
      if (context.mounted) context.go('/home');
    } else {
      UIHelper.showError(context, msg.tr());
    }
  }
}

class _PhoneField extends StatelessWidget {
  final String label;
  final String value;
  final bool isEmpty;
  final VoidCallback onTap;

  const _PhoneField({
    required this.label,
    required this.value,
    required this.isEmpty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AbsorbPointer(
        child: TextFormField(
          initialValue: value,
          readOnly: true,
          enabled: false,
          decoration: InputDecoration(
            labelText: label,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            labelStyle: text.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            suffixIcon: Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.textLight,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isEmpty
                    ? AppColors.warning.withValues(alpha: 0.5)
                    : AppColors.accent.withValues(alpha: 0.35),
              ),
            ),
          ),
          style: text.bodyMedium?.copyWith(
            color: isEmpty ? AppColors.warning : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyField({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return TextFormField(
      initialValue: value,
      readOnly: true,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        labelStyle: text.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.accent.withValues(alpha: 0.35),
          ),
        ),
      ),
      style: text.bodyMedium?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
