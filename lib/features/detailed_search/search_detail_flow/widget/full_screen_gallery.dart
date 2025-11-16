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
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: widget.images.length,
            itemBuilder: (_, index) {
              return InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: CachedNetworkImage(
                  imageUrl: widget.images[index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                  placeholder: (_, __) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
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
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
