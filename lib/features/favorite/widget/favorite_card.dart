import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoriteCard extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String city;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const FavoriteCard({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.city,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // ---- IMAGE ----
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(18),
              ),
              child: Hero(
                tag: "tourImage_$id",
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  cacheKey: "featured_$id",
                  width: 110,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ---- TEXT ----
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    city,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ---- HEART BUTTON ----
            GestureDetector(
              onTap: () {
                onFavoriteToggle();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      "Favorilerden kaldırıldı",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.black87,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    duration: const Duration(milliseconds: 1300),
                  ),
                );
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(isFavorite),
                  color: isFavorite ? Colors.redAccent : Colors.black26,
                  size: 26,
                ),
              ),
            ),

            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}
