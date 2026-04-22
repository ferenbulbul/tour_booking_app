import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/models/transport/transport_price_result/transport_price_result.dart';

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.primary.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          _row('transport_base_fee'.tr(), _fmt(price.baseFee)),
          const SizedBox(height: 8),
          _row(
            '${price.distanceKm.toStringAsFixed(1)} km × ${_fmt(price.pricePerKm)}',
            _fmt(distanceFee),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          _row(
            'transport_total'.tr(),
            _fmt(price.totalPrice),
            isBold: true,
            isLarge: true,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value,
      {bool isBold = false, bool isLarge = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isLarge ? 18 : 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isBold ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
