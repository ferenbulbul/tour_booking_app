import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/enum/driver_booking_status.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/models/customer_info_for_driver/customer_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
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

  Future<void> _openMap(double lat, double lng) async {
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxxxl),
        child: Column(
          children: [
            const Icon(SolarIconsOutline.box, size: AppIconSize.colossal, semanticLabel: 'No bookings'),
            const SizedBox(height: AppSpacing.m),
            Text(
              tr('driver_no_active_customer'),
              style: AppTextStyles.titleSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              tr('driver_new_requests_will_appear'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER + STATUS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (isTransport)
                            Padding(
                              padding: const EdgeInsets.only(right: AppSpacing.s),
                              child: Icon(SolarIconsOutline.routing,
                                  size: AppIconSize.l, color: context.colors.primary, semanticLabel: 'Transport route'),
                            ),
                          Expanded(
                            child: Text(
                              isTransport
                                  ? (item.pickupAddress ?? item.departureDescription)
                                  : item.departureDescription,
                              style: context.textStyles.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Chip(label: Text(_statusLabel(item))),
                  ],
                ),

                const SizedBox(height: AppSpacing.m),

                if (isTransport) ...[
                  // TRANSPORT: Pickup → Dropoff
                  _locationRow(
                    context,
                    Icons.circle,
                    context.ext.success,
                    'transport_pickup'.tr(),
                    item.pickupAddress ?? '-',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _locationRow(
                    context,
                    Icons.circle,
                    context.colors.error,
                    'transport_dropoff'.tr(),
                    item.dropoffAddress ?? '-',
                  ),
                  const SizedBox(height: AppSpacing.s),
                  if (item.dropoffLatitude != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        icon: const Icon(SolarIconsOutline.map, semanticLabel: 'Open map'),
                        label: Text('driver_open_dropoff_map'.tr()),
                        onPressed: () => _openMap(
                          item.dropoffLatitude!,
                          item.dropoffLongitude!,
                        ),
                      ),
                    ),
                ] else ...[
                  // TOUR
                  Text(
                    tr('departure_point'),
                    style: context.textStyles.labelMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    item.tourPointName,
                    style: AppTextStyles.bodyMedium.copyWith(color: context.colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      icon: const Icon(SolarIconsOutline.map, semanticLabel: 'Open map'),
                      label: Text(tr('open_on_map')),
                      onPressed: () => _openMap(
                        item.departureLatitude,
                        item.departureLongitude,
                      ),
                    ),
                  ),
                ],

                const Divider(height: 24),

                // CUSTOMER INFO
                Row(
                  children: [
                    const Icon(SolarIconsOutline.user, size: AppIconSize.ml, semanticLabel: 'Customer'),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text(item.cutomerFullName)),
                  ],
                ),
                const SizedBox(height: AppSpacing.s),
                Row(
                  children: [
                    const Icon(SolarIconsOutline.phone, size: AppIconSize.ml, semanticLabel: 'Phone number'),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        item.customerPhoneNumber,
                        style: AppTextStyles.labelLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: tr('contact_via_whatsapp'),
                      icon: FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: context.ext.success,
                      ),
                      onPressed: () =>
                          _openWhatsApp(context, item.customerPhoneNumber),
                    ),
                  ],
                ),

                // TRANSPORT: Dropoff button
                if (isTransport && item.bookingId != null) ...[
                  const SizedBox(height: AppSpacing.m),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(SolarIconsOutline.checkCircle, semanticLabel: 'Complete dropoff'),
                      label: Text('driver_transport_dropoff'.tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.ext.success,
                        foregroundColor: context.colors.onSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                        ),
                      ),
                      onPressed: () => _confirmDropoff(context, item),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _locationRow(BuildContext context, IconData icon, Color color, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: AppSpacing.ms, color: color, semanticLabel: label),
        const SizedBox(width: AppSpacing.s),
        Text('$label: ', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        Expanded(
          child: Text(value, style: AppTextStyles.bodySmall.copyWith(color: context.colors.onSurfaceVariant)),
        ),
      ],
    );
  }

  void _confirmDropoff(BuildContext context, CustomerInfo item) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: context.ext.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: Icon(
                  SolarIconsOutline.checkCircle,
                  size: AppIconSize.xxl,
                  color: context.ext.success,
                  semanticLabel: 'Confirm dropoff',
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                'driver_transport_dropoff_confirm'.tr(),
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'driver_transport_dropoff_confirm_message'.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.labelLarge.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.colors.onSurfaceVariant,
                          side: BorderSide(color: context.colors.outline),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('cancel'.tr()),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: context.ext.success,
                          foregroundColor: context.colors.onSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(ctx);
                          final success = await onCompleteDropoff?.call(item.bookingId!);
                          if (success == true && context.mounted) {
                            UIHelper.showSuccess(context, 'driver_transport_dropoff_success'.tr());
                          }
                        },
                        child: Text('confirm'.tr()),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _openWhatsApp(BuildContext context, String phone) async {
  final cleanPhone = phone.replaceAll('+', '').replaceAll(' ', '');

  final uri = Uri.parse(
    'https://wa.me/$cleanPhone?text=${Uri.encodeComponent(tr('whatsapp_greeting_message'))}',
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    UIHelper.showError(context, tr('whatsapp_not_available'));
  }
}
