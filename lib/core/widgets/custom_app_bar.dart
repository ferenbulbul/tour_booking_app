import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;

  /// 🔥 Yakın Yerler butonu artık tamamen dışarıdan geliyor
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;

  /// Ekstra actions da ekleyebilirsin
  final List<Widget>? actions;

  final bool centerTitle;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBack = true,

    // Yakın yerler veya başka bir özel action
    this.actionIcon,
    this.onActionPressed,

    this.actions,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: scheme.background,
      centerTitle: centerTitle,

      // 🔙 Back Button
      leading: showBack
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: scheme.onBackground),
              onPressed: () => context.pop(),
            )
          : null,

      // 🔥 Title
      title: Text(
        title,
        style: text.titleLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: scheme.onBackground,
        ),
      ),

      // 🔥 Actions
      actions: [
        /// Eğer actionIcon verilmişse button oluştur
        if (actionIcon != null)
          IconButton(
            icon: Icon(actionIcon, color: scheme.primary),
            onPressed: onActionPressed,
          ),

        ...?actions,
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
