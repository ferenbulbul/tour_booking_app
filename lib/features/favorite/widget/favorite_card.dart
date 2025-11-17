import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    return Slidable(
      key: ValueKey(id),

      // ----------- SAĞA KAYDIR → SİL -------------
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.28,
        children: [
          SlidableAction(
            onPressed: (_) => onFavoriteToggle(),
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(16),
            label: "Sil",
          ),
        ],
      ),

      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 140,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // IMAGE (Hero)
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(20),
                ),
                child: Hero(
                  tag: "tourImage_$id",
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    cacheKey:
                        "featured_$id", // 🔥 Hero artık sabit frame kullanır
                    width: 130,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // -------- TEXT --------
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
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      city,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // ---- Kalp animasyonlu ----
              GestureDetector(
                onTap: onFavoriteToggle,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(isFavorite),
                    color: isFavorite ? Colors.redAccent : Colors.black26,
                    size: 28,
                  ),
                ),
              ),

              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
