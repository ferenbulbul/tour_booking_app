import 'package:flutter/material.dart';

class SimpleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  final Color? fillColor; // Fill color (null = none)
  final Color? borderColor; // Border color (null = none)
  final double borderWidth;
  final double size;
  final double padding;
  final String? tooltip;

  const SimpleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1.2,
    this.size = 22,
    this.padding = 10,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            fillColor ??
            Colors.transparent, // Pass null to keep it empty
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Semantics(
          button: true,
          label: tooltip,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Icon(icon, size: size, color: iconColor),
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
