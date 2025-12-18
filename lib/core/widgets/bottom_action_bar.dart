import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
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

    final formatter = NumberFormat.decimalPattern('tr_TR');
    final formattedPrice = hasPrice ? formatter.format(price) : "";

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          children: [
            if (hasPrice)
              Padding(
                padding: EdgeInsetsDirectional.only(start: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Toplam",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      "$formattedPrice ₺",
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -.3,
                      ),
                    ),
                  ],
                ),
              ),

            Expanded(
              child: SizedBox(
                height: 52,
                child: PrimaryButton(text: buttonText, onPressed: onPressed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
