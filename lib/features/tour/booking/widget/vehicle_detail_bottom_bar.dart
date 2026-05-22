import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tour_booking/core/widgets/bottom_action_bar.dart';

/// The bottom CTA bar of the vehicle detail screen.
///
/// Shows the vehicle price and a "Continue" button that navigates to
/// the guide selection screen.
class VehicleDetailBottomBar extends StatelessWidget {
  final num? price;

  const VehicleDetailBottomBar({
    super.key,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return BottomActionBar(
      price: price,
      buttonText: tr("continue"),
      onPressed: () {
        context.push('/search-guide');
      },
    );
  }
}
