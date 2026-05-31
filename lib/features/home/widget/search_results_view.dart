import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/features/home/detail_search_viewmodel.dart';
import 'package:tour_booking/models/tour_search/mobile_tour_points_by_search_dto.dart';

class SearchResultsView extends StatelessWidget {
  final DetailSearchViewModel vm;
  final void Function(MobileTourPointsBySearchDto) onTapResult;

  const SearchResultsView({super.key, required this.vm, required this.onTapResult});

  @override
  Widget build(BuildContext context) {
    if (vm.isLoading && vm.results.isEmpty) return const SearchSkeleton();

    if (!vm.isLoading && vm.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(SolarIconsOutline.calendarSearch, size: AppIconSize.xxxxxl, color: context.ext.textLight.withValues(alpha: 0.5), semanticLabel: 'No results'),
            const SizedBox(height: AppSpacing.l),
            Text(tr("search_no_results_title"), style: AppTextStyles.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              tr("search_no_results_subtitle"),
              style: AppTextStyles.bodySmall.copyWith(color: context.ext.textLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final tours = vm.results.where((p) => p.type == 'Tour').toList();
    final cities = vm.results.where((p) => p.type == 'City').toList();
    final districts = vm.results.where((p) => p.type == 'District').toList();

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.s, AppSpacing.xl, AppSpacing.xxxl),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.m),
          child: Text(
            "${vm.results.length} ${tr('search_result_count')}",
            style: AppTextStyles.labelSmall.copyWith(color: context.ext.textLight),
          ),
        ),
        if (tours.isNotEmpty)
          ResultGroup(
            title: tr("tours"),
            color: context.colors.secondary,
            icon: SolarIconsOutline.leaf,
            items: tours,
            query: vm.query,
            onTap: onTapResult,
          ),
        if (cities.isNotEmpty) ...[
          if (tours.isNotEmpty) const SizedBox(height: AppSpacing.l),
          ResultGroup(
            title: tr("cities"),
            color: context.colors.primary,
            icon: SolarIconsOutline.buildings_3,
            items: cities,
            query: vm.query,
            onTap: onTapResult,
          ),
        ],
        if (districts.isNotEmpty) ...[
          if (tours.isNotEmpty || cities.isNotEmpty) const SizedBox(height: AppSpacing.l),
          ResultGroup(
            title: tr("districts"),
            color: context.ext.info,
            icon: SolarIconsOutline.mapPoint,
            items: districts,
            query: vm.query,
            onTap: onTapResult,
          ),
        ],
      ],
    );
  }
}

class ResultGroup extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final List<MobileTourPointsBySearchDto> items;
  final String query;
  final void Function(MobileTourPointsBySearchDto) onTap;

  const ResultGroup({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    required this.items,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.xs)),
              child: Icon(icon, size: AppIconSize.xs, color: color),
            ),
            const SizedBox(width: AppSpacing.sm + 1),
            Text(
              title.toUpperCase(),
              style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: context.ext.textLight, letterSpacing: 0.6),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text("${items.length}", style: AppTextStyles.micro.copyWith(fontWeight: FontWeight.w600, color: color)),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ...items.map((item) => ResultTile(item: item, color: color, icon: icon, query: query, onTap: () => onTap(item))),
      ],
    );
  }
}

class ResultTile extends StatelessWidget {
  final MobileTourPointsBySearchDto item;
  final Color color;
  final IconData icon;
  final String query;
  final VoidCallback onTap;

