import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/widgets/bottom_action_bar.dart';

/// The bottom CTA bar of the tour detail screen.
///
/// Shows a "View Vehicles" button that triggers the [onPressed] callback.
class TourDetailBottomBar extends StatelessWidget {
  final VoidCallback onPressed;

  const TourDetailBottomBar({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomActionBar(
      buttonText: tr("view_vehicles"),
      onPressed: onPressed,
    );
  }
}
