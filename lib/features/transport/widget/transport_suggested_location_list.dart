import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/models/transport/suggested_location/suggested_location.dart';

class TransportSuggestedLocationList extends StatelessWidget {
  final List<TransportSuggestedLocation> locations;
  final void Function(TransportSuggestedLocation) onPickup;
  final void Function(TransportSuggestedLocation) onDropoff;

  const TransportSuggestedLocationList({
    super.key,
    required this.locations,
    required this.onPickup,
    required this.onDropoff,
  });

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: locations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final loc = locations[index];
          return GestureDetector(
            onTap: () => _showOptions(context, loc),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.place, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    loc.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showOptions(BuildContext context, TransportSuggestedLocation loc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  loc.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (loc.description != null && loc.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    loc.description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.circle, color: Colors.green, size: 16),
                title: const Text('Kalkış noktası olarak seç'),
                onTap: () {
                  Navigator.pop(context);
                  onPickup(loc);
                },
              ),
              ListTile(
                leading: const Icon(Icons.circle, color: Colors.red, size: 16),
                title: const Text('Varış noktası olarak seç'),
                onTap: () {
                  Navigator.pop(context);
                  onDropoff(loc);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
