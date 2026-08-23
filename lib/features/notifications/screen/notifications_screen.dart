import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/widgets/empty_state.dart';
import 'package:tour_booking/features/notifications/notifications_viewmodel.dart';
import 'package:tour_booking/models/notifications/user_notification_dto.dart';
import 'package:tour_booking/navigation/deep_link_navigator.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<NotificationsViewModel>().fetchNotifications(),
    );
  }

  void _onTapNotification(UserNotificationDto item) {
    final vm = context.read<NotificationsViewModel>();
    vm.markRead(item);

    // Link zorunlu değil — yoksa dokunuş sadece okundu işaretler
    final link = item.deepLink;
    if (link == null || link.isEmpty) return;
    final uri = Uri.tryParse(link);
    if (uri == null) return;
    final path = uri.hasScheme ? uri.path : link;
    if (path.isEmpty || !path.startsWith('/')) return;
    final location = uri.query.isNotEmpty ? '$path?${uri.query}' : path;
    openDeepLink(GoRouter.of(context), location);
  }

  String _formatTime(DateTime createdAt) {
    // Sunucu UTC gönderir; "Z" eki yoksa parse yereldir — UTC varsayıp düzelt
    final utc = createdAt.isUtc
        ? createdAt
        : DateTime.utc(
            createdAt.year,
            createdAt.month,
            createdAt.day,
            createdAt.hour,
            createdAt.minute,
            createdAt.second,
          );
    final local = utc.toLocal();
    final now = DateTime.now();
    final diff = now.difference(local);
    if (diff.inMinutes < 1) return tr('notifications_just_now');
    if (diff.inMinutes < 60) {
      return tr('notifications_minutes_ago',
          namedArgs: {'count': '${diff.inMinutes}'});
    }
    if (diff.inHours < 24) {
      return tr('notifications_hours_ago',
          namedArgs: {'count': '${diff.inHours}'});
    }
    if (diff.inDays < 7) {
      return tr('notifications_days_ago',
          namedArgs: {'count': '${diff.inDays}'});
    }
    return DateFormat('dd.MM.yyyy').format(local);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationsViewModel>();
    final scheme = context.colors;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/home'),
        ),
        title: Text(
          tr('notifications_title'),
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          // Tümünü okundu yap — çift tik (yalnızca okunmamış varken görünür)
          if (vm.unreadCount > 0)
            IconButton(
              onPressed: vm.markAllRead,
              tooltip: tr('notifications_mark_all_read'),
              icon: const Icon(
                Icons.done_all,
                color: AppColors.accent,
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: vm.fetchNotifications,
        child: vm.isLoading && vm.items.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : vm.items.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: EmptyState(
                          icon: SolarIconsOutline.bell,
                          title: tr('notifications_empty_title'),
                          subtitle: tr('notifications_empty_subtitle'),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    itemCount: vm.items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.s),
                    itemBuilder: (context, index) {
                      final item = vm.items[index];
                      return Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => vm.deleteNotification(item),
                        background: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.error,
                            borderRadius:
                                BorderRadius.circular(AppRadius.large),
                          ),
                          child: Icon(
                            SolarIconsOutline.trashBinTrash,
                            color: context.colors.onError,
                          ),
                        ),
                        child: _NotificationCard(
                          item: item,
                          timeText: _formatTime(item.createdAt),
                          onTap: () => _onTapNotification(item),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final UserNotificationDto item;
  final String timeText;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.item,
    required this.timeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final hasLink = item.deepLink != null && item.deepLink!.isNotEmpty;
    final isUnread = !item.isRead;

    return Material(
      color: isUnread
          ? AppColors.accent.withValues(alpha: 0.06)
          : scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        side: BorderSide(
          color: isUnread
              ? AppColors.accent.withValues(alpha: 0.25)
              : scheme.onSurfaceVariant.withValues(alpha: 0.12),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Zil ikonu — okunmamışsa marka turuncusu, okunduysa soluk
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnread
                      ? AppColors.accent
                      : scheme.onSurfaceVariant.withValues(alpha: 0.1),
                ),
                child: Icon(
                  isUnread ? SolarIconsBold.bell : SolarIconsOutline.bell,
                  size: 20,
                  color: isUnread
                      ? Colors.white
                      : scheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: isUnread
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsetsDirectional.only(
                                start: AppSpacing.xs),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accent,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.message,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Text(
                          timeText,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: scheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                          ),
                        ),
                        const Spacer(),
                        if (hasLink)
                          Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: scheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
