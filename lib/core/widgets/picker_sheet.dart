import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class PickerSheet extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<PickerOption> options;
  final String? initialId;

  const PickerSheet({
    super.key,
    required this.title,
    this.icon = SolarIconsOutline.buildings_3,
    required this.options,
    required this.initialId,
  });

  @override
  State<PickerSheet> createState() => _PickerSheetState();
}

class _PickerSheetState extends State<PickerSheet> {
  String query = '';
  Timer? _debounce;

  List<PickerOption> get filtered {
    if (query.isEmpty) return widget.options;
    final q = query.toLowerCase();
    return widget.options
        .where((o) => o.name.toLowerCase().contains(q))
        .toList();
  }

  void _onSearchChanged(String v) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 130), () {
      if (query != v) {
        setState(() => query = v);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) {
        return Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
            ),
            padding: const EdgeInsetsDirectional.only(top: AppSpacing.ms),
            child: Column(
              children: [
                // ── Handle Bar ──
                Container(
                  width: 42,
                  height: 5,
                  margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.ml),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(AppRadius.circular),
                  ),
                ),

                // ── Header ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  child: Row(
                    children: [
                      Container(
                        width: AppIconSize.xxxl,
                        height: AppIconSize.xxxl,
                        decoration: BoxDecoration(
                          color: context.colors.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.ms),
                        ),
                        child: Icon(
                          widget.icon,
                          size: AppIconSize.ml,
                          color: context.colors.secondary,
                          semanticLabel: widget.title,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.ml),

                // ── Search Bar ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    child: TextField(
                      onChanged: _onSearchChanged,
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          SolarIconsOutline.magnifier,
                          color: context.ext.textLight,
                          size: AppIconSize.l,
                          semanticLabel: 'Search',
                        ),
                        hintText: 'search_placeholder'.tr(),
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: context.ext.textLight,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.m,
                          horizontal: AppSpacing.m,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.m),

                // ── Liste ──
                Expanded(
                  child: ListView.separated(
                    controller: controller,
                    itemCount: filtered.length,
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.l, AppSpacing.xs, AppSpacing.l, AppSpacing.xl + bottomInset,
                    ),
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s),
                    itemBuilder: (_, i) {
                      final item = filtered[i];
                      final isSelected = item.id == widget.initialId;

                      return Semantics(
                        button: true,
                        label: 'Select ${item.name}',
                        child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        onTap: () => Navigator.pop(context, item.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.ml,
                            horizontal: AppSpacing.l,
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
                              Expanded(
                                child: Text(
                                  item.name,
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
                                  size: AppIconSize.l,
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
        },
      );
  }
}

class PickerOption {
  final String id;
  final String name;
  const PickerOption(this.id, this.name);
}
