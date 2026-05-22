import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tour_booking/core/theme/app_bar_styles.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;

  /// Action button is fully provided from outside
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;

  /// Additional actions
  final List<Widget>? actions;

  final bool centerTitle;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBack = true,

    // Nearby places or another custom action
    this.actionIcon,
    this.onActionPressed,

    this.actions,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final text = context.textStyles;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: AppBarStyles.background(context),
      centerTitle: centerTitle,

      // 🔙 Back Button
      leading: showBack
          ? IconButton(
              tooltip: 'Back',
              icon: Icon(Icons.arrow_back_ios_new, color: scheme.onSurface, semanticLabel: 'Go back'),
              onPressed: () => context.pop(),
            )
          : null,

      // Title
      title: Text(
        title,
        style: text.titleLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: scheme.onSurface,
        ),
      ),

      // Actions
      actions: [
        /// If actionIcon is provided, create a button
        if (actionIcon != null)
          IconButton(
            tooltip: 'Action',
            icon: Icon(actionIcon, color: scheme.primary, semanticLabel: 'Action'),
            onPressed: onActionPressed,
          ),

        ...?actions,
        const SizedBox(width: AppSpacing.s),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
