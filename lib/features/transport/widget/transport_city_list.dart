import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

/// Scroll-wheel time picker (saat:dakika) used on the transport booking screen.
class TransportTimePicker extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final FixedExtentScrollController hourController;
  final FixedExtentScrollController minuteController;
  final void Function(int hour, int minute) onConfirm;

  const TransportTimePicker({
    super.key,
    required this.initialHour,
    required this.initialMinute,
    required this.hourController,
    required this.minuteController,
    required this.onConfirm,
  });

  @override
  State<TransportTimePicker> createState() => _TransportTimePickerState();
}

class _TransportTimePickerState extends State<TransportTimePicker> {
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialHour;
    _minute = widget.initialMinute;
  }

  @override
  void dispose() {
    widget.hourController.dispose();
    widget.minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      padding: EdgeInsets.fromLTRB(0, AppSpacing.ms, 0, AppSpacing.l + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 42,
            height: 5,
            margin: const EdgeInsets.only(bottom: AppSpacing.ml),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppRadius.circular),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: context.colors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.ms),
                  ),
                  child: Icon(
                    SolarIconsOutline.clockCircle,
                    size: AppIconSize.ml,
                    color: context.colors.secondary,
                    semanticLabel: 'Time',
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Text(
                  tr('time_select'),
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colors.onSurface,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.l),

          // Wheel pickers
          SizedBox(
            height: 200,
            child: Row(
              children: [
                // Hour wheel
                Expanded(
                  child: _buildWheel(
                    controller: widget.hourController,
                    itemCount: 24,
                    labelBuilder: (i) => i.toString().padLeft(2, '0'),
                    onChanged: (i) => setState(() => _hour = i),
                  ),
                ),

                // Separator
                Text(
                  ':',
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colors.onSurface,
                  ),
                ),

                // Minute wheel
                Expanded(
                  child: _buildWheel(
                    controller: widget.minuteController,
                    itemCount: 60,
                    labelBuilder: (i) => i.toString().padLeft(2, '0'),
                    onChanged: (i) => setState(() => _minute = i),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.l),

          // Confirm button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Material(
                color: context.colors.secondary,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  onTap: () {
                    widget.onConfirm(_hour, _minute);
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      tr('confirm'),
                      style: AppTextStyles.titleSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String Function(int) labelBuilder,
    required ValueChanged<int> onChanged,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 48,
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: 1.5,
      perspective: 0.003,
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          final isHour = controller == widget.hourController;
          final isSelected =
              isHour ? index == _hour : index == _minute;

          return Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: (isSelected ? AppTextStyles.headlineSmall : AppTextStyles.titleSmall).copyWith(
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected
                    ? context.colors.secondary
                    : context.ext.textLight,
              ),
              child: Text(labelBuilder(index)),
            ),
          );
        },
      ),
    );
  }
}
