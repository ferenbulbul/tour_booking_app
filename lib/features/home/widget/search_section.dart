import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class FakeSearchBar extends StatelessWidget {
  const FakeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Semantics(
        button: true,
        label: 'Open search',
        child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.large),
        onTap: () => context.push('/search-location'),
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),

          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(color: context.colors.secondary),
          ),
          child: Row(
            children: [
              Icon(
                SolarIconsOutline.magnifier,
                color: context.colors.secondary,
                size: AppIconSize.xl - 2,
                semanticLabel: 'Search',
              ),

              const SizedBox(width: AppSpacing.m),

              Expanded(
                child: Text(
                  tr("enter_place_name_example"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
