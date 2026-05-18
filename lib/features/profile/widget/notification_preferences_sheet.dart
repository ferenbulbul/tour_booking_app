import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';

void showNotificationPreferencesSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return ChangeNotifierProvider.value(
        value: context.read<ProfileViewModel>(),
        child: const _NotificationPreferencesContent(),
      );
    },
  );
}

class _NotificationPreferencesContent extends StatelessWidget {
  const _NotificationPreferencesContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final profile = vm.profile;
    if (profile == null) return const SizedBox.shrink();

    final hasPhone = profile.phoneNumber.isNotEmpty;
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),

            Text(
              tr('notification_preferences'),
              style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            // Email
            _NotificationToggleRow(
              icon: SolarIconsOutline.letter,
              label: tr('notification_email'),
              value: profile.emailNotification,
              onChanged: (val) => vm.updateNotificationPreference(
                type: 'email',
                value: val,
              ),
            ),

            Divider(height: 1, color: AppColors.border.withValues(alpha: 0.5)),

            // Push
            _NotificationToggleRow(
              icon: SolarIconsOutline.notificationUnread,
              label: tr('notification_push'),
              value: profile.pushNotification,
              onChanged: (val) => vm.updateNotificationPreference(
                type: 'push',
                value: val,
              ),
            ),

            // SMS (sadece telefon kayıtlıysa)
            if (hasPhone) ...[
              Divider(
                height: 1,
                color: AppColors.border.withValues(alpha: 0.5),
              ),
              _NotificationToggleRow(
                icon: SolarIconsOutline.smartphone,
                label: tr('notification_sms'),
                value: profile.smsNotification,
                onChanged: (val) => vm.updateNotificationPreference(
                  type: 'sms',
                  value: val,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotificationToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: scheme.onSurface.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.accent,
            activeThumbColor: Colors.white,
            inactiveTrackColor: scheme.onSurface.withValues(alpha: 0.1),
            inactiveThumbColor: Colors.white,
            trackOutlineColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.accent;
              }
              return scheme.onSurface.withValues(alpha: 0.2);
            }),
          ),
        ],
      ),
    );
  }
}
