import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class FakeSearchBar extends StatelessWidget {
  const FakeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        onTap: () => context.push('/search-location'),
        child: Container(
          // 🔥 YÜKSEKLİK GARANTİ (native search bar hissi)
          constraints: const BoxConstraints(minHeight: 56),

          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: scheme.outline.withOpacity(.25)),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withOpacity(.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: scheme.onSurfaceVariant,
                size: 22,
              ),

              const SizedBox(width: AppSpacing.m),

              Expanded(
                child: Text(
                  tr("enter_place_name_example"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 16, // 🔥 biraz daha tok
                    color: scheme.onSurfaceVariant.withOpacity(.9),
                  ),
                ),
              ),

              // ➕ sağda boşluk hissi / premium denge
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
