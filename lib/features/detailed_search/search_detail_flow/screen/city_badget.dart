import 'package:flutter/material.dart';

class CityDistrictBadge extends StatelessWidget {
  final String city;
  final String district;

  const CityDistrictBadge({
    super.key,
    required this.city,
    required this.district,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_city, size: 14, color: Colors.blue),
          const SizedBox(width: 4),
          Text(
            "$city, $district",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
