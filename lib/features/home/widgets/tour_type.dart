import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/home/widgets/tour_type_sleleton.dart';

class TourTypeWidget extends StatelessWidget {
  const TourTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    if (vm.isLoading) return const CategoryCardSkeleton();

    if (vm.message != null) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Text(vm.message!),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vm.tourTypes.length,
      itemBuilder: (context, index) {
        final item = vm.tourTypes[index];

        return CategoryCard(
          title: item.title,
          description: item.description,
          imageUrl: item.thumbImageUrl,
          onTap: () => context.pushNamed(
            'tour-search-by-type',
            queryParameters: {'tourTypeId': item.id},
          ),
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.large),
        onTap: onTap,
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.large),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withOpacity(.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: scheme.outline.withOpacity(.12)),
          ),
          child: Row(
            children: [
              // IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.large),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 112,
                  height: 112,
                  fit: BoxFit.cover,
                  memCacheWidth: 360,
                  placeholder: (_, __) => Container(
                    width: 112,
                    height: 112,
                    color: scheme.surfaceVariant.withOpacity(.3),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 112,
                    height: 112,
                    color: scheme.surfaceVariant.withOpacity(.25),
                    child: Icon(
                      Icons.image_not_supported,
                      color: scheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.m),

              // TEXTS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: scheme.onSurfaceVariant.withOpacity(.8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.s),

              Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: scheme.onSurfaceVariant.withOpacity(.7),
              ),

              const SizedBox(width: AppSpacing.m),
            ],
          ),
        ),
      ),
    );
  }
}
