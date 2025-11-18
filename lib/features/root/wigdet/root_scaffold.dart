import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tour_booking/core/theme/app_colors.dart';

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
    } else if (location.startsWith('/reservations')) {
      currentIndex = 2;
    } else if (location.startsWith('/search')) {
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
              context.go('/reservations'); // ⭐️ EKLEDİK
              break;
            case 3:
              context.go('/search');
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
      {'icon': Icons.home_outlined, 'active': Icons.home, 'label': 'home'},
      {
        'icon': Icons.favorite_border,
        'active': Icons.favorite,
        'label': 'favorite',
      },
      {
        'icon': Icons.event_note_outlined,
        'active': Icons.event_note,
        'label': 'bookings',
      },
      {
        'icon': Icons.search_outlined,
        'active': Icons.search,
        'label': 'Keşfet',
      },
      {
        'icon': Icons.person_outline,
        'active': Icons.person,
        'label': 'profile',
      },
    ];

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            border: const Border(
              top: BorderSide(color: Colors.black12, width: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 65,
              child: Row(
                children: List.generate(items.length, (i) {
                  final active = i == currentIndex;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => onTap(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(vertical: 8),

                        // ⭐ NO BACKGROUND — sadece icon doluyor
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              active
                                  ? items[i]['active'] as IconData
                                  : items[i]['icon'] as IconData,
                              size: 24,
                              color: active
                                  ? AppColors.primary
                                  : Colors.black.withOpacity(.45),
                            ),
                            const SizedBox(height: 3),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: active
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: active
                                    ? AppColors.primary
                                    : Colors.black.withOpacity(.45),
                              ),
                              child: Text(items[i]['label']!.toString()),
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
        ),
      ),
    );
  }
}
