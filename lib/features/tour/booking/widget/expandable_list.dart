import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class ExpandableList extends StatefulWidget {
  final List<Widget> children;
  final int maxVisible;

  const ExpandableList({
    super.key,
    required this.children,
    this.maxVisible = 3,
  });

  @override
  State<ExpandableList> createState() => _ExpandableListState();
}

class _ExpandableListState extends State<ExpandableList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final total = widget.children.length;
    final needsExpand = total > widget.maxVisible;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 280),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.children.take(widget.maxVisible.clamp(0, total)).toList(),
          ),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.children,
          ),
        ),
        if (needsExpand)
          Semantics(
            button: true,
            label: _expanded ? 'Show less' : 'Show more',
            child: GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.s),
                child: Row(
                  children: [
                    Text(
                      _expanded
                          ? tr("show_less")
                          : tr("show_more_count", namedArgs: {
                              "count": "${total - widget.maxVisible}",
                            }),
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
    );
  }
}
