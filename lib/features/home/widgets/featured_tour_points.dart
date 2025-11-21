import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart' as shimmer;
import 'package:tour_booking/features/home/home_viewmodel.dart';

/// ===============================================================
///  PREMIUM FEATURED CARD – Eski tasarım + net görüntü
/// ===============================================================
class FeaturedCard extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String? category;
  final VoidCallback onTap;

  const FeaturedCard({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    // ekran dpi’sine göre cache genişliği (hem net hem nispeten hafif)
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final targetWidth = (220 * dpr).round(); // kart ~200px

    return SizedBox(
      width: 200,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // --- IMAGE (HERO) ---
                Positioned.fill(
                  child: Hero(
                    tag: "tourImage_$id",
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,

                      // İstersen tamamen silebilirsin → o zaman tam eski hal
                      memCacheWidth: targetWidth,
                      maxWidthDiskCache: targetWidth,

                      fadeInDuration: const Duration(milliseconds: 150),
                      placeholder: (_, __) =>
                          Container(color: Colors.grey.shade300),
                      errorWidget: (_, __, ___) =>
                          Container(color: Colors.grey.shade300),
                    ),
                  ),
                ),

                // --- GRADIENT OVERLAY ---
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.30),
                          Colors.black.withOpacity(0.75),
                        ],
                      ),
                    ),
                  ),
                ),

                // --- CATEGORY BADGE ---
                if (category != null)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                // --- BOTTOM TEXT REGION ---
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
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

/// ===============================================================
///  FEATURED LIST WIDGET
/// ===============================================================
class FeaturedPointsWidget extends StatelessWidget {
  const FeaturedPointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    if (vm.isLoading) {
      return const FeaturedPointsSkeleton();
    }

    if (vm.featuredPoints.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 240,
      child: ListView.separated(
        key: const PageStorageKey("featured_list"),
        scrollDirection: Axis.horizontal,
        // biraz mantıklı bir cache; uçurmuyor
        cacheExtent: 700,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: vm.featuredPoints.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final point = vm.featuredPoints[index];

          return FeaturedCard(
            key: ValueKey(point.id),
            id: point.id,
            imageUrl: point.mainImage,
            title: point.title,
            subtitle: point.cityName,
            onTap: () {
              context.pushNamed(
                'searchDetail',
                extra: {"id": point.id, "initialImage": point.mainImage},
              );
            },
          );
        },
      ),
    );
  }
}

/// ===============================================================
///  FEATURED SKELETON LIST
/// ===============================================================
class FeaturedPointsSkeleton extends StatelessWidget {
  const FeaturedPointsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, __) => const FeaturedCardSkeleton(),
      ),
    );
  }
}

class FeaturedCardSkeleton extends StatelessWidget {
  const FeaturedCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: shimmer.Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üstte image alanı
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Başlık skeleton
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 16,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Subtitle skeleton
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
