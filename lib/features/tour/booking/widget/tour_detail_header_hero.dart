import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

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
      color: Colors.white,
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
                    return CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      memCacheWidth: (MediaQuery.of(context).size.width *
                              MediaQuery.of(context).devicePixelRatio)
                          .toInt(),
                      fadeInDuration: const Duration(milliseconds: 150),
                      placeholder: (_, __) => Container(
                        color: Colors.grey.shade200,
                      ),
                      errorWidget: (_, __, ___) => Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey.shade400,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
              ),

            // gradient
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.0, 0.4],
                      colors: [
                        Colors.black.withOpacity(.50),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // page indicator
            if (widget.images.length > 1)
              Positioned(
                right: 20,
                bottom: 18,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    "${_currentIndex + 1}/${widget.images.length}",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontSize: 12,
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
