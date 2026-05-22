import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/models/transport/transport_price_result/transport_price_result.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class TransportPriceBreakdown extends StatelessWidget {
  final TransportPriceResult price;

  const TransportPriceBreakdown({super.key, required this.price});

  String _fmt(num v) {
    final f = NumberFormat.currency(locale: 'tr_TR', symbol: '₺', decimalDigits: 2);
    return f.format(v);
  }

  @override
  Widget build(BuildContext context) {
    final distanceFee = price.totalPrice - price.baseFee;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.secondary.withValues(alpha: 0.08),
            context.colors.secondary.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: context.colors.secondary.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          _row(context, 'transport_base_fee'.tr(), _fmt(price.baseFee)),
          const SizedBox(height: AppSpacing.s),
          _row(
            context,
            '${price.distanceKm.toStringAsFixed(1)} km × ${_fmt(price.pricePerKm)}',
            _fmt(distanceFee),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.ms),
            child: Divider(height: 1),
          ),
          _row(
            context,
            'transport_total'.tr(),
            _fmt(price.totalPrice),
            isBold: true,
            isLarge: true,
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value,
      {bool isBold = false, bool isLarge = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: (isLarge ? AppTextStyles.titleSmall : AppTextStyles.labelLarge).copyWith(
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isBold ? context.colors.onSurface : context.colors.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: (isLarge ? AppTextStyles.titleMedium : AppTextStyles.labelLarge).copyWith(
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isBold ? context.colors.secondary : context.colors.onSurface,
          ),
        ),
      ],
    );
  }
}
