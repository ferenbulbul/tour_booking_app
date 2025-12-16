import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
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
        const SizedBox(height: 12),

        // ------------------------------------------
        // CITY
        // ------------------------------------------
        _buildItem(
          child: PickerField(
            label: "Departure City",
            value: cityName,
            icon: Icons.location_city_rounded,
            onTap: onSelectCity,
          ),
        ),

        // ------------------------------------------
        // DISTRICT
        // ------------------------------------------
        _buildItem(
          child: PickerField(
            label: "Departure District",
            value: districtName,
            icon: Icons.location_on_outlined,
            onTap: onSelectDistrict,
          ),
        ),

        // ------------------------------------------
        // SELECT EXACT LOCATION
        // ------------------------------------------
        _buildItem(
          child: PickerField(
            label: "Add Exact Location",
            value: null,
            icon: Icons.my_location_rounded,
            onTap: onSelectPlace,
          ),
        ),

        // ------------------------------------------
        // SELECTED LOCATION CARD (ANIMATED)
        // ------------------------------------------
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: _fadeSlide,
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

        // ------------------------------------------
        // MINI MAP (ANIMATED)
        // ------------------------------------------
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: _fadeSlide,
          child: (placeLat != null && placeLng != null)
              ? Padding(
                  key: const ValueKey("mini_map"),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                  ).copyWith(bottom: 10),
                  child: MiniLocationMap(
                    lat: placeLat!,
                    lng: placeLng!,
                    onTap: onOpenMap,
                  ),
                )
              : const SizedBox(key: ValueKey("mini_map_none")),
        ),

        // ------------------------------------------
        // INFO TEXT
        // ------------------------------------------
        if (placeLat != null && placeLng != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.l,
            ).copyWith(bottom: 12),
            child: Row(
              children: const [
                Icon(Icons.info_outline, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "You can preview or change the pickup point on the map.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // ------------------------------------------
        // DATE & TIME ROW
        // ------------------------------------------
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
          ).copyWith(top: 8),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: PickerField(
                    label: "Select Date",
                    value: dateText,
                    icon: Icons.calendar_month_rounded,
                    onTap: onSelectDate,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PickerField(
                    label: "Select Time",
                    value: timeText,
                    icon: Icons.access_time_rounded,
                    onTap: onSelectTime,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }

  // -------------------------------------------------------------
  // HELPERS
  // -------------------------------------------------------------

  Widget _buildItem({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
      ).copyWith(bottom: 12),
      child: child,
    );
  }

  Widget _fadeSlide(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
