import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NearbyCard extends StatelessWidget {
  final String image;
  final String title;
  final String city;
  final String type;
  final double distance;

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
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        color: scheme.surface,
        child: Stack(
          children: [
            // ---------------- IMAGE ----------------
            CachedNetworkImage(
              imageUrl: image,
              memCacheHeight: 350, // ⚡ PERF BOOST
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 150),
              placeholder: (_, __) =>
                  Container(color: scheme.surfaceVariant.withOpacity(.30)),
            ),

            // ---------------- DISTANCE BADGE ----------------
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${distance.toStringAsFixed(1)} km",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // ---------------- GRADIENT ----------------
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 90,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black38,
                      Colors.black87,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // ---------------- TEXT ----------------
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // CITY + TYPE
                  Text(
                    "$city • $type",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w500,
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
