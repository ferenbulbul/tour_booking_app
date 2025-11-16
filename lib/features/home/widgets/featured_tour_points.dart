import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart' as shimmer; // ⭐ ÖNEMLİ
import 'package:tour_booking/features/home/home_viewmodel.dart';

/// ===============================================================
///  PREMIUM FEATURED CARD – Hero YOK, sade image
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
                // --- IMAGE (HERO YOK) ---
                // --- IMAGE (HERO EKLENDİ) ---
                Positioned.fill(
                  child: Hero(
                    tag: "tourImage_$id",
                    child: Image(
                      image: CachedNetworkImageProvider(
                        imageUrl,
                        cacheKey: "featured_$id",
                      ),
                      fit: BoxFit.cover,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded || frame != null)
                              return child;
                            return Container(color: Colors.grey.shade300);
                          },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(color: Colors.grey.shade300);
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors.grey.shade300);
                      },
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
///   - Loading → Shimmer Skeleton
///   - Data → Normal list
/// ===============================================================
class FeaturedPointsWidget extends StatelessWidget {
  const FeaturedPointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    if (vm.isLoading) {
      // 🔥 Artık Progress yerine skeleton
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
///  FEATURED SKELETON LIST  (Shimmer + kart iskeleti)
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
        itemCount: 4, // 4 tane fake kart
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, __) => const FeaturedCardSkeleton(),
      ),
    );
  }
}

/// ===============================================================
///  TEK BİR KART SKELETON'U
/// ===============================================================
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
