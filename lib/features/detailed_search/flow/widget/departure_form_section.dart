import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/core/widgets/picker_field.dart';

class DepartureFormSection extends StatelessWidget {
  final String? cityName;
  final String? districtName;
  final String? placeDescription;
  final String? dateText;
  final String? timeText;

  final VoidCallback onSelectCity;
  final VoidCallback onSelectDistrict;
  final VoidCallback onSelectPlace;
  final VoidCallback onSelectDate;
  final VoidCallback onSelectTime;
  final VoidCallback onSubmit;

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
