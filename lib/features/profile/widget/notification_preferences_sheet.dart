import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/features/profile/profile_viewmodel.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

void showNotificationPreferencesSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
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
    final text = context.textStyles;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.m, AppSpacing.xxl, AppSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppIconSize.xxxl,
              height: AppSpacing.xs,
              decoration: BoxDecoration(
                color: context.colors.outline,
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
            ),
            const SizedBox(height: AppSpacing.ml),

            Text(
              tr('notification_preferences'),
              style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.l),

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

            Divider(height: 1, color: context.colors.outline.withValues(alpha: 0.5)),

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

            // SMS (only if phone is registered)
            if (hasPhone) ...[
              Divider(
                height: 1,
                color: context.colors.outline.withValues(alpha: 0.5),
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
    final scheme = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Row(
        children: [
          Container(
            width: AppSpacing.xxxl,
            height: AppSpacing.xxxl,
            decoration: BoxDecoration(
              color: scheme.onSurface.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Icon(icon, size: AppIconSize.ml, color: context.colors.onSurfaceVariant),
          ),
          const SizedBox(width: AppSpacing.ms),
          Expanded(
            child: Text(
              label,
              style: context.textStyles.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: context.colors.secondary,
            activeThumbColor: Colors.white,
            inactiveTrackColor: scheme.onSurface.withValues(alpha: 0.1),
            inactiveThumbColor: Colors.white,
            trackOutlineColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return context.colors.secondary;
              }
              return scheme.onSurface.withValues(alpha: 0.2);
            }),
          ),
        ],
      ),
    );
  }
}
