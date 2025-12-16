import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/badgets/app_badge.dart';
import 'package:tour_booking/core/widgets/badgets/difficulty_badge.dart';

class TourTypeResultCard extends StatelessWidget {
  final String id;
  final String image;
  final String title;
  final String city;
  final String? district;
  final String? difficulty;
  final VoidCallback onTap;

  const TourTypeResultCard({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    required this.city,
    required this.district,
    required this.difficulty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // District formatting
    final districtText = (district != null && district!.isNotEmpty)
        ? "$city, $district"
        : city;

    return GestureDetector(
      onTap: onTap,
      child: RepaintBoundary(
        // ⚡ SCROLL JANK FIX
        child: Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.large),

            // ⚡ OPTIMIZED SHADOW (16 → 8, çok büyük fark)
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withOpacity(.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ------------------------------------------------------
              /// IMAGE (HERO + CachedNetworkImage optimized)
              /// ------------------------------------------------------
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.large),
                ),
                child: Hero(
                  // ⚡ HERO TAG FIX → Çakışma sorunlarını ortadan kaldırır
                  tag: "tourImage_${id}",
                  child: CachedNetworkImage(
                    imageUrl: image,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,

                    // ⚡ GPU LOAD OPTIMIZATION — resim çözünürlüğünü düşürür
                    memCacheHeight: 900,

                    fadeInDuration: const Duration(milliseconds: 120),

                    placeholder: (_, __) => Container(
                      height: 190,
                      width: double.infinity,
                      color: scheme.surfaceVariant.withOpacity(.25),
                    ),

                    errorWidget: (_, __, ___) => Container(
                      height: 190,
                      color: Colors.grey.withOpacity(.3),
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                ),
              ),

              /// ------------------------------------------------------
              /// TEXT + BADGES
              /// ------------------------------------------------------
              Padding(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.s),

                    /// BADGES
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        AppBadge(districtText),
                        if (difficulty != null && difficulty!.isNotEmpty)
                          DifficultyBadge(difficulty!),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
