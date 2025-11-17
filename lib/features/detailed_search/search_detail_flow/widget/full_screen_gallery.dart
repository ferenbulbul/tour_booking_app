import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
  late PageController _controller;
  int _currentIndex = 0;

  double _dragOffset = 0;
  double _opacity = 1;
  bool _isZoomed = false;

  static const double _dismissThreshold = 120;
  static const double _maxDrag = 300;
  static const int _animMs = 160;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_isZoomed) return;

    setState(() {
      _dragOffset += details.delta.dy;
      _dragOffset = _dragOffset.clamp(-_maxDrag, _maxDrag);
      final t = (_dragOffset.abs() / _maxDrag).clamp(0.0, 1.0);
      _opacity = 1 - (0.5 * t);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_isZoomed) {
      _resetPosition();
      return;
    }

    final velocity = details.primaryVelocity ?? 0;
    if (_dragOffset.abs() > _dismissThreshold || velocity.abs() > 700) {
      Navigator.of(context).pop();
    } else {
      _resetPosition();
    }
  }

  void _resetPosition() {
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
          transform: Matrix4.translationValues(0, _dragOffset, 0)
            ..scale(1 - (_dragOffset.abs() / _maxDrag * 0.1).clamp(0.0, 0.1)),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: _isZoomed ? null : _onVerticalDragUpdate,
            onVerticalDragEnd: _isZoomed ? null : _onVerticalDragEnd,
            child: Stack(
              children: [
                // PAGEVIEW — SADECE YATAY KAYMA
                PageView.builder(
                  physics: const _OnlyHorizontalScrollPhysics(),
                  controller: _controller,
                  itemCount: widget.images.length,
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  itemBuilder: (_, index) {
                    return Center(
                      child: InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 4.0,
                        onInteractionStart: (_) =>
                            setState(() => _isZoomed = false),
                        onInteractionUpdate: (d) {
                          if (d.scale > 1.0) setState(() => _isZoomed = true);
                        },
                        onInteractionEnd: (_) {
                          if (_isZoomed) setState(() => _isZoomed = false);
                        },
                        child: CachedNetworkImage(
                          imageUrl: widget.images[index],
                          fit: BoxFit.contain,
                          placeholder: (_, __) =>
                              Container(color: Colors.black12),
                          errorWidget: (_, __, ___) =>
                              const Icon(Icons.error, color: Colors.white70),
                        ),
                      ),
                    );
                  },
                ),

                // CLOSE BUTTON
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  right: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
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

                // DOT INDICATOR
                Positioned(
                  bottom: 28,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.images.length, (i) {
                      final active = i == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: active ? 22 : 8,
                        decoration: BoxDecoration(
                          color: active
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
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

// SADECE YATAY KAYMA FİZİĞİ
class _OnlyHorizontalScrollPhysics extends ScrollPhysics {
  const _OnlyHorizontalScrollPhysics({ScrollPhysics? parent})
    : super(parent: parent);

  @override
  _OnlyHorizontalScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _OnlyHorizontalScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (position.axis == Axis.vertical) return 0.0;
    return super.applyPhysicsToUserOffset(position, offset);
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if (position.axis == Axis.vertical) return null;
    return super.createBallisticSimulation(position, velocity);
  }
}
