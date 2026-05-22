import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/widgets/picker_field.dart';
import 'package:tour_booking/core/widgets/shake_widget.dart';
import 'package:tour_booking/features/tour/booking/widget/mini_location_map.dart';
import 'package:tour_booking/features/tour/booking/widget/selected_location_card.dart';

class DepartureFormSection extends StatefulWidget {
  final String? cityName;
  final String? districtName;
  final String? placeDescription;
  final String? dateText;
  final String? timeText;
  final double? placeLat;
  final double? placeLng;
  final bool showErrors;

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
    this.showErrors = false,
  });

  @override
  State<DepartureFormSection> createState() => DepartureFormSectionState();
}

class DepartureFormSectionState extends State<DepartureFormSection> {
  final _cityShakeKey = GlobalKey<ShakeWidgetState>();
  final _districtShakeKey = GlobalKey<ShakeWidgetState>();
  final _placeShakeKey = GlobalKey<ShakeWidgetState>();
  final _dateShakeKey = GlobalKey<ShakeWidgetState>();
  final _timeShakeKey = GlobalKey<ShakeWidgetState>();

  void shakeEmptyFields() {
    if (widget.cityName == null) _cityShakeKey.currentState?.shake();
    if (widget.districtName == null) _districtShakeKey.currentState?.shake();
    if (widget.placeDescription == null) _placeShakeKey.currentState?.shake();
    if (widget.dateText == null) _dateShakeKey.currentState?.shake();
    if (widget.timeText == null) _timeShakeKey.currentState?.shake();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.m),

        // City
        _pad(
          ShakeWidget(
            key: _cityShakeKey,
            child: CompactPickerField(
              icon: SolarIconsOutline.buildings_3,
              label: tr("departure_city"),
              value: widget.cityName,
              showError: widget.showErrors && widget.cityName == null,
              onTap: widget.onSelectCity,
            ),
          ),
        ),

        // District
        _pad(
          ShakeWidget(
            key: _districtShakeKey,
            child: CompactPickerField(
              icon: SolarIconsOutline.mapPoint,
              label: tr("departure_district"),
              value: widget.districtName,
              showError: widget.showErrors && widget.districtName == null,
              onTap: widget.onSelectDistrict,
            ),
          ),
        ),

        // Exact location
        _pad(
          ShakeWidget(
            key: _placeShakeKey,
            child: CompactPickerField(
              icon: SolarIconsOutline.gps,
              label: tr("add_exact_location"),
              value: widget.placeDescription,
              showError:
                  widget.showErrors && widget.placeDescription == null,
              onTap: widget.onSelectPlace,
            ),
          ),
        ),

        // Selected location card
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: _fadeSlide,
          child: (widget.placeDescription != null)
              ? Padding(
                  key: const ValueKey("selected_location"),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                  ).copyWith(bottom: AppSpacing.m),
                  child: SelectedLocationCard(
                      description: widget.placeDescription!),
                )
              : const SizedBox(key: ValueKey("location_none")),
        ),

        // Mini map
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: _fadeSlide,
          child: (widget.placeLat != null && widget.placeLng != null)
              ? Padding(
                  key: const ValueKey("mini_map"),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                  ).copyWith(bottom: AppSpacing.ms),
                  child: MiniLocationMap(
                    lat: widget.placeLat!,
                    lng: widget.placeLng!,
                    onTap: widget.onOpenMap,
                  ),
                )
              : const SizedBox(key: ValueKey("mini_map_none")),
        ),

        // Info text
        if (widget.placeLat != null && widget.placeLng != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.l,
            ).copyWith(bottom: AppSpacing.m),
            child: Row(
              children: [
                Icon(SolarIconsOutline.infoCircle,
                    size: AppIconSize.m, color: context.ext.textLight, semanticLabel: 'Information'),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    tr("pickup_point_info"),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.ext.textLight,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Date & time row
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
          ).copyWith(top: AppSpacing.xs),
          child: Row(
            children: [
              Expanded(
                child: ShakeWidget(
                  key: _dateShakeKey,
                  child: CompactPickerField(
                    icon: SolarIconsOutline.calendarDate,
                    label: tr("select_date"),
                    value: widget.dateText,
                    showError: widget.showErrors && widget.dateText == null,
                    onTap: widget.onSelectDate,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.ms),
              Expanded(
                child: ShakeWidget(
                  key: _timeShakeKey,
                  child: CompactPickerField(
                    icon: SolarIconsOutline.clockCircle,
                    label: tr("select_time"),
                    value: widget.timeText,
                    showError: widget.showErrors && widget.timeText == null,
                    onTap: widget.onSelectTime,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.ms),
      ],
    );
  }

  Widget _pad(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
      ).copyWith(bottom: AppSpacing.ms),
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
