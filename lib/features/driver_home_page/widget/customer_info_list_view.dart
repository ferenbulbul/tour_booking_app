import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/enum/driver_booking_status.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/empty_state.dart';
import 'package:tour_booking/features/driver_home_page/widget/dashboard_booking_detail_sheet.dart';
import 'package:tour_booking/models/customer_info_for_driver/customer_info.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class CustomerInfoListView extends StatelessWidget {
  const CustomerInfoListView({
    super.key,
    required this.items,
    this.onCompleteDropoff,
  });

  final List<CustomerInfo> items;
  final Future<bool> Function(String bookingId)? onCompleteDropoff;

  String _statusLabel(CustomerInfo item) {
    switch (item.status) {
      case DriverBookingStatus.today:
        return tr('today');
      case DriverBookingStatus.upcoming:
        return tr('booking_tab_upcoming');
    }
  }

  Color _statusColor(BuildContext context, CustomerInfo item) {
    switch (item.status) {
      case DriverBookingStatus.today:
        return context.ext.success;
      case DriverBookingStatus.upcoming:
        return context.ext.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return EmptyState(
        icon: SolarIconsOutline.box,
        title: tr('driver_no_active_customer'),
        subtitle: tr('driver_new_requests_will_appear'),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
      itemBuilder: (context, index) {
        final item = items[index];
        final isTransport = item.bookingType == 1;
        final scheme = context.colors;
        final statusColor = _statusColor(context, item);

        return Material(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: InkWell(
            onTap: () => showDashboardBookingDetailSheet(
              context,
              item: item,
              onCompleteDropoff: onCompleteDropoff,
            ),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.ml),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(
                  color: scheme.outline.withValues(alpha: 0.12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOP ROW: icon + title + status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.08),
                          borderRadius:
                              BorderRadius.circular(AppRadius.medium),
                        ),
                        child: Icon(
                          isTransport
                              ? SolarIconsOutline.routing
                              : SolarIconsOutline.map,
                          color: scheme.primary,
                          size: AppIconSize.lm,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              isTransport
                                  ? tr('transport_title')
                                  : (item.departureDescription.isNotEmpty
                                      ? item.departureDescription
                                      : item.tourPointName),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: scheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),

                            // Date + time
                            Row(
                              children: [
                                Icon(
                                  SolarIconsOutline.calendarDate,
                                  size: AppIconSize.s,
                                  color: context.ext.textLight,
                                ),
                                const SizedBox(width: AppSpacing.xsm),
                                Text(
                                  item.tourDate,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: context.ext.textLight,
                                  ),
                                ),
                                if (item.departureTime != null &&
                                    item.departureTime!.isNotEmpty) ...[
                                  Container(
                                    width: 3,
                                    height: 3,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.s),
                                    decoration: BoxDecoration(
                                      color: context.ext.textLight,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Icon(
                                    SolarIconsOutline.clockCircle,
                                    size: AppIconSize.s,
                                    color: context.ext.textLight,
                                  ),
                                  const SizedBox(width: AppSpacing.xsm),
                                  Text(
                                    item.departureTime!,
                                    style:
                                        AppTextStyles.labelSmall.copyWith(
                                      color: context.ext.textLight,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // CUSTOMER + ROUTE SUMMARY
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 48 + AppSpacing.m,
                      top: AppSpacing.s,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer
                        Row(
                          children: [
                            Icon(
                              SolarIconsOutline.user,
                              size: AppIconSize.s,
                              color: context.ext.textLight,
                            ),
                            const SizedBox(width: AppSpacing.xsm),
                            Flexible(
                              child: Text(
                                item.cutomerFullName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Transport route summary
                        if (isTransport &&
                            item.pickupAddress != null &&
                            item.dropoffAddress != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Icon(
                                SolarIconsOutline.route,
                                size: AppIconSize.s,
                                color: context.ext.textLight,
                              ),
                              const SizedBox(width: AppSpacing.xsm),
                              Flexible(
                                child: Text(
                                  '${item.pickupAddress} → ${item.dropoffAddress}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      AppTextStyles.labelSmall.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.ms),

                  // DIVIDER
                  Divider(
                    height: 1,
                    color: scheme.outline.withValues(alpha: 0.12),
                  ),

                  const SizedBox(height: AppSpacing.ms),

                  // BOTTOM ROW: status badge + chevron
                  Row(
                    children: [
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s,
                          vertical: AppSpacing.xxxs,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.sm),
                        ),
                        child: Text(
                          _statusLabel(item),
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),

                      // Transport badge
                      if (isTransport) ...[
                        const SizedBox(width: AppSpacing.s),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s,
                            vertical: AppSpacing.xxxs,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.primary.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.sm),
                          ),
                          child: Text(
                            tr('transport_title'),
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: scheme.primary,
                            ),
                          ),
                        ),
                      ],

                      const Spacer(),

                      // Chevron
                      Icon(
                        SolarIconsOutline.altArrowRight,
                        size: AppIconSize.ml,
                        color: scheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
