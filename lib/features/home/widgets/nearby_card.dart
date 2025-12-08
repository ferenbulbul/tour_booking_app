import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NearbyCard extends StatelessWidget {
  final String image;
  final String title;
  final String city;
  final String type; // Örn: Macera
  final double distance; // Örn: 14.5

  const NearbyCard({
    super.key,
    required this.image,
    required this.title,
    required this.city,
    required this.type,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // ------------------ IMAGE ------------------
            CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              placeholder: (_, __) => Container(color: Colors.grey.shade300),
            ),

            // ------------------ KM BADGE (SAĞ ÜST) ------------------
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${distance.toStringAsFixed(1)} km",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // ------------------ GRADIENT ALT KISIM ------------------
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 85,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black45,
                      Colors.black87,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // ------------------ TEXT AREA ------------------
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 4,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  // CITY • TYPE
                  Text(
                    "$city • $type",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
