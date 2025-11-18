import 'package:flutter/material.dart';

class DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const DifficultyBadge(this.difficulty, {super.key});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (difficulty.toLowerCase()) {
      case "kolay":
        bg = const Color(0xFFE8F5E9);
        text = const Color(0xFF2E7D32);
        break;
      case "orta":
        bg = const Color(0xFFFFF3E0);
        text = const Color(0xFFEF6C00);
        break;
      case "zor":
        bg = const Color(0xFFFFEBEE);
        text = const Color(0xFFC62828);
        break;
      default:
        bg = Colors.grey.shade200;
        text = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          fontSize: 12,
          color: text,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
