import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/features/home/detail_search_viewmodel.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/tour/search/screen/search.dart';
import 'package:tour_booking/models/featured_tour_point/featured_tour_point_dto.dart';
import 'package:tour_booking/models/recent_search/recent_search_item.dart';

class IdleStateView extends StatelessWidget {
  final DetailSearchViewModel vm;
  final void Function(RecentSearchItem) onTapRecent;
  final VoidCallback onShowLocationDialog;
  final void Function(FeaturedTourPointDto) onTapPopular;

  const IdleStateView({
    super.key,
    required this.vm,
    required this.onTapRecent,
    required this.onShowLocationDialog,
    required this.onTapPopular,
  });

  @override
  Widget build(BuildContext context) {
    final featured = context.read<HomeViewModel>().featuredPoints;

    if (vm.recents.isEmpty && featured.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(SolarIconsOutline.magnifier, size: AppSpacing.xxxxl, color: context.ext.textLight.withValues(alpha: 0.4), semanticLabel: 'Search'),
            const SizedBox(height: AppSpacing.m),
            Text(
              tr("search_empty_hint"),
              style: AppTextStyles.bodyMedium.copyWith(color: context.ext.textLight),
            ),
          ],
        ),
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.m, AppSpacing.xl, AppSpacing.xxxl),
      children: [
        QuickActionTile(
          icon: SolarIconsOutline.gps,
          title: tr("nearby_tours"),
          subtitle: tr("find_tours_nearby"),
          onTap: () async {
            var status = await Permission.locationWhenInUse.status;
            if (!status.isGranted) {
              status = await Permission.locationWhenInUse.request();
            }
            if (!context.mounted) return;
            if (status.isGranted) {
              context.pushNamed("nearbyPoints");
            } else if (status.isPermanentlyDenied) {
              onShowLocationDialog();
            } else {
              UIHelper.showWarning(context, tr("enable_location_permission_from_settings"));
            }
          },
        ),
        const SizedBox(height: AppSpacing.s),
        QuickActionTile(
          icon: SolarIconsOutline.magnifier,
          title: tr("advanced_search_title"),
          subtitle: tr("advanced_search_subtitle"),
          onTap: () => showTourSearchSheet(context),
        ),
        const SizedBox(height: AppSpacing.l),
        if (vm.recents.isNotEmpty) ...[
          SectionHeader(
            title: tr("recent_searches"),
            icon: SolarIconsOutline.clockCircle,
            onClear: vm.clearRecents,
          ),
          const SizedBox(height: AppSpacing.s),
          ...vm.recents.map((item) => RecentSearchTile(
                item: item,
                onTap: () => onTapRecent(item),
                onRemove: () => vm.removeRecent(item.id),
              )),
          const SizedBox(height: AppSpacing.xxl),
        ],
        if (featured.isNotEmpty) ...[
          SectionHeader(title: tr("popular_tours"), icon: SolarIconsOutline.fire),
          const SizedBox(height: AppSpacing.ms),
          ...featured.take(5).map((point) => PopularTourTile(
                point: point,
                onTap: () => onTapPopular(point),
              )),
        ],
      ],
    );
  }
}

class QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const QuickActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Semantics(
        button: true,
        label: title,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.ms),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s),
                  decoration: BoxDecoration(
                    color: context.colors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.ms),
                  ),
                  child: Icon(icon, color: context.colors.secondary, size: AppIconSize.ml),
                ),
                const SizedBox(width: AppSpacing.ms),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: context.colors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.one),
                      Text(
                        subtitle,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  SolarIconsOutline.arrowRight,
                  size: AppIconSize.m,
                  color: context.ext.textLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onClear;

  const SectionHeader({super.key, required this.title, required this.icon, this.onClear});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: AppIconSize.s + 1, color: context.colors.onSurfaceVariant),
        const SizedBox(width: AppSpacing.sm + 1),
        Text(title, style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w700)),
        const Spacer(),
        if (onClear != null)
          Semantics(
            button: true,
            label: 'Clear all',
            child: GestureDetector(
              onTap: onClear,
              child: Text(
                tr("clear_all"),
                style: AppTextStyles.labelSmall.copyWith(color: context.colors.secondary, fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }
}

class RecentSearchTile extends StatelessWidget {
  final RecentSearchItem item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const RecentSearchTile({super.key, required this.item, required this.onTap, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;
    switch (item.type) {
      case 'Tour':
        color = context.colors.secondary;
        icon = SolarIconsOutline.leaf;
        break;
      case 'District':
        color = context.ext.info;
        icon = SolarIconsOutline.mapPoint;
        break;
      default:
        color = context.colors.primary;
        icon = SolarIconsOutline.buildings_3;
    }

    return Material(
      color: Colors.transparent,
      child: Semantics(
        button: true,
        label: 'Recent search ${item.name}',
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.ms),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.ms, horizontal: AppSpacing.xxs),
            child: Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(AppRadius.small + 1),
                  ),
                  child: Icon(icon, size: AppIconSize.s + 1, color: color),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: context.colors.onSurface, fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Semantics(
                  button: true,
                  label: 'Remove recent search',
                  child: GestureDetector(
                    onTap: onRemove,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Icon(Icons.close_rounded, size: AppIconSize.m, color: context.ext.textLight, semanticLabel: 'Remove'),
                    ),
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

class PopularTourTile extends StatelessWidget {
  final FeaturedTourPointDto point;
  final VoidCallback onTap;

  const PopularTourTile({super.key, required this.point, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Semantics(
        button: true,
        label: 'Popular tour ${point.title}',
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.ms),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s, horizontal: AppSpacing.xxs),
            child: Row(
              children: [
                Semantics(
                  image: true,
                  label: point.title,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.small + 1),
                    child: CachedNetworkImage(
                      imageUrl: point.mainImage,
                      width: 44, height: 44,
                      fit: BoxFit.cover,
                      memCacheWidth: 132,
                      fadeInDuration: const Duration(milliseconds: 100),
                      placeholder: (_, __) => Container(width: 44, height: 44, color: context.ext.surfaceDark),
                      errorWidget: (_, __, ___) => Container(
                        width: 44, height: 44, color: context.ext.surfaceDark,
                        child: Icon(SolarIconsOutline.gallery, size: AppIconSize.m, color: context.ext.textLight, semanticLabel: 'Image placeholder'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        point.title,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: context.colors.onSurface, fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Row(
                        children: [
                          Icon(SolarIconsOutline.mapPoint, size: AppIconSize.xs, color: context.ext.textLight, semanticLabel: 'Location'),
                          const SizedBox(width: AppSpacing.xxxs),
                          Text(point.cityName, style: AppTextStyles.caption.copyWith(color: context.ext.textLight)),
                          if (point.avgRating != null && point.avgRating! > 0) ...[
                            const SizedBox(width: AppSpacing.s),
                            Icon(Icons.star_rounded, size: AppIconSize.xs, color: context.ext.star, semanticLabel: 'Rating'),
                            const SizedBox(width: AppSpacing.xxs),
                            Text(
                              point.avgRating!.toStringAsFixed(1),
                              style: AppTextStyles.caption.copyWith(color: context.colors.onSurfaceVariant, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: AppIconSize.ml, color: context.ext.textLight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
