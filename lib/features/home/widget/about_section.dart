import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': SolarIconsOutline.shieldCheck, 'text': tr("about_fully_insured")},
      {'icon': SolarIconsOutline.user, 'text': tr("about_professional_guides")},
      {
        'icon': SolarIconsOutline.headphonesRound,
        'text': tr("about_customer_support"),
      },
      {
        'icon': SolarIconsOutline.walletMoney,
        'text': tr("about_best_price_guarantee"),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s),
          child: Row(
            children: [
              Container(
                width: AppIconSize.xxxl,
                height: AppIconSize.xxxl,
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.ms),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: context.colors.primary,
                  size: AppIconSize.l,
                  semanticLabel: item['text'] as String,
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Text(
                  item['text'] as String,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.colors.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
