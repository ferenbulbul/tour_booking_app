import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/enum/driver_booking_status.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/models/customer_info_for_driver/customer_info.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showDashboardBookingDetailSheet(
  BuildContext context, {
  required CustomerInfo item,
  Future<bool> Function(String bookingId)? onCompleteDropoff,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => _DashboardBookingDetailSheet(
        item: item,
        scrollController: scrollController,
        onCompleteDropoff: onCompleteDropoff,
      ),
    ),
  );
}

class _DashboardBookingDetailSheet extends StatelessWidget {
  const _DashboardBookingDetailSheet({
    required this.item,
    required this.scrollController,
    this.onCompleteDropoff,
  });

  final CustomerInfo item;
  final ScrollController scrollController;
  final Future<bool> Function(String bookingId)? onCompleteDropoff;

  bool get _isTransport => item.bookingType == 1;

  String _statusLabel() {
    switch (item.status) {
      case DriverBookingStatus.today:
        return tr('today');
      case DriverBookingStatus.upcoming:
        return tr('booking_tab_upcoming');
    }
  }

  Color _statusColor(BuildContext context) {
    switch (item.status) {
      case DriverBookingStatus.today:
        return context.ext.success;
      case DriverBookingStatus.upcoming:
        return context.ext.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final statusColor = _statusColor(context);

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xxl),
        children: [
          // DRAG HANDLE
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: AppSpacing.m, bottom: AppSpacing.m),
              child: Container(
                width: AppSpacing.xxxxl,
                height: AppSpacing.xs,
                decoration: BoxDecoration(
                  color: scheme.outline,
                  borderRadius: BorderRadius.circular(AppSpacing.xxs),
                ),
              ),
            ),
          ),

          // HEADER: icon + title + status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Icon(
                  _isTransport
                      ? SolarIconsOutline.routing
                      : SolarIconsOutline.map,
                  color: scheme.primary,
                  size: AppIconSize.lm,
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isTransport
                          ? tr('transport_title')
                          : tr('tour_title'),
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxs),
                    Text(
                      _isTransport
                          ? (item.pickupAddress ?? item.departureDescription)
                          : item.departureDescription,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.ms,
                  vertical: AppSpacing.xsm,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: Text(
                  _statusLabel(),
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // DIVIDER
          Divider(
            height: 1,
            color: scheme.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.l),

          // INFO ROWS
          // Date + time
          _infoRow(
            context,
            SolarIconsOutline.calendarDate,
            tr('booking_label_time'),
            item.departureTime != null && item.departureTime!.isNotEmpty
                ? '${item.tourDate}  •  ${item.departureTime}'
                : item.tourDate,
          ),

          // Customer
          _infoRow(
            context,
            SolarIconsOutline.user,
            tr('driver_customer'),
            item.cutomerFullName,
          ),

          // Phone
          _infoRow(
            context,
            SolarIconsOutline.phone,
            tr('driver_phone'),
            item.customerPhoneNumber,
            trailing: IconButton(
              tooltip: tr('contact_via_whatsapp'),
              icon: FaIcon(
                FontAwesomeIcons.whatsapp,
                color: context.ext.success,
                size: AppIconSize.xl,
              ),
              onPressed: () =>
                  _openWhatsApp(context, item.customerPhoneNumber),
            ),
          ),

          // Vehicle
          if (item.vehicleName != null &&
              item.vehicleName!.trim().isNotEmpty) ...[
            _infoRow(
              context,
              SolarIconsOutline.bus,
              tr('driver_vehicle_info'),
              '${item.vehicleName!.trim()}  •  ${item.vehiclePlate ?? "-"}  •  ${item.vehicleSeatCount ?? "-"} ${tr("driver_vehicle_seats")}',
            ),
          ],

          if (_isTransport) ...[
            // TRANSPORT: Pickup → Dropoff
            _infoRow(
              context,
              SolarIconsOutline.mapPoint,
              tr('transport_pickup'),
              item.pickupAddress ?? '-',
            ),
            _infoRow(
              context,
              SolarIconsOutline.mapPointWave,
              tr('transport_dropoff'),
              item.dropoffAddress ?? '-',
            ),

            // Navigate route button
            if (item.pickupLatitude != null && item.dropoffLatitude != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.ml),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: Icon(
                      SolarIconsOutline.routing,
                      size: AppIconSize.ml,
                    ),
                    label: Text(tr('driver_navigate_route')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: scheme.primary,
                      side: BorderSide(color: scheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.medium),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.ms),
                    ),
                    onPressed: () => _openDirections(
                      originLat: item.pickupLatitude!,
                      originLng: item.pickupLongitude!,
                      destLat: item.dropoffLatitude!,
                      destLng: item.dropoffLongitude!,
                      routePolyline: item.routePolyline,
                    ),
                  ),
                ),
              ),
          ] else ...[
            // TOUR: Departure point
            _infoRow(
              context,
              SolarIconsOutline.mapPoint,
              tr('booking_label_departure_location'),
              item.tourPointName,
              trailing: IconButton(
                tooltip: tr('open_on_map'),
                icon: Icon(
                  SolarIconsOutline.map,
                  size: AppIconSize.ml,
                  color: scheme.primary,
                ),
                onPressed: () => _openMap(
                    item.departureLatitude, item.departureLongitude),
              ),
            ),

            // GUIDE INFO
            if (item.hasGuide && item.guideName != null) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                margin: const EdgeInsets.only(bottom: AppSpacing.ml),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Row(
                  children: [
                    Icon(
                      SolarIconsOutline.usersGroupRounded,
                      size: AppIconSize.l,
                      color: scheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr('driver_guide_info'),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxxs),
                          Text(
                            item.guideName!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: scheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (item.guidePhoneNumber != null) ...[
                            const SizedBox(height: AppSpacing.xxxs),
                            Text(
                              item.guidePhoneNumber!,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (item.guidePhoneNumber != null)
                      IconButton(
                        tooltip: tr('contact_via_whatsapp'),
                        icon: FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: context.ext.success,
                          size: AppIconSize.xl,
                        ),
                        onPressed: () =>
                            _openWhatsApp(context, item.guidePhoneNumber!),
                      ),
                  ],
                ),
              ),
            ] else if (!item.hasGuide) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.ms,
                ),
                margin: const EdgeInsets.only(bottom: AppSpacing.ml),
                decoration: BoxDecoration(
                  color: context.ext.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(
                    color: context.ext.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      SolarIconsOutline.dangerTriangle,
                      size: AppIconSize.l,
                      color: context.ext.warning,
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Text(
                        tr('driver_no_guide_warning'),
                        style: AppTextStyles.labelMedium.copyWith(
                          color: context.ext.warning,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ROUTE POINTS
            if (item.routePoints.isNotEmpty) ...[
              Text(
                tr('driver_route_points'),
                style: AppTextStyles.labelMedium.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              ...List.generate(item.routePoints.length, (i) {
                final point = item.routePoints[i];
                final isLast = i == item.routePoints.length - 1;
                return _buildRoutePointRow(
                  context,
                  i + 1,
                  point.name,
                  point.latitude,
                  point.longitude,
                  isLast,
                );
              }),
              const SizedBox(height: AppSpacing.m),
            ],
          ],

          // TRANSPORT: Dropoff button
          if (_isTransport && item.bookingId != null) ...[
            const SizedBox(height: AppSpacing.s),
            if (item.status == DriverBookingStatus.today)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    SolarIconsOutline.checkCircle,
                  ),
                  label: Text(tr('driver_transport_dropoff')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.ext.success,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.ml,
                    ),
                  ),
                  onPressed: () => _confirmDropoff(context, item),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    SolarIconsOutline.checkCircle,
                  ),
                  label: Text(tr('driver_transport_dropoff')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.onSurface.withValues(alpha: 0.12),
                    foregroundColor: scheme.onSurface.withValues(alpha: 0.38),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.ml,
                    ),
                  ),
                  onPressed: null,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.ml),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppIconSize.xxxl,
            height: AppIconSize.xxxl,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.ms),
            ),
            child: Icon(icon,
                size: AppIconSize.ml,
                color: context.colors.onSurfaceVariant),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: context.ext.textLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  value,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: context.colors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildRoutePointRow(
    BuildContext context,
    int index,
    String name,
    double lat,
    double lng,
    bool isLast,
  ) {
    final scheme = context.colors;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$index',
                    style: AppTextStyles.caption.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: scheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : AppSpacing.ms,
              ),
              child: InkWell(
                onTap: () => _openMap(lat, lng),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                    Icon(
                      SolarIconsOutline.mapPoint,
                      size: AppIconSize.s,
                      color: scheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDropoff(BuildContext context, CustomerInfo item) {
    final scheme = context.colors;
    final parentContext = context;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
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
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                tr('driver_transport_dropoff_confirm'),
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                tr('driver_transport_dropoff_confirm_message'),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: scheme.onSurfaceVariant,
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
                          foregroundColor: scheme.onSurfaceVariant,
                          padding: EdgeInsets.zero,
                          side: BorderSide(color: scheme.outline),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.medium),
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          tr('cancel'),
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.medium),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(ctx);
                          final success = await onCompleteDropoff
                              ?.call(item.bookingId!);
                          if (success == true && parentContext.mounted) {
                            Navigator.pop(parentContext);
                            UIHelper.showSuccess(parentContext,
                                tr('driver_transport_dropoff_success'));
                          }
                        },
                        child: Text(
                          tr('confirm'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

Future<void> _openMap(double lat, double lng) async {
  final googleMapsUrl = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
  );

  if (await canLaunchUrl(googleMapsUrl)) {
    await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
  }
}

Future<void> _openDirections({
  required double originLat,
  required double originLng,
  required double destLat,
  required double destLng,
  String? routePolyline,
}) async {
  final wpList = <String>[];

  if (routePolyline != null && routePolyline.isNotEmpty) {
    final points = _decodePolyline(routePolyline);
    if (points.length > 2) {
      final waypointCount = points.length < 13 ? points.length - 2 : 10;
      final step = (points.length - 1) / (waypointCount + 1);
      for (int i = 1; i <= waypointCount; i++) {
        final idx = (step * i).round();
        if (idx > 0 && idx < points.length - 1) {
          wpList.add('${points[idx].$1},${points[idx].$2}');
        }
      }
    }
  }

  if (Platform.isIOS) {
    final gmapsAppUrl = _buildGoogleMapsAppUrl(
      originLat, originLng, destLat, destLng, wpList,
    );
    final gmapsAppUri = Uri.parse(gmapsAppUrl);

    if (await canLaunchUrl(gmapsAppUri)) {
      await launchUrl(gmapsAppUri, mode: LaunchMode.externalApplication);
      return;
    }

    final webUrl = _buildGoogleMapsWebUrl(
      originLat, originLng, destLat, destLng, wpList,
    );
    final webUri = Uri.parse(webUrl);
    if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  } else {
    final url = _buildGoogleMapsWebUrl(
      originLat, originLng, destLat, destLng, wpList,
    );
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

String _buildGoogleMapsAppUrl(
  double originLat,
  double originLng,
  double destLat,
  double destLng,
  List<String> waypoints,
) {
  final wp =
      waypoints.isNotEmpty ? '+to:${waypoints.join('+to:')}' : '';
  return 'comgooglemaps://?saddr=$originLat,$originLng'
      '&daddr=$destLat,$destLng$wp'
      '&directionsmode=driving';
}

String _buildGoogleMapsWebUrl(
  double originLat,
  double originLng,
  double destLat,
  double destLng,
  List<String> waypoints,
) {
  final wp =
      waypoints.isNotEmpty ? '&waypoints=${waypoints.join('|')}' : '';
  return 'https://www.google.com/maps/dir/?api=1'
      '&origin=$originLat,$originLng'
      '&destination=$destLat,$destLng'
      '$wp'
      '&travelmode=driving';
}

List<(double, double)> _decodePolyline(String encoded) {
  final points = <(double, double)>[];
  int index = 0, lat = 0, lng = 0;
  while (index < encoded.length) {
    int shift = 0, result = 0, b;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);
    lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);
    lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
    points.add((lat / 1E5, lng / 1E5));
  }
  return points;
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
