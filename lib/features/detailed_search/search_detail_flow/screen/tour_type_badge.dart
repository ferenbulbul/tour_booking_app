// lib/widgets/badges/tour_type_badge.dart
import 'package:flutter/material.dart';

class TourTypeBadge extends StatelessWidget {
  final String type;

  const TourTypeBadge({super.key, required this.type});

  IconData _getIcon() {
    switch (type.toLowerCase()) {
      case "doğa turu":
        return Icons.forest;
      case "kültürel tur":
        return Icons.museum;
      case "deniz turu":
        return Icons.waves;
      default:
        return Icons.hiking;
    }
  }

  Color _getColor() {
    switch (type.toLowerCase()) {
      case "doğa turu":
        return Colors.green;
      case "kültürel tur":
        return Colors.purple;
      case "deniz turu":
        return Colors.cyan;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(), size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            type,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
