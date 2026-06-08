import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class RootScaffold extends StatelessWidget {
  final Widget child;

  const RootScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (location.startsWith('/home')) {
      currentIndex = 0;
    } else if (location.startsWith('/favorite')) {
      currentIndex = 1;
    } else if (location.startsWith('/transport')) {
      currentIndex = 2;
    } else if (location.startsWith('/reservations')) {
      currentIndex = 3;
    } else if (location.startsWith('/profile')) {
      currentIndex = 4;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: _PremiumNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/favorite');
              break;
            case 2:
              context.go('/transport');
              break;
            case 3:
              context.go('/reservations');
              break;
            case 4:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }
}

class _PremiumNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const _PremiumNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': SolarIconsOutline.magnifier, 'label': 'discover'},
      {'icon': SolarIconsOutline.heart, 'label': 'favorite'},
      {'icon': SolarIconsOutline.routing, 'label': 'transport_title'},
      {'icon': SolarIconsOutline.calendar, 'label': 'bookings'},
      {'icon': SolarIconsOutline.user, 'label': 'profile'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(
          top: BorderSide(color: context.colors.outline, width: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (i) {
              final active = i == currentIndex;

              return Expanded(
                child: Semantics(
                  button: true,
                  selected: active,
                  label: items[i]['label']!.toString().tr(),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => onTap(i),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        items[i]['icon'] as IconData,
                        size: AppIconSize.xl,
                        color: active
                            ? context.colors.secondary
                            : context.ext.textLight,
                        semanticLabel: items[i]['label']!.toString().tr(),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        items[i]['label']!.toString().tr(),
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: active
                              ? context.colors.secondary
                              : context.ext.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
