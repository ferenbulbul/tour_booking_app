import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/core/widgets/picker_field.dart';
import 'package:tour_booking/features/detailed_search/flow/widget/mini_location_map.dart';

class DepartureFormSection extends StatelessWidget {
  final String? cityName;
  final String? districtName;
  final String? placeDescription;
  final String? dateText;
  final String? timeText;
  final double? placeLat;
  final double? placeLng;

  final VoidCallback onSelectCity;
  final VoidCallback onSelectDistrict;
  final VoidCallback onSelectPlace;
  final VoidCallback onSelectDate;
  final VoidCallback onSelectTime;
  final VoidCallback onSubmit;
  final VoidCallback onOpenMap;

  const DepartureFormSection({
    super.key,
    required this.cityName,
    required this.districtName,
    required this.placeDescription,
    required this.dateText,
    required this.timeText,
    required this.onSelectCity,
    required this.onSelectDistrict,
    required this.onSelectPlace,
    required this.onSelectDate,
    required this.onSelectTime,
    required this.onSubmit,
    required this.onOpenMap,
    this.placeLat,
    this.placeLng,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 14),

        _buildItem(
          child: PickerField(
            label: "Departure City",
            value: cityName,
            icon: Icons.location_city,
            onTap: onSelectCity,
          ),
        ),

        _buildItem(
          child: PickerField(
            label: "Departure District",
            value: districtName,
            icon: Icons.location_on_outlined,
            onTap: onSelectDistrict,
          ),
        ),

        _buildItem(
          child: PickerField(
            label: "📍 Add Exact Location",
            value: placeDescription,
            icon: Icons.map_outlined,
            onTap: onSelectPlace,
          ),
        ),

        if (placeLat != null && placeLng != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.l,
            ).copyWith(bottom: 12),
            child: MiniLocationMap(
              lat: placeLat!,
              lng: placeLng!,
              // 🔥 CRITICAL FIX: Dinamik key kaldırıldı.
              // Böylece harita konumu değiştiğinde State objesi yeniden kullanılacak
              // ve MiniLocationMap'teki didUpdateWidget tetiklenecektir.
              // key: ValueKey("${placeLat}_$placeLng"), // Bu satır kaldırıldı/yorumlandı
              onTap: onOpenMap,
            ),
          ),

        // DATE + TIME
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
          child: Row(
            children: [
              Expanded(
                child: PickerField(
                  label: "Select Date",
                  value: dateText,
                  icon: Icons.calendar_month,
                  onTap: onSelectDate,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PickerField(
                  label: "Select Time",
                  value: timeText,
                  icon: Icons.access_time,
                  onTap: onSelectTime,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
          child: PrimaryButton(text: "Araçları Gör", onPressed: onSubmit),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  /// Her item için ortak padding
  Widget _buildItem({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
      ).copyWith(bottom: 12),
      child: child,
    );
  }
}
