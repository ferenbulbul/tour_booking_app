import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/network/handle_response.dart';

import 'package:tour_booking/features/detailed_search/search/search_viewmodel.dart';
import 'package:tour_booking/models/tour_search/mobile_tour_points_by_search_dto.dart';
import 'package:tour_booking/models/tour_search_list/mobile_tour_points_response.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class DetailSearchLocationPage extends StatefulWidget {
  const DetailSearchLocationPage({super.key});

  @override
  State<DetailSearchLocationPage> createState() =>
      _DetailSearchLocationPageState();
}

class _DetailSearchLocationPageState extends State<DetailSearchLocationPage> {
  final TextEditingController _controller = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 300);
  final TourService _tourService = TourService();

  final List<MobileTourPointsBySearchDto> _points = [];
  String? _cityId;
  bool _isSearching = false;
  int _selectedIndex = -1;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller.dispose();
    super.dispose();
  }

  void _search(String query) {
    setState(() {
      _isSearching = query.length >= 2;
      _points.clear();
      _lastQuery = query;
    });

    if (query.length < 2) return;

    _debouncer.run(() async {
      final current = query;
      final response = await _tourService.getTourTypesSearch(current);
      final parsed = handleResponse<MobileTourPointsResponse>(response);

      if (!mounted || current != _lastQuery) return;

      setState(() {
        _isSearching = false;
        _points
          ..clear()
          ..addAll(parsed?.data?.tourPoints ?? []);
      });
    });
  }

  void _submitSearch(SearchViewmodel vm) {
    if (_cityId == null || _cityId!.isEmpty) return;

    final params = {'type': '0', 'cityId': _cityId!};
    context.pushNamed('searchResults', queryParameters: params);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final vm = context.read<SearchViewmodel>();

    return Scaffold(
      backgroundColor: scheme.surface,

      appBar: CommonAppBar(title: "Yer Ara", showBack: true),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.l,
            AppSpacing.screenPadding,
            AppSpacing.m,
          ),
          child: Column(
            children: [
              // SEARCH FIELD – InputTheme ile birebir uyumlu
              TextField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: tr("enter_place_name_example"),
                  prefixIcon: Icon(
                    Icons.search,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                onChanged: _search,
                onSubmitted: _search,
              ),

              const SizedBox(height: AppSpacing.m),
              if (_isSearching) const LinearProgressIndicator(),

              const SizedBox(height: AppSpacing.m),

              Expanded(
                child: _points.isEmpty
                    ? _EmptyState(
                        showTip: _controller.text.length < 2 && !_isSearching,
                        isSearching: _isSearching,
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _points.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.s),
                        itemBuilder: (context, index) {
                          final p = _points[index];
                          final isSelected = _selectedIndex == index;
                          final isTour = (p.type == 'Tour');

                          return Material(
                            color: isSelected
                                ? scheme.primary.withOpacity(.10)
                                : scheme.surface,
                            borderRadius: BorderRadius.circular(
                              AppRadius.medium,
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                AppRadius.medium,
                              ),
                              onTap: () {
                                setState(() => _selectedIndex = index);
                                if (isTour) {
                                  context.pushNamed(
                                    'searchDetail',
                                    extra: p.id,
                                  );
                                } else {
                                  _cityId = p.id;
                                  _submitSearch(vm);
                                }
                              },
                              child: ListTile(
                                leading: Icon(
                                  isTour
                                      ? Icons.terrain_outlined
                                      : Icons.location_city_outlined,
                                  color: scheme.primary,
                                ),
                                title: Text(
                                  p.name,
                                  style: TextStyle(
                                    color: scheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  p.type,
                                  style: TextStyle(
                                    color: scheme.onSurfaceVariant.withOpacity(
                                      .8,
                                    ),
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool showTip;
  final bool isSearching;
  const _EmptyState({required this.showTip, required this.isSearching});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (isSearching) return const SizedBox.shrink();

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.m,
        ),
        decoration: BoxDecoration(
          color: scheme.surfaceVariant.withOpacity(.5),
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: scheme.outline.withOpacity(.25)),
        ),
        child: Text(
          showTip
              ? tr("min_2_characters_required")
              : tr("search_no_results_title"),
          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 15),
        ),
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
