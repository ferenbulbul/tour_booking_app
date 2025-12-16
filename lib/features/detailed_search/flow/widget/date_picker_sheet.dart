import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary;

    return SafeArea(
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        ),
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Handle Bar
            Container(
              width: 42,
              height: 5,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(.22)
                    : Colors.black.withOpacity(.18),
                borderRadius: BorderRadius.circular(40),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: TableCalendar(
                firstDay: widget.firstDate,
                lastDay: widget.lastDate,
                focusedDay: focusedDate,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarFormat: CalendarFormat.month,

                selectedDayPredicate: (day) => isSameDay(selectedDate, day),

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
                  titleTextStyle: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: isDark ? Colors.white70 : Colors.black54,
                    size: 22,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: isDark ? Colors.white70 : Colors.black54,
                    size: 22,
                  ),
                ),

                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white70
                        : Colors.black.withOpacity(.65),
                  ),
                  weekendStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white70
                        : Colors.black.withOpacity(.65),
                  ),
                ),

                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  weekendTextStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  outsideTextStyle: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white24 : Colors.grey.shade400,
                  ),

                  disabledTextStyle: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                  ),

                  selectedDecoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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

                  cellMargin: const EdgeInsets.all(6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
