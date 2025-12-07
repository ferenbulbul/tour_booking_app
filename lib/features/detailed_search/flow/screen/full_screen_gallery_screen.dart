import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PremiumFullScreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const PremiumFullScreenGallery({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<PremiumFullScreenGallery> createState() =>
      _PremiumFullScreenGalleryState();
}

class _PremiumFullScreenGalleryState extends State<PremiumFullScreenGallery> {
  late PageController _pageController;
  late PhotoViewScaleStateController _scaleController;

  int _currentIndex = 0;
  bool _isZoomed = false;

  double _dragOffset = 0;
  double _opacity = 1;

  static const double _dismissThreshold = 120;
  static const double _maxDrag = 300;
  static const int _animMs = 160;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _scaleController = PhotoViewScaleStateController();

    _currentIndex = widget.initialIndex;

    // Zoom state listener
    _scaleController.addIgnorableListener(() {
      final state = _scaleController.scaleState;
      setState(() => _isZoomed = state != PhotoViewScaleState.initial);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_isZoomed) return; // zoom açıkken dismiss kapalı

    setState(() {
      _dragOffset += details.delta.dy;
      _dragOffset = _dragOffset.clamp(-_maxDrag, _maxDrag);

      final t = (_dragOffset.abs() / _maxDrag).clamp(0.0, 1.0);
      _opacity = 1 - (0.6 * t);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_isZoomed) {
      _reset();
      return;
    }

    final velocity = details.primaryVelocity ?? 0;

    if (_dragOffset.abs() > _dismissThreshold || velocity.abs() > 700) {
      Navigator.of(context).pop();
    } else {
      _reset();
    }
  }

  void _reset() {
    setState(() {
      _dragOffset = 0;
      _opacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: _animMs),
        opacity: _opacity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: _animMs),
          transform: Matrix4.translationValues(0, _dragOffset, 0),
          child: GestureDetector(
            onVerticalDragUpdate: _onVerticalDragUpdate,
            onVerticalDragEnd: _onVerticalDragEnd,
            child: Stack(
              children: [
                // ---- GALLERY ----
                PhotoViewGallery.builder(
                  itemCount: widget.images.length,
                  pageController: _pageController,
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  builder: (_, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: CachedNetworkImageProvider(
                        widget.images[index],
                      ),

                      // 🔥 TAŞMA YOK — CROP YOK → contain davranışı
                      initialScale: PhotoViewComputedScale.contained,
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.contained * 4,

                      heroAttributes: PhotoViewHeroAttributes(
                        tag: "img-${widget.images[index]}",
                      ),

                      // Fotoğraf daha net
                      filterQuality: FilterQuality.high,
                    );
                  },
                ),

                // ---- CLOSE BUTTON ----
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  right: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),

                // ---- DOT INDICATOR ----
                Positioned(
                  bottom: 28,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.images.length, (i) {
                      final active = i == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: active ? 20 : 8,
                        decoration: BoxDecoration(
                          color: active
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
