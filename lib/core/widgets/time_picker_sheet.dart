import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class TimePickerSheet extends StatelessWidget {
  final List<String> times;
  final String initial;
  final Function(String) onSelected;

  const TimePickerSheet({
    super.key,
    required this.times,
    required this.initial,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxlm)),
        ),
        padding: const EdgeInsetsDirectional.only(top: 10),
        child: Column(
          children: [
            // -- Handle Bar --
            Container(
              width: 42,
              height: 5,
              margin: const EdgeInsetsDirectional.only(bottom: 14),
              decoration: BoxDecoration(
                color: context.colors.onSurfaceVariant.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(AppRadius.huge),
              ),
            ),

            // -- Header --
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
                      size: 18,
                      color: context.colors.secondary,
                      semanticLabel: 'Select time',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Text(
                    'time_select'.tr(),
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.m),

            // -- Liste --
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.l, 4, AppSpacing.l, 20 + bottomInset,
                ),
                itemCount: times.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s),
                itemBuilder: (context, index) {
                  final time = times[index];
                  final isSelected = time == initial;

                  return Semantics(
                    button: true,
                    label: 'Select time $time',
                    child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    onTap: () {
                      onSelected(time);
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        color: isSelected
                            ? context.colors.secondary
                            : context.colors.surfaceContainerHighest,
                        border: Border.all(
                          color: isSelected
                              ? context.colors.secondary
                              : context.colors.outline,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            SolarIconsOutline.clockCircle,
                            size: 18,
                            color: isSelected
                                ? context.colors.onSecondary
                                : context.ext.textLight,
                            semanticLabel: 'Time',
                          ),
                          const SizedBox(width: AppSpacing.m),
                          Expanded(
                            child: Text(
                              time,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? context.colors.onSecondary
                                    : context.colors.onSurface,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              SolarIconsOutline.checkCircle,
                              size: 20,
                              color: context.colors.onSecondary,
                              semanticLabel: 'Selected',
                            ),
                        ],
                      ),
                    ),
                  ),
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
}
