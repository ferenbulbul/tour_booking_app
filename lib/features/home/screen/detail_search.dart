import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/features/home/detail_search_viewmodel.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/models/recent_search/recent_search_item.dart';
import 'package:tour_booking/models/tour_search/mobile_tour_points_by_search_dto.dart';
import 'package:tour_booking/features/home/widget/search_header_bar.dart';
import 'package:tour_booking/features/home/widget/idle_state_view.dart';
import 'package:tour_booking/features/home/widget/search_results_view.dart';

class DetailSearchScreen extends StatefulWidget {
  const DetailSearchScreen({super.key});

  @override
  State<DetailSearchScreen> createState() => _DetailSearchScreenState();
}

class _DetailSearchScreenState extends State<DetailSearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  late final HomeViewModel _homeVm;

  @override
  void initState() {
    super.initState();
    _homeVm = context.read<HomeViewModel>();
    context.read<DetailSearchViewModel>().loadRecents();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _homeVm.loadCityTargets();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.read<DetailSearchViewModel>().onSearchChanged(value);
  }

  void _clearSearch() {
    _controller.clear();
    context.read<DetailSearchViewModel>().clearSearch();
    _focusNode.requestFocus();
  }

  void _tapResult(MobileTourPointsBySearchDto p) {
    final vm = context.read<DetailSearchViewModel>();
    vm.saveRecentFromResult(p);
    _homeVm.loadCityTargets();
    _navigate(p.id, p.type, p.name);
  }

  void _tapRecent(RecentSearchItem item) => _navigate(item.id, item.type, item.name);

  void _navigate(String id, String type, [String? name]) {
    if (type == 'Tour') {
      context.pushNamed('searchDetail', extra: {"id": id});
    } else if (type == 'District') {
      context.pushNamed('searchResults', queryParameters: {
        'type': '1',
        'districtId': id,
        if (name != null) 'districtName': name,
      });
    } else {
      context.pushNamed('searchResults', queryParameters: {
        'type': '1',
        'cityId': id,
        if (name != null) 'cityName': name,
      });
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: ctx.colors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: Icon(
                  SolarIconsOutline.gps,
                  size: AppIconSize.xxl,
                  color: ctx.colors.secondary,
                  semanticLabel: 'Location',
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                tr("nearby_tours"),
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                tr("enable_location_permission_from_settings"),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: ctx.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ctx.colors.onSurfaceVariant,
                          side: BorderSide(color: ctx.colors.outline),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(tr("cancel")),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: ctx.colors.secondary,
                          foregroundColor: ctx.colors.onSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          openAppSettings();
                        },
                        child: Text(tr("settings")),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DetailSearchViewModel>();
    final hasQuery = vm.query.isNotEmpty;

    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            SearchHeaderBar(
              controller: _controller,
              focusNode: _focusNode,
              hasQuery: hasQuery,
              onChanged: _onSearchChanged,
              onClear: _clearSearch,
              onBack: () => context.pop(),
            ),
            if (vm.isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  child: LinearProgressIndicator(
                    minHeight: 2.5,
                    color: context.colors.secondary,
                    backgroundColor: context.ext.surfaceDark,
                  ),
                ),
              ),
            Expanded(
              child: hasQuery
                  ? SearchResultsView(
                      vm: vm,
                      onTapResult: _tapResult,
                    )
                  : IdleStateView(
                      vm: vm,
                      onTapRecent: _tapRecent,
                      onShowLocationDialog: _showLocationPermissionDialog,
                      onTapPopular: (point) {
                        vm.saveRecentFromPopular(point);
                        context.pushNamed('searchDetail', extra: {
                          "id": point.id,
                          "initialImage": point.mainImage,
                        });
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
