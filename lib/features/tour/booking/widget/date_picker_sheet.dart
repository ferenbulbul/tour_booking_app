import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'dart:ui' as ui;

class DatePickerSheet extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const DatePickerSheet({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<DatePickerSheet> {
  late DateTime selectedDate;
  late DateTime focusedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    focusedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final primary = scheme.secondary;
    final locale = context.locale;
    final isRtl = locale.languageCode == 'ar';

    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
        ),
        padding: const EdgeInsetsDirectional.only(top: AppSpacing.ms, bottom: AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Handle Bar
            Container(
              width: 42,
              height: AppSpacing.xsm,
              margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.ml),
              decoration: BoxDecoration(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(AppRadius.circular),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Directionality(
                textDirection: isRtl
                    ? ui.TextDirection.rtl
                    : ui.TextDirection.ltr,
                child: TableCalendar(
                  locale: locale.toString(),
                  firstDay: widget.firstDate,
                  lastDay: widget.lastDate,
                  focusedDay: focusedDate,
                  startingDayOfWeek: isRtl
                      ? StartingDayOfWeek.sunday
                      : StartingDayOfWeek.monday,
                  calendarFormat: CalendarFormat.month,

                  selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                  enabledDayPredicate: (day) {
                    final today = DateTime.now();

                    return !isSameDay(day, today);
                  },
                  onDaySelected: (day, focus) {
                    setState(() {
                      selectedDate = day;
                      focusedDate = focus;
                    });
                    Navigator.pop(context, day);
                  },

                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: AppTextStyles.bodyLargeEmphasis.copyWith(
                      color: scheme.onSurface,
                    ),
                    leftChevronIcon: Icon(
                      isRtl ? SolarIconsOutline.arrowRight : SolarIconsOutline.altArrowLeft,
                      color: scheme.onSurfaceVariant,
                      size: AppIconSize.xxl,
                      semanticLabel: 'Previous month',
                    ),
                    rightChevronIcon: Icon(
                      isRtl ? SolarIconsOutline.altArrowLeft : SolarIconsOutline.arrowRight,
                      color: scheme.onSurfaceVariant,
                      size: AppIconSize.xxl,
                      semanticLabel: 'Next month',
                    ),
                  ),

                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                    weekendStyle: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),

                  calendarStyle: CalendarStyle(
                    defaultTextStyle: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: scheme.onSurface,
                    ),
                    weekendTextStyle: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: scheme.onSurface,
                    ),
                    outsideTextStyle: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w400,
                      color: context.ext.textLight,
                    ),

                    disabledTextStyle: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w400,
                      color: context.ext.textLight,
                    ),

                    selectedDecoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: AppTextStyles.labelLarge.copyWith(
                      color: scheme.onSecondary,
                      fontWeight: FontWeight.w600,
                    ),

                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primary, width: 1.2),
                    ),
                    todayTextStyle: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w700,
                    ),

                    cellMargin: const EdgeInsets.all(AppSpacing.sm),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
