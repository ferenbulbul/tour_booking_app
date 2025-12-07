import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';
import 'package:tour_booking/core/widgets/picker_field.dart';
import 'package:tour_booking/features/detailed_search/flow/widget/mini_location_map.dart';
import 'package:tour_booking/features/detailed_search/flow/widget/selected_location_card.dart';

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

        // CITY
        _buildItem(
          child: PickerField(
            label: "Departure City",
            value: cityName,
            icon: Icons.location_city,
            onTap: onSelectCity,
          ),
        ),

        // DISTRICT
        _buildItem(
          child: PickerField(
            label: "Departure District",
            value: districtName,

            icon: Icons.location_on_outlined,
            onTap: onSelectDistrict,
          ),
        ),

        // EXACT LOCATION (button)
        _buildItem(
          child: PickerField(
            label: "Add Exact Location",
            value: null, // sabit buton
            icon: Icons.my_location_rounded,
            onTap: onSelectPlace,
          ),
        ),

        // SELECTED LOCATION CARD (only if desc exists)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: (placeDescription != null)
              ? Padding(
                  key: const ValueKey("selected_location"),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                  ).copyWith(bottom: 12),
                  child: SelectedLocationCard(description: placeDescription!),
                )
              : const SizedBox(key: ValueKey("location_none")),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: (placeLat != null && placeLng != null)
              ? Padding(
                  key: const ValueKey("mini_map"),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                  ).copyWith(bottom: 12),
                  child: MiniLocationMap(
                    lat: placeLat!,
                    lng: placeLng!,
                    onTap: onOpenMap,
                  ),
                )
              : const SizedBox(key: ValueKey("mini_map_none")),
        ),
        if (placeLat != null && placeLng != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.l,
            ).copyWith(bottom: 12),
            child: Row(
              children: const [
                Icon(Icons.info_outline, size: 18, color: Colors.grey),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Haritadan konumu görüntüleyebilir ve değiştirebilirsiniz.",
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        // DATE & TIME
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
              const SizedBox(width: 8),
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
      ],
    );
  }

  Widget _buildItem({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
      ).copyWith(bottom: 12),
      child: child,
    );
  }
}
