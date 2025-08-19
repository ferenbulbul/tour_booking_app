import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/features/search/search_viewmodel.dart';
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
    // Tam ekran: sistem çubuklarını gizle (çıktığında geri al).
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
    final params = <String, String>{'type': '0', 'cityId': _cityId!};
    context.pushNamed('searchResults', queryParameters: params);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<SearchViewmodel>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(), // geri gitmek için
        ),
        title: const Text("Yer Ara"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      // AppBar yok: tam ekran
      body: SafeArea(
        // İstersen SafeArea'yı kaldırıp ekranı köşelere kadar yayabilirsin.
        top: true, // üstte status bar gizli; içerik yukarı kadar uzasın
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            children: [
              // Arama kutusu
              TextField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: "Yer adı yaz (örn: Ayder)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _search,
                onSubmitted: _search,
              ),
              const SizedBox(height: 8),
              if (_isSearching) const LinearProgressIndicator(),
              const SizedBox(height: 8),

              // Sonuçlar
              Expanded(
                child: _points.isEmpty
                    ? _EmptyState(
                        showTip: _controller.text.length < 2 && !_isSearching,
                        isSearching: _isSearching,
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _points.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final p = _points[index];
                          final selected = _selectedIndex == index;
                          final isTour = (p.type == 'Tour');

                          return Material(
                            color: selected
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.08)
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
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
                                ),
                                title: Text(p.name),
                                subtitle: Text(p.type),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
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
    if (isSearching) return const SizedBox.shrink();
    return Center(
      child: Text(
        showTip ? "En az 2 karakter yazın" : "Sonuç bulunamadı",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;
  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
