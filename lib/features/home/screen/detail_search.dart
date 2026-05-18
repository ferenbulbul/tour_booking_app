import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/network/handle_response.dart';

import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/models/featured_tour_point/featured_tour_point_dto.dart';
import 'package:tour_booking/models/recent_search/recent_search_item.dart';
import 'package:tour_booking/models/tour_search/mobile_tour_points_by_search_dto.dart';
import 'package:tour_booking/models/tour_search_list/mobile_tour_points_response.dart';
import 'package:tour_booking/services/recent_search/recent_search_service.dart';
import 'package:tour_booking/features/tour/search/screen/search.dart';
import 'package:tour_booking/services/tour/tour_service.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';

class DetailSearchLocationPage extends StatefulWidget {
  const DetailSearchLocationPage({super.key});

  @override
  State<DetailSearchLocationPage> createState() => _DetailSearchLocationPageState();
}

class _DetailSearchLocationPageState extends State<DetailSearchLocationPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _tourService = TourService();
  final _recentService = RecentSearchService();
  final _Debouncer _debouncer = _Debouncer(ms: 250);
  late final HomeViewModel _homeVm;

  List<MobileTourPointsBySearchDto> _results = [];
  List<RecentSearchItem> _recents = [];
  bool _loading = false;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _homeVm = context.read<HomeViewModel>();
    _loadRecents();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    // Search kapanırken anasayfadaki "Devam Et" bölümünü güncelle
    _homeVm.loadCityTargets();
    _debouncer.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadRecents() async {
    final items = await _recentService.getRecentSearches();
    if (mounted) setState(() => _recents = items);
  }

  void _onSearchChanged(String value) {
    final query = value.trim();
    _lastQuery = query;

    if (query.isEmpty) {
      setState(() {
        _results = [];
        _loading = false;
      });
      return;
    }

    setState(() => _loading = true);

    _debouncer.run(() async {
      final current = _lastQuery;
      if (current.isEmpty || !mounted) return;

      try {
        final response = await _tourService.getTourTypesSearch(current);
        final result = handleResponse<MobileTourPointsResponse>(response);

        if (!mounted || _lastQuery != current) return;

        setState(() {
          _loading = false;
          if (result.isSuccess && result.data != null) {
            _results = result.data!.tourPoints;
          } else {
            _results = [];
          }
        });
      } catch (e) {
        debugPrint('[SearchError] $e');
        if (!mounted) return;
        setState(() {
          _loading = false;
          _results = [];
        });
      }
    });
  }

  void _clearSearch() {
    _controller.clear();
    _lastQuery = '';
    setState(() {
      _results = [];
      _loading = false;
    });
    _focusNode.requestFocus();
  }

  void _tapResult(MobileTourPointsBySearchDto p) {
    // cityId belirleme
    final String? resolvedCityId;
    final String? resolvedCityName;
    if (p.type == 'City') {
      resolvedCityId = p.id;
      resolvedCityName = p.name;
    } else {
      // Tour ve District: backend'den gelen cityId/cityName kullan
      resolvedCityId = p.cityId;
      resolvedCityName = p.cityName;
    }

    _recentService.addRecentSearch(RecentSearchItem(
      id: p.id,
      name: p.name,
      type: p.type,
      timestamp: DateTime.now(),
      cityId: resolvedCityId,
      cityName: resolvedCityName,
      image: p.image,
    ));

    // Anasayfadaki "Devam Et" bölümünü güncelle
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

  Future<void> _removeRecent(String id) async {
    await _recentService.removeRecentSearch(id);
    _loadRecents();
  }

  Future<void> _clearRecents() async {
    await _recentService.clearAll();
    setState(() => _recents = []);
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  SolarIconsOutline.gps,
                  size: 28,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                tr("nearby_tours"),
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tr("enable_location_permission_from_settings"),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(tr("cancel")),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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

  bool get _hasQuery => _lastQuery.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── SEARCH HEADER ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.only(right: 6),
                child: Row(
                  children: [
                    // Back button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => context.pop(),
                        child: const SizedBox(
                          width: 48,
                          height: 52,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),

                    // TextField
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        textInputAction: TextInputAction.search,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: tr("enter_place_name_example"),
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textLight,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onChanged: _onSearchChanged,
                      ),
                    ),

                    // Clear button
                    if (_hasQuery)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: _clearSearch,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── LOADING ──
            if (_loading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: const LinearProgressIndicator(
                    minHeight: 2.5,
                    color: AppColors.accent,
                    backgroundColor: Color(0xFFEEEFF2),
                  ),
                ),
              ),

            // ── CONTENT ──
            Expanded(
              child: _hasQuery ? _buildResults() : _buildIdle(),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // IDLE
  // ═══════════════════════════════════════════════════════════════
  Widget _buildIdle() {
    final featured = context.read<HomeViewModel>().featuredPoints;

    if (_recents.isEmpty && featured.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(SolarIconsOutline.magnifier, size: 40, color: AppColors.textLight.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text(
              tr("search_empty_hint"),
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
            ),
          ],
        ),
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        // NEARBY TOURS + DETAILED SEARCH BUTTONS
        _buildQuickAction(
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
              _showLocationPermissionDialog();
            } else {
              UIHelper.showWarning(context, tr("enable_location_permission_from_settings"));
            }
          },
        ),
        const SizedBox(height: 8),
        _buildQuickAction(
          icon: SolarIconsOutline.magnifier,
          title: tr("advanced_search_title"),
          subtitle: tr("advanced_search_subtitle"),
          onTap: () => showTourSearchSheet(context),
        ),
        const SizedBox(height: 18),

        if (_recents.isNotEmpty) ...[
          _buildSectionHeader(tr("recent_searches"), SolarIconsOutline.clockCircle, onClear: _clearRecents),
          const SizedBox(height: 8),
          ..._recents.map(_buildRecentTile),
          const SizedBox(height: 24),
        ],
        if (featured.isNotEmpty) ...[
          _buildSectionHeader(tr("popular_tours"), SolarIconsOutline.fire),
          const SizedBox(height: 10),
          ...featured.take(5).map(_buildPopularTile),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // RESULTS
  // ═══════════════════════════════════════════════════════════════
  Widget _buildResults() {
    if (_loading && _results.isEmpty) return _buildSkeleton();

    if (!_loading && _results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(SolarIconsOutline.calendarSearch, size: 44, color: AppColors.textLight.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(tr("search_no_results_title"), style: AppTextStyles.titleSmall),
            const SizedBox(height: 6),
            Text(
              tr("search_no_results_subtitle"),
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final tours = _results.where((p) => p.type == 'Tour').toList();
    final cities = _results.where((p) => p.type == 'City').toList();
    final districts = _results.where((p) => p.type == 'District').toList();

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            "${_results.length} ${tr('search_result_count')}",
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textLight),
          ),
        ),
        if (tours.isNotEmpty)
          _buildGroup(tr("tours"), AppColors.accent, SolarIconsOutline.leaf, tours),
        if (cities.isNotEmpty) ...[
          if (tours.isNotEmpty) const SizedBox(height: 18),
          _buildGroup(tr("cities"), AppColors.primary, SolarIconsOutline.buildings_3, cities),
        ],
        if (districts.isNotEmpty) ...[
          if (tours.isNotEmpty || cities.isNotEmpty) const SizedBox(height: 18),
          _buildGroup(tr("districts"), AppColors.info, SolarIconsOutline.mapPoint, districts),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // COMPONENTS
  // ═══════════════════════════════════════════════════════════════

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.accent, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                SolarIconsOutline.arrowRight,
                size: 16,
                color: AppColors.textLight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, {VoidCallback? onClear}) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 7),
        Text(title, style: AppTextStyles.labelLarge.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
        const Spacer(),
        if (onClear != null)
          GestureDetector(
            onTap: onClear,
            child: Text(
              tr("clear_all"),
              style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  Widget _buildRecentTile(RecentSearchItem item) {
    final color = _colorFor(item.type);
    final icon = _iconFor(item.type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _tapRecent(item),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          child: Row(
            children: [
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 15, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 14,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _removeRecent(item.id),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.close_rounded, size: 16, color: AppColors.textLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularTile(FeaturedTourPointDto point) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          _recentService.addRecentSearch(RecentSearchItem(
            id: point.id, name: point.title, type: 'Tour', timestamp: DateTime.now(),
          ));
          context.pushNamed('searchDetail', extra: {"id": point.id, "initialImage": point.mainImage});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: CachedNetworkImage(
                  imageUrl: point.mainImage,
                  width: 44, height: 44,
                  fit: BoxFit.cover,
                  memCacheWidth: 132,
                  fadeInDuration: const Duration(milliseconds: 100),
                  placeholder: (_, __) => Container(width: 44, height: 44, color: const Color(0xFFF0F2F5)),
                  errorWidget: (_, __, ___) => Container(
                    width: 44, height: 44, color: const Color(0xFFF0F2F5),
                    child: const Icon(SolarIconsOutline.gallery, size: 16, color: AppColors.textLight),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      point.title,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(SolarIconsOutline.mapPoint, size: 11, color: AppColors.textLight),
                        const SizedBox(width: 3),
                        Text(point.cityName, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textLight, fontSize: 11)),
                        if (point.avgRating != null && point.avgRating! > 0) ...[
                          const SizedBox(width: 8),
                          const Icon(SolarIconsOutline.star, size: 11, color: AppColors.warning),
                          const SizedBox(width: 2),
                          Text(
                            point.avgRating!.toStringAsFixed(1),
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 11),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textLight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroup(String title, Color color, IconData icon, List<MobileTourPointsBySearchDto> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
              child: Icon(icon, size: 11, color: color),
            ),
            const SizedBox(width: 7),
            Text(
              title.toUpperCase(),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textLight, letterSpacing: 0.6),
            ),
            const SizedBox(width: 6),
            Text("${items.length}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ...items.map((item) => _buildResultTile(item, color, icon)),
      ],
    );
  }

  Widget _buildResultTile(MobileTourPointsBySearchDto item, Color color, IconData icon) {
    final hasImage = item.image != null && item.image!.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _tapResult(item),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          child: Row(
            children: [
              // Resim veya ikon
              if (hasImage)
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: CachedNetworkImage(
                    imageUrl: item.image!,
                    width: 44, height: 44,
                    fit: BoxFit.cover,
                    memCacheWidth: 132,
                    fadeInDuration: const Duration(milliseconds: 100),
                    placeholder: (_, __) => Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(9)),
                      child: Icon(icon, size: 16, color: color),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(9)),
                      child: Icon(icon, size: 16, color: color),
                    ),
                  ),
                )
              else
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(9)),
                  child: Icon(icon, size: 18, color: color),
                ),
              const SizedBox(width: 12),
              // İsim ve alt bilgi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHighlightText(item.name),
                    const SizedBox(height: 2),
                    _buildSubtitle(item),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textLight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle(MobileTourPointsBySearchDto item) {
    final parts = <Widget>[];

    if (item.type == 'Tour') {
      if (item.cityName != null && item.cityName!.isNotEmpty) {
        parts.add(const Icon(SolarIconsOutline.mapPoint, size: 11, color: AppColors.textLight));
        parts.add(const SizedBox(width: 3));
        parts.add(Text(item.cityName!, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textLight, fontSize: 11)));
      }
      if (item.avgRating != null && item.avgRating! > 0) {
        if (parts.isNotEmpty) parts.add(const SizedBox(width: 8));
        parts.add(const Icon(SolarIconsOutline.star, size: 11, color: AppColors.warning));
        parts.add(const SizedBox(width: 2));
        parts.add(Text(
          item.avgRating!.toStringAsFixed(1),
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 11),
        ));
      }
    } else {
      // City veya District
      if (item.tourCount != null && item.tourCount! > 0) {
        parts.add(const Icon(SolarIconsOutline.route, size: 11, color: AppColors.textLight));
        parts.add(const SizedBox(width: 3));
        parts.add(Text(
          "${item.tourCount} ${tr('tour')}",
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textLight, fontSize: 11),
        ));
      }
    }

    if (parts.isEmpty) return const SizedBox.shrink();
    return Row(children: parts);
  }

  static String _normalizeTurkish(String text) {
    return text.toLowerCase()
        .replaceAll('ğ', 'g').replaceAll('ü', 'u').replaceAll('ö', 'o')
        .replaceAll('ş', 's').replaceAll('ç', 'c').replaceAll('ı', 'i');
  }

  Widget _buildHighlightText(String text) {
    if (_lastQuery.isEmpty) {
      return Text(
        text, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 14),
      );
    }

    final qLower = _lastQuery.toLowerCase();
    final lower = text.toLowerCase();

    // Önce doğrudan eşleşme dene, sonra normalize edilmiş eşleşme
    var idx = lower.indexOf(qLower);
    if (idx == -1) {
      final normalizedText = _normalizeTurkish(text);
      final normalizedQuery = _normalizeTurkish(_lastQuery);
      idx = normalizedText.indexOf(normalizedQuery);
    }

    if (idx == -1) {
      return Text(
        text, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 14),
      );
    }

    // Normalizasyon 1:1 karakter eşlemesi — pozisyonlar korunur
    return RichText(
      maxLines: 1, overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w400, fontSize: 14),
        children: [
          TextSpan(text: text.substring(0, idx)),
          TextSpan(text: text.substring(idx, idx + _lastQuery.length), style: const TextStyle(fontWeight: FontWeight.w700)),
          TextSpan(text: text.substring(idx + _lastQuery.length)),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: List.generate(5, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(9))),
              const SizedBox(width: 12),
              Container(height: 13, width: 100.0 + (i * 20), decoration: BoxDecoration(color: const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(4))),
            ],
          ),
        )),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════

  Color _colorFor(String type) {
    switch (type) {
      case 'Tour': return AppColors.accent;
      case 'District': return AppColors.info;
      default: return AppColors.primary;
    }
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'Tour': return SolarIconsOutline.leaf;
      case 'District': return SolarIconsOutline.mapPoint;
      default: return SolarIconsOutline.buildings_3;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// DEBOUNCER
// ═══════════════════════════════════════════════════════════════
class _Debouncer {
  final int ms;
  Timer? _timer;
  _Debouncer({required this.ms});

  void run(Future<void> Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: ms), action);
  }

  void dispose() => _timer?.cancel();
}
