import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/home/widgets/tour_type_sceleton.dart';

class TourTypeWidget extends StatelessWidget {
  const TourTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    if (vm.isLoading) {
      return const CategoryCardSkeleton();
    }

    if (vm.message != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(vm.message!),
      );
    }

    return ListView.builder(
      key: const PageStorageKey('tour_type_list'),
      cacheExtent: 600,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: vm.tourTypes.length,
      itemBuilder: (context, index) {
        final item = vm.tourTypes[index];

        return RepaintBoundary(
          child: CategoryCard(
            title: item.title,
            description: item.description,
            imageUrl: item.thumbImageUrl,
            onTap: () => context.pushNamed(
              'tour-search-by-type',
              queryParameters: {'tourTypeId': item.id},
            ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // ----- LEFT IMAGE -----
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 112,
                  height: 112,
                  fit: BoxFit.cover,

                  /// 📌 ÖNEMLİ: Küçük kart için daha düşük çözünürlük
                  memCacheWidth: 360,

                  placeholder: (_, __) => Container(
                    width: 112,
                    height: 112,
                    color: Colors.grey.shade200,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 112,
                    height: 112,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 20),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // ----- TEXT AREA -----
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: AppColors.textSecondary.withOpacity(0.6),
              ),

              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
