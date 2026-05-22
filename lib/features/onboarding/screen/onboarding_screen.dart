import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/onboarding/widget/onboarding_dots.dart';
import 'package:tour_booking/features/onboarding/widget/onboarding_page.dart';
import 'package:tour_booking/features/splash/splash_view_model.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final AnimationController _btnAnimController;
  late final Animation<double> _btnScaleAnim;

  List<Map<String, String>> get _pages => [
        {
          'image': 'assets/images/onboarding_1.png',
          'title': tr('onboarding_title_1'),
          'description': tr('onboarding_desc_1'),
        },
        {
          'image': 'assets/images/onboarding_2.png',
          'title': tr('onboarding_title_2'),
          'description': tr('onboarding_desc_2'),
        },
        {
          'image': 'assets/images/onboarding_3.png',
          'title': tr('onboarding_title_3'),
          'description': tr('onboarding_desc_3'),
        },
        {
          'image': 'assets/images/onboarding_4.png',
          'title': tr('onboarding_title_4'),
          'description': tr('onboarding_desc_4'),
        },
      ];

  bool get _isLastPage => _currentPage == _pages.length - 1;

  @override
  void initState() {
    super.initState();
    _btnAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _btnScaleAnim = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _btnAnimController, curve: Curves.easeOutBack),
    );
  }

  void _nextPage() {
    if (_isLastPage) {
      _completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _completeOnboarding() {
    context.read<SplashViewModel>().completeOnboarding();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _btnAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Skip button (top-right) ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.s,
                AppSpacing.s,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page counter
                  Text(
                    '${_currentPage + 1}/${_pages.length}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: context.ext.textLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Skip
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: _isLastPage ? 0.0 : 1.0,
                    child: TextButton(
                      onPressed: _isLastPage ? null : _completeOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: context.colors.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.m,
                          vertical: AppSpacing.xs,
                        ),
                      ),
                      child: Text(
                        tr('onboarding_skip'),
                        style: AppTextStyles.labelLarge.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── PageView ──
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                  if (index == _pages.length - 1) {
                    _btnAnimController.forward(from: 0);
                  }
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingPage(
                    imagePath: page['image']!,
                    title: page['title']!,
                    description: page['description']!,
                  );
                },
              ),
            ),

            // ── Bottom section: dots + button ──
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                0,
                AppSpacing.screenPadding,
                bottomPad + AppSpacing.xxl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OnboardingDots(
                    count: _pages.length,
                    currentIndex: _currentPage,
                  ),
                  const SizedBox(height: AppSpacing.xxlm),

                  // ── CTA Button ──
                  ScaleTransition(
                    scale: _btnScaleAnim,
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [context.colors.secondary, context.colors.secondary],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.large),
                          boxShadow: [
                            BoxShadow(
                              color: context.colors.secondary.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: Semantics(
                            button: true,
                            label: 'Next page',
                            child: InkWell(
                              onTap: _nextPage,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.large),
                              child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: Text(
                                  _isLastPage
                                      ? tr('onboarding_get_started')
                                      : tr('onboarding_next'),
                                  key: ValueKey(_isLastPage),
                                  style: AppTextStyles.titleSmall.copyWith(
                                    color: context.colors.onSecondary,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
