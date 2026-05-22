import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class ShortDescriptionSection extends StatefulWidget {
  final String? shortDescription;
  final String fullDescription;

  const ShortDescriptionSection({
    super.key,
    this.shortDescription,
    required this.fullDescription,
  });

  @override
  State<ShortDescriptionSection> createState() =>
      _ShortDescriptionSectionState();
}

class _ShortDescriptionSectionState extends State<ShortDescriptionSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final hasShort =
        widget.shortDescription != null && widget.shortDescription!.isNotEmpty;
    final displayText = _expanded
        ? widget.fullDescription
        : (hasShort ? widget.shortDescription! : widget.fullDescription);

    final canExpand = hasShort && widget.fullDescription != widget.shortDescription;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 280),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Text(
              displayText,
              style: AppTextStyles.bodyMedium.copyWith(
                height: 1.45,
                color: context.colors.onSurfaceVariant,
              ),
            ),
            secondChild: Text(
              widget.fullDescription,
              style: AppTextStyles.bodyMedium.copyWith(
                height: 1.45,
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
          if (canExpand)
            Semantics(
              button: true,
              label: _expanded ? 'Collapse' : 'Expand',
              child: GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.m),
                  child: Row(
                    children: [
                      Text(
                        _expanded
                            ? tr("collapse_description")
                            : tr("read_full_description"),
                        style: AppTextStyles.labelLarge.copyWith(
                          color: context.colors.secondary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: AppIconSize.l,
                        color: context.colors.secondary,
                        semanticLabel: _expanded ? 'Collapse' : 'Expand',
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
}
