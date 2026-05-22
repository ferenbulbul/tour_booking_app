import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class BottomActionBar extends StatelessWidget {
  final num? price;
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
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        border: Border(top: BorderSide(color: context.colors.outline, width: 0.5)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.ms,
        AppSpacing.l,
        bottomPad > 0 ? bottomPad : AppSpacing.m,
      ),
      child: Row(
        children: [
          if (hasPrice) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Toplam",
                  style: AppTextStyles.caption.copyWith(
                    color: context.ext.textLight,
                  ),
                ),
                Text(
                  _formatPrice(price!),
                  style: AppTextStyles.titleSmall.copyWith(
                    color: context.colors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.l),
          ],
          Expanded(
            child: Semantics(
              button: true,
              label: buttonText,
              child: GestureDetector(
                onTap: onPressed,
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: context.colors.secondary,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    buttonText,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: context.colors.onSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(num value) {
    return NumberFormat.currency(
      locale: 'tr_TR',
      symbol: '\u20BA',
      decimalDigits: 2,
    ).format(value);
  }
}
