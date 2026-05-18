import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';

Color bookingStatusColor(String status) {
  final s = status.toLowerCase();

  if (s == "completed") {
    return AppColors.success;
  }

  if (s == "cancelled") {
    return AppColors.error;
  }

  if (s == "cancellationpending") {
    return const Color(0xFF8B5CF6);
  }

  return AppColors.primary;
}

String bookingStatusLabel(String status, DateTime departureDate) {
  final s = status.toLowerCase();
  final now = DateTime.now();

  if (s == "completed") return 'booking_tab_completed'.tr();
  if (s == "cancelled") return 'booking_tab_cancelled'.tr();

  if (s == "cancellationpending") {
    return "pending_approvel".tr();
  }

  if (isSameDay(departureDate, now)) {
    return 'today'.tr();
  }

  if (departureDate.isAfter(now)) {
    return 'booking_tab_upcoming'.tr();
  }

  return status;
}

bool isCancelableStatus(String status) {
  final s = status.toLowerCase();
  return !(s == "completed" || s == "cancelled");
}

String formatCurrency(num? v) {
  if (v == null) return "—";

  final f = NumberFormat.currency(
    locale: "tr_TR",
    symbol: "₺",
    decimalDigits: 2,
  );

  return f.format(v);
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool canCancelWithTimeLimit(String departureDate, String departureTime) {
  if (departureDate.isEmpty || departureTime.isEmpty) return false;
  final departure = parseDepartureDateTime(departureDate, departureTime);

  return departure.isAfter(DateTime.now().add(const Duration(hours: 12)));
}

DateTime parseDepartureDateTime(String date, String time) {
  final parts = time.split(':');

  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);

  final d = DateTime.parse(date);

  return DateTime(d.year, d.month, d.day, hour, minute);
}

/// Returns a countdown text like "Bugün", "Yarın", "3 gün sonra"
String getCountdownText(DateTime departureDate) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dep =
      DateTime(departureDate.year, departureDate.month, departureDate.day);
  final days = dep.difference(today).inDays;

  if (days < 0) return '';
  if (days == 0) return 'today'.tr();
  if (days == 1) return 'Yarın';
  if (days <= 7) return '$days gün sonra';
  return '$days gün sonra';
}
