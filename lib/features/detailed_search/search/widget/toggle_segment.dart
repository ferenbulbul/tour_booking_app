import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';

class PremiumToggle extends StatelessWidget {
  final int index;
  final Function(int) onChanged;

  const PremiumToggle({
    super.key,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          _item("Kalkış Noktası", Icons.my_location, 0),
          _item("Tur Noktası", Icons.location_on_outlined, 1),
        ],
      ),
    );
  }

  Widget _item(String text, IconData icon, int value) {
    final selected = index == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? Colors.white : Colors.black54,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
