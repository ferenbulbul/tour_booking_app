import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class AccordionSection extends StatefulWidget {
  final String title;
  final Widget content;
  final bool initiallyExpanded;
  final bool collapsible;

  const AccordionSection({
    super.key,
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
    this.collapsible = true,
  });

  @override
  State<AccordionSection> createState() => _AccordionSectionState();
}

class _AccordionSectionState extends State<AccordionSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.collapsible ? widget.initiallyExpanded : true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Semantics(
          button: widget.collapsible,
          label: widget.collapsible
              ? (_isExpanded ? 'Collapse ${widget.title}' : 'Expand ${widget.title}')
              : widget.title,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.collapsible
                ? () => setState(() => _isExpanded = !_isExpanded)
                : null,
            child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.l),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: context.colors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (widget.collapsible)
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: context.colors.onSurfaceVariant,
                      size: AppIconSize.xl,
                      semanticLabel: _isExpanded ? 'Collapse' : 'Expand',
                    ),
                  ),
              ],
            ),
          ),
        ),
        ),
        // Content — only built when expanded (saves CPU for collapsed sections)
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: _isExpanded
              ? Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.l),
                  child: widget.content,
                )
              : const SizedBox(width: double.infinity, height: 0),
        ),
        // Divider
        Divider(
          color: context.colors.outline,
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
