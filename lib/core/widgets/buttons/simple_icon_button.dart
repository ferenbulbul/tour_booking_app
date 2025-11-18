import 'package:flutter/material.dart';

class SimpleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final double size;
  final double padding;

  const SimpleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = Colors.white,
    this.size = 22,
    this.padding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.4),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Icon(icon, size: size, color: color),
        ),
      ),
    );
  }
}
