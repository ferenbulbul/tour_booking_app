import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/empty_state.dart';
import 'package:tour_booking/features/favorite/favorite_viewmodel.dart';
import 'package:tour_booking/features/favorite/widget/favorite_card.dart';
import 'package:tour_booking/features/favorite/widget/favorite_skeleton.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<FavoriteViewModel>().fetchFavorites();
    });
  }

  @override
  void didPopNext() {
    context.read<FavoriteViewModel>().fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FavoriteViewModel>();

    if (vm.isLoading) {
      return Scaffold(
        backgroundColor: context.colors.surface,
        body: const SafeArea(child: FavoriteSkeleton()),
      );
    }

    if (vm.favorites.isEmpty) {
      return Scaffold(
        backgroundColor: context.colors.surface,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding, 24, AppSpacing.screenPadding, 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr("my_favorites"),
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      tr("no_favorites_subtitle"),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: EmptyState(
                  icon: SolarIconsOutline.heart,
                  title: tr("no_favorites_title"),
                  subtitle: tr("no_favorites_subtitle"),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final heroItem = vm.favorites.first;
    final media = MediaQuery.of(context);
    final expandedHeight = media.size.height * 0.35;
    final topPadding = media.padding.top;

    return Scaffold(
      backgroundColor: context.colors.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // HERO — SliverAppBar like detail page
          SliverAppBar(
            pinned: true,
            stretch: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            expandedHeight: expandedHeight,
            backgroundColor: context.colors.surface,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final currentHeight = constraints.biggest.height;
                final minHeight = kToolbarHeight + topPadding;
                final maxHeight = expandedHeight;

                double t = 1.0;
                if (maxHeight > minHeight) {
                  t = ((currentHeight - minHeight) / (maxHeight - minHeight))
                      .clamp(0.0, 1.0);
                }
                final collapseT = 1 - t;
                final appBarBgOpacity =
                    lerpDouble(0.0, 1.0, collapseT.clamp(0.0, 1.0)) ?? 0.0;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Hero image
                    Semantics(
                      button: true,
                      label: 'Navigate to tour details',
                      child: GestureDetector(
                        onTap: () => context.pushNamed(
                          'searchDetail',
                          extra: {"id": heroItem.id, "initialImage": heroItem.mainImage},
                        ),
                        child: Semantics(
                          image: true,
                          label: 'Tour photo',
                          child: CachedNetworkImage(
                            cacheKey: "fav_hero_${heroItem.id}",
                            imageUrl: heroItem.mainImage,
                            fit: BoxFit.cover,
                            memCacheWidth: 900,
                            fadeInDuration: const Duration(milliseconds: 120),
                            placeholder: (_, __) => Container(
                              color: context.colors.outline.withValues(alpha: 0.3),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: context.colors.outline.withValues(alpha: 0.3),
                              child: Icon(SolarIconsOutline.galleryRemove, color: context.ext.textLight, size: AppIconSize.xxlm, semanticLabel: 'Image not available'),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom gradient
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 100,
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // "My Favorites" text on image
                    Positioned(
                      bottom: AppSpacing.l,
                      left: AppSpacing.l,
                      child: Text(
                        tr("my_favorites"),
                        style: AppTextStyles.headlineMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Heart icon top right
                    Positioned(
                      top: topPadding + AppSpacing.ms,
                      right: AppSpacing.ml,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: context.colors.surface.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.favorite, color: context.colors.error, size: AppIconSize.l, semanticLabel: 'Favorite'),
                      ),
                    ),

                    // Top band background (fade in on collapse)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: topPadding + kToolbarHeight,
                      child: IgnorePointer(
                        child: Container(
                          color: context.colors.surface.withValues(alpha: appBarBgOpacity),
                        ),
                      ),
                    ),

                    // Collapsed title
                    if (collapseT >= 0.75)
                      Positioned(
                        top: topPadding,
                        left: 0,
                        right: 0,
                        height: kToolbarHeight,
                        child: Center(
                          child: Opacity(
                            opacity: ((collapseT - 0.75) / 0.25).clamp(0.0, 1.0),
                            child: Text(
                              tr("my_favorites"),
                              style: AppTextStyles.bodyLargeEmphasis.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          // GRID — all favorites
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding, AppSpacing.l, AppSpacing.screenPadding, AppSpacing.l,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.l,
                crossAxisSpacing: AppSpacing.ml,
                childAspectRatio: 0.68,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) => FavoriteCard(item: vm.favorites[i]),
                childCount: vm.favorites.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
