import 'package:flutter/material.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';

class BottomActionBar extends StatelessWidget {
  final int? price;
  final String buttonText;
  final VoidCallback onPressed;

  const BottomActionBar({
    super.key,
    this.price,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final hasPrice = price != null && price! > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),

      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 12),

        child: Row(
          children: [
            if (hasPrice)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  "${price!} ₺",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),

            // 🔥 Overflow'u çözen sihir burada
            Expanded(
              child: SizedBox(
                height: 50,
                child: PrimaryButton(text: buttonText, onPressed: onPressed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
