// lib/widgets/badges/difficulty_badge.dart
import 'package:flutter/material.dart';

class DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const DifficultyBadge({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, Color>> levels = {
      "kolay": {"bg": const Color(0xFFE8F5E9), "text": const Color(0xFF2E7D32)},
      "orta": {"bg": const Color(0xFFFFF3E0), "text": const Color(0xFFEF6C00)},
      "zor": {"bg": const Color(0xFFFFEBEE), "text": const Color(0xFFC62828)},
    };

    final data =
        levels[difficulty.toLowerCase()] ??
        {"bg": Colors.grey.shade200, "text": Colors.grey.shade700};

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: data["bg"],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          fontSize: 12,
          color: data["text"],
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
