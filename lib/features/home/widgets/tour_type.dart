import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/home/widgets/tour_type_sleleton.dart';
import 'package:tour_booking/models/tour_type/tour_type_dto.dart';

class TourTypeWidget extends StatelessWidget {
  const TourTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<HomeViewModel, bool>((vm) => vm.isLoading);
    final tourTypes = context.select<HomeViewModel, List<TourTypeDto>>((vm) => vm.tourTypes);
    final message = context.select<HomeViewModel, String?>((vm) => vm.message);

    if (isLoading) {
      return const CategoryCardSkeleton();
    }

    if (message != null) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.s),
        child: Text(message),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.zero, // ❗️anasayfa spacing'ine saygı
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tourTypes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.m,
        mainAxisSpacing: AppSpacing.m, // 🔥 DİKEY BOŞLUK SADECE BURADA
        childAspectRatio: 0.95, // 🔥 TÜM ORAN KONTROLÜ
      ),
      itemBuilder: (context, index) {
        final item = tourTypes[index];

        return TourTypeGridItem(
          title: item.title,
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

class TourTypeGridItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const TourTypeGridItem({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // IMAGE
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.large),
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.large),
                border: Border.all(color: scheme.outline.withOpacity(.12)),
                boxShadow: [
                  BoxShadow(
                    color: scheme.shadow.withOpacity(.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.large),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: 400,
                  placeholder: (_, __) =>
                      Container(color: scheme.surfaceVariant.withOpacity(.25)),
                  errorWidget: (_, __, ___) => Icon(
                    Icons.image_not_supported,
                    color: scheme.onSurfaceVariant,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xs),

        // TITLE
        Text(
          title,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleSmall.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
        ),
      ],
    );
  }
}
