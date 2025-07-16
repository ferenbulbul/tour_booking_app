import 'package:flutter/material.dart';
import 'package:tour_booking/features/profile/widget/profile_options_sheet.dart';

class ProfileActionsButton extends StatelessWidget {
  const ProfileActionsButton({super.key});

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return const ProfileOptionsSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showOptions(context),
      child: const Text('Ayarları Gör'),
    );
  }
}
