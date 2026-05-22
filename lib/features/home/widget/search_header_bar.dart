import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class SearchHeaderBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onBack;

  const SearchHeaderBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hasQuery,
    required this.onChanged,
    required this.onClear,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.m, AppSpacing.l, AppSpacing.s),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: context.ext.surfaceDark,
          borderRadius: BorderRadius.circular(AppRadius.ml),
          border: Border.all(color: context.colors.outline),
        ),
        padding: const EdgeInsets.only(right: AppSpacing.sm),
        child: Row(
          children: [
            Material(
              color: Colors.transparent,
              child: Semantics(
                button: true,
                label: 'Go back',
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  onTap: onBack,
                  child: SizedBox(
                    width: 48,
                    height: 52,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: AppIconSize.ml,
                      color: context.colors.onSurface,
                      semanticLabel: 'Back',
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                textInputAction: TextInputAction.search,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: tr("enter_place_name_example"),
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: context.ext.textLight,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.ml),
                ),
                onChanged: onChanged,
              ),
            ),
            if (hasQuery)
              Material(
                color: Colors.transparent,
                child: Semantics(
                  button: true,
                  label: 'Clear search',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    onTap: onClear,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.ms),
                      child: Icon(
                        Icons.close_rounded,
                        size: AppIconSize.l,
                        color: context.colors.onSurfaceVariant,
                        semanticLabel: 'Clear search',
                      ),
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
