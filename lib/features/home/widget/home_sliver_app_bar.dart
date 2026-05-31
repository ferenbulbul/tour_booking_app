import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/home/widget/search_section.dart';

const _kExpandedContentHeight = 195.0;
const _kCollapsedBarHeight = 88.0;

class HomeSliverAppBar extends StatelessWidget {
  final String? fullName;
  final bool isGuest;

  const HomeSliverAppBar({
    super.key,
    this.fullName,
    this.isGuest = false,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      pinned: true,
      stretch: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      expandedHeight: _kExpandedContentHeight + topPadding,
      collapsedHeight: _kCollapsedBarHeight,
      backgroundColor: Colors.transparent,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final currentHeight = constraints.biggest.height;
          final minHeight = _kCollapsedBarHeight + topPadding;
          final maxHeight = _kExpandedContentHeight + topPadding;

          double t = 1.0;
          if (maxHeight > minHeight) {
            t = ((currentHeight - minHeight) / (maxHeight - minHeight))
                .clamp(0.0, 1.0);
          }

          return _HeaderContent(
            t: t,
            topPadding: topPadding,
            fullName: fullName,
            isGuest: isGuest,
          );
        },
      ),
    );
  }
}

class _HeaderContent extends StatelessWidget {
  final double t;
  final double topPadding;
  final String? fullName;
  final bool isGuest;

  const _HeaderContent({
    required this.t,
    required this.topPadding,
    this.fullName,
    this.isGuest = false,
  });

  String get _greetingKey {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'good_morning';
    if (hour < 17) return 'good_afternoon';
    return 'good_evening';
  }

  String get _firstName {
    if (fullName == null || fullName!.isEmpty) return '';
    return fullName!.trim().split(RegExp(r'\s+')).first;
  }

  @override
  Widget build(BuildContext context) {
    // Smooth fade curve for content above search bar
    final fadeT = Curves.easeOut.transform(t);

    // Bottom corner radius interpolation
    final bottomRadius = lerpDouble(AppRadius.medium, AppRadius.large, t) ?? AppRadius.large;

    final surfaceColor = Theme.of(context).colorScheme.surface;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(bottomRadius),
        bottomRight: Radius.circular(bottomRadius),
      ),
      child: Container(
        color: surfaceColor,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryDark.withValues(alpha: t),
                AppColors.primary.withValues(alpha: t),
                AppColors.primaryLight.withValues(alpha: t),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
          children: [
            // Collapsible content (logo, greeting, title) — vertically centered
            Positioned(
              top: topPadding,
              left: 0,
              right: 0,
              bottom: 52 + AppSpacing.xl + AppSpacing.s, // search bar + paddings
              child: Opacity(
                opacity: fadeT,
                child: ClipRect(
                  child: OverflowBox(
                    minHeight: 0,
                    maxHeight: double.infinity,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo + Avatar row
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            AppSpacing.screenPadding, 0, AppSpacing.screenPadding, 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/header_white.png',
                                height: 28,
                                fit: BoxFit.contain,
                                excludeFromSemantics: true,
                              ),
                              _AvatarCircle(
                                fullName: fullName,
                                isGuest: isGuest,
                              ),
                            ],
                          ),
                        ),

                        // Greeting
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            AppSpacing.screenPadding, AppSpacing.s, AppSpacing.screenPadding, 0,
                          ),
                          child: Text(
                            isGuest || _firstName.isEmpty
                                ? '${tr("hello_guest")} \u{1F44B}'
                                : '${tr(_greetingKey)}, $_firstName \u{1F44B}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),

                        // Title
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            AppSpacing.screenPadding, AppSpacing.m, AppSpacing.screenPadding, 0,
                          ),
                          child: Text(
                            tr("where_heading_today"),
                            style: AppTextStyles.titleLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Search bar — pinned to bottom
            Positioned(
              left: AppSpacing.screenPadding,
              right: AppSpacing.screenPadding,
              bottom: AppSpacing.xl,
              child: const FakeSearchBar(),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final String? fullName;
  final bool isGuest;

  const _AvatarCircle({this.fullName, this.isGuest = false});

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasName = !isGuest && fullName != null && fullName!.isNotEmpty;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: hasName
            ? Text(
                _initials(fullName!),
                style: AppTextStyles.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              )
            : Icon(
                SolarIconsOutline.user,
                size: AppIconSize.l,
                color: Colors.white,
                semanticLabel: 'Profile',
              ),
      ),
    );
  }
}

