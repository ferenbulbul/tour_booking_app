import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/buttons/simple_icon_button.dart';

class TourDetailHeaderHero extends StatefulWidget {
  final String title;
  final String city;
  final String district;
  final String tourPointId;
  final bool isFavorite;

  /// Header'da gösterilecek görseller
  final List<String> images;

  final VoidCallback onBack;
  final VoidCallback onFav;

  /// Tıklanınca full-screen gallery açmak için
  final void Function(int index) onOpenGallery;

  const TourDetailHeaderHero({
    super.key,
    required this.title,
    required this.city,
    required this.district,
    required this.tourPointId,
    required this.isFavorite,
    required this.images,
    required this.onBack,
    required this.onFav,
    required this.onOpenGallery,
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
    final double topPadding = MediaQuery.of(context).padding.top;
    final hasImages = widget.images.isNotEmpty;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      width: double.infinity,
      child: Stack(
        children: [
          // 🌄 FULLSCREEN HERO CAROUSEL
          if (hasImages)
            Hero(
              tag: "tourImage_${widget.tourPointId}",
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final url = widget.images[index];
                  return GestureDetector(
                    onTap: () => widget.onOpenGallery(_currentIndex),
                    child: CachedNetworkImage(imageUrl: url, fit: BoxFit.cover),
                  );
                },
              ),
            )
          else
            Container(color: Colors.grey.shade300),

          // 🌫 GRADIENT OVERLAY (dokunmayı bloklamasın diye IgnorePointer)
          Positioned.fill(
            child: IgnorePointer(
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
          ),

          // ⬅️ BACK BUTTON
          Positioned(
            left: 14,
            top: topPadding + 8,
            child: SimpleIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: widget.onBack,
            ),
          ),

          // ❤️ FAVORITE BUTTON
          Positioned(
            right: 14,
            top: topPadding + 8,
            child: SimpleIconButton(
              icon: Icons.favorite,
              color: widget.isFavorite ? Colors.red : Colors.white,
              onTap: widget.onFav,
            ),
          ),

          // 📝 TITLE + CITY
          Positioned(
            left: 20,
            bottom: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title.isNotEmpty)
                  Text(
                    widget.title,
                    style: AppTextStyles.displaySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                    ),
                  ),
                const SizedBox(height: 4),
                if (widget.city.isNotEmpty || widget.district.isNotEmpty)
                  Text(
                    widget.city.isNotEmpty
                        ? "${widget.city}, ${widget.district}"
                        : widget.district,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
              ],
            ),
          ),

          // 🔢 PAGE INDICATOR (1/6 vs)
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
    );
  }
}