  const ResultTile({
    super.key,
    required this.item,
    required this.color,
    required this.icon,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = item.image != null && item.image!.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: Semantics(
        button: true,
        label: 'Search result ${item.name}',
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.ms),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s, horizontal: AppSpacing.xxs),
            child: Row(
              children: [
                if (hasImage)
                  Semantics(
                    image: true,
                    label: item.name,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.small + 1),
                      child: CachedNetworkImage(
                        imageUrl: item.image!,
                        width: 44, height: 44,
                        fit: BoxFit.cover,
                        memCacheWidth: 132,
                        fadeInDuration: const Duration(milliseconds: 100),
                        placeholder: (_, __) => Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: color.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(AppRadius.small + 1)),
                          child: Icon(icon, size: AppIconSize.m, color: color),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: color.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(AppRadius.small + 1)),
                          child: Icon(icon, size: AppIconSize.m, color: color),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(AppRadius.small + 1)),
                    child: Icon(icon, size: AppIconSize.ml, color: color),
                  ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHighlightText(context, item.name),
                      const SizedBox(height: AppSpacing.xxs),
                      _buildSubtitle(context),
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

  Widget _buildSubtitle(BuildContext context) {
    final parts = <Widget>[];

    if (item.type == 'Tour') {
      if (item.cityName != null && item.cityName!.isNotEmpty) {
        parts.add(Icon(SolarIconsOutline.mapPoint, size: AppIconSize.xs, color: context.ext.textLight, semanticLabel: 'Location'));
        parts.add(const SizedBox(width: AppSpacing.xxxs));
        parts.add(Text(item.cityName!, style: AppTextStyles.caption.copyWith(color: context.ext.textLight)));
      }
      if (item.avgRating != null && item.avgRating! > 0) {
        if (parts.isNotEmpty) parts.add(const SizedBox(width: AppSpacing.s));
        parts.add(Icon(Icons.star_rounded, size: AppIconSize.xs, color: context.ext.star, semanticLabel: 'Rating'));
        parts.add(const SizedBox(width: AppSpacing.xxs));
        parts.add(Text(
          item.avgRating!.toStringAsFixed(1),
          style: AppTextStyles.caption.copyWith(color: context.colors.onSurfaceVariant, fontWeight: FontWeight.w600),
        ));
      }
    } else {
      if (item.tourCount != null && item.tourCount! > 0) {
        parts.add(Icon(SolarIconsOutline.route, size: AppIconSize.xs, color: context.ext.textLight, semanticLabel: 'Route'));
        parts.add(const SizedBox(width: AppSpacing.xxxs));
        parts.add(Text(
          "${item.tourCount} ${tr('tour')}",
          style: AppTextStyles.caption.copyWith(color: context.ext.textLight),
        ));
      }
    }

    if (parts.isEmpty) return const SizedBox.shrink();
    return Row(children: parts);
  }

  static String _normalizeTurkish(String text) {
    return text.toLowerCase()
        .replaceAll('\u011f', 'g').replaceAll('\u00fc', 'u').replaceAll('\u00f6', 'o')
        .replaceAll('\u015f', 's').replaceAll('\u00e7', 'c').replaceAll('\u0131', 'i');
  }

  Widget _buildHighlightText(BuildContext context, String text) {
    if (query.isEmpty) {
      return Text(
        text, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: AppTextStyles.labelLarge.copyWith(color: context.colors.onSurface, fontWeight: FontWeight.w500),
      );
    }

    final qLower = query.toLowerCase();
    final lower = text.toLowerCase();

    var idx = lower.indexOf(qLower);
    if (idx == -1) {
      final normalizedText = _normalizeTurkish(text);
      final normalizedQuery = _normalizeTurkish(query);
      idx = normalizedText.indexOf(normalizedQuery);
    }

    if (idx == -1) {
      return Text(
        text, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: AppTextStyles.labelLarge.copyWith(color: context.colors.onSurface, fontWeight: FontWeight.w500),
      );
    }

    return RichText(
      maxLines: 1, overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: AppTextStyles.labelLarge.copyWith(color: context.colors.onSurface, fontWeight: FontWeight.w400),
        children: [
          TextSpan(text: text.substring(0, idx)),
          TextSpan(text: text.substring(idx, idx + query.length), style: const TextStyle(fontWeight: FontWeight.w700)),
          TextSpan(text: text.substring(idx + query.length)),
        ],
      ),
    );
  }
}

class SearchSkeleton extends StatelessWidget {
  const SearchSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: List.generate(5, (i) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.ml),
          child: Row(
            children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(color: context.ext.surfaceDark, borderRadius: BorderRadius.circular(AppRadius.small + 1))),
              const SizedBox(width: AppSpacing.m),
              Container(height: 13, width: 100.0 + (i * 20), decoration: BoxDecoration(color: context.ext.surfaceDark, borderRadius: BorderRadius.circular(AppRadius.xs))),
            ],
          ),
        )),
      ),
    );
  }
}
