import 'dart:ui';

import 'package:flutter/material.dart';

class ModernBlurAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const ModernBlurAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0.6),
          centerTitle: true,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          surfaceTintColor: Colors.transparent,
        ),
      ),
    );
  }
}
