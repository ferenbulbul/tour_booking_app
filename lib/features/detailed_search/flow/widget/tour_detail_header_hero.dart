import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/buttons/simple_icon_button.dart';

class TourDetailHeaderHero extends StatelessWidget {
  final String title;
  final String mainImage;
  final String city;
  final String district;
  final String tourPointId;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFav;
  final VoidCallback onOpenGallery;

  const TourDetailHeaderHero({
    super.key,
    required this.title,
    required this.mainImage,
    required this.city,
    required this.district,
    required this.tourPointId,
    required this.isFavorite,
    required this.onBack,
    required this.onFav,
    required this.onOpenGallery,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = mainImage.isNotEmpty;
    final double topPadding = MediaQuery.of(context).padding.top;

    return SizedBox(
      height:
          MediaQuery.of(context).size.height * 0.55, // 🔥 Tam ekran üst alan
      width: double.infinity,
      child: Stack(
        children: [
          // 🔥 FULLSCREEN HERO IMAGE (Status bar arkasına)
          GestureDetector(
            onTap: hasImage ? onOpenGallery : null,
            child: Hero(
              tag: "tourImage_$tourPointId",
              flightShuttleBuilder:
                  (context, animation, direction, fromCtx, toCtx) {
                    return Image(
                      image: CachedNetworkImageProvider(
                        mainImage,
                        cacheKey: "featured_$tourPointId",
                      ),
                      fit: BoxFit.cover,
                    );
                  },
              child: Container(
                decoration: BoxDecoration(
                  image: hasImage
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(
                            mainImage,
                            cacheKey: "featured_$tourPointId",
                          ),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
            ),
          ),

          // 🔥 GRADIENT OVERLAY
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(.60), Colors.transparent],
                ),
              ),
            ),
          ),

          // 🔥 BACK BUTTON (Status bar arkasına yapışık)
          Positioned(
            left: 14,
            top: topPadding + 8,
            child: SimpleIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: onBack,
            ),
          ),

          // 🔥 FAVORITE BUTTON
          Positioned(
            right: 14,
            top: topPadding + 8,
            child: SimpleIconButton(
              icon: Icons.favorite,
              color: isFavorite ? Colors.red : Colors.white,
              onTap: onFav,
            ),
          ),

          // 🔥 TITLE + CITY (Her şey aynen kaldı)
          Positioned(
            left: 20,
            bottom: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isNotEmpty)
                  Text(
                    title,
                    style: AppTextStyles.displaySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                    ),
                  ),
                const SizedBox(height: 4),
                if (city.isNotEmpty || district.isNotEmpty)
                  Text(
                    city.isNotEmpty ? "$city, $district" : district,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
