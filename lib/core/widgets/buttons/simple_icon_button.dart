import 'package:flutter/material.dart';

class SimpleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  final Color? fillColor; // iç dolgu (null = yok)
  final Color? borderColor; // çember rengi (null = yok)
  final double borderWidth;
  final double size;
  final double padding;

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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            fillColor ??
            Colors.transparent, // içi boş kalsın istiyorsan null ver
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Icon(icon, size: size, color: iconColor),
          ),
        ),
      ),
    );
  }
}
