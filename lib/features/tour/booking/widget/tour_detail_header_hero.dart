import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class TourDetailHeaderHero extends StatefulWidget {
  final String tourPointId;
  final List<String> images;
  final String? heroTag;

  const TourDetailHeaderHero({
    super.key,
    required this.tourPointId,
    required this.images,
    this.heroTag,
  });

  @override
  State<TourDetailHeaderHero> createState() => _TourDetailHeaderHeroState();
}

class _TourDetailHeaderHeroState extends State<TourDetailHeaderHero> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.images.isNotEmpty;

    return Container(
      color: context.colors.surface,
      child: SizedBox.expand(
        child: Stack(
          children: [
            if (hasImages)
              Hero(
                tag: widget.heroTag ?? "tourImage_${widget.tourPointId}",
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.images.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final url = widget.images[index];
                    return Semantics(
                      image: true,
                      label: 'Tour photo',
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        memCacheWidth: (MediaQuery.of(context).size.width *
                                MediaQuery.of(context).devicePixelRatio)
                            .toInt(),
                        fadeInDuration: const Duration(milliseconds: 150),
                        placeholder: (_, __) => Container(
                          color: context.ext.shimmerBase,
                        ),
                        errorWidget: (_, __, ___) => Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: context.ext.textLight,
                            size: AppIconSize.xxxxl,
                            semanticLabel: 'Image not available',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // gradient
            Positioned.fill(
              child: RepaintBoundary(
                child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.0, 0.4],
                      colors: [
                        Colors.black.withValues(alpha: 0.50),
                        Colors.black.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
              ),
            ),

            // page indicator
            if (widget.images.length > 1)
              Positioned(
                right: AppSpacing.xl,
                bottom: AppSpacing.ml,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.54),
                    borderRadius: BorderRadius.circular(AppRadius.circular),
                  ),
                  child: Text(
                    "${_currentIndex + 1}/${widget.images.length}",
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
