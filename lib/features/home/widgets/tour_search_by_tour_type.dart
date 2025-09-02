// features/search_result/tour_search_results_by_tour_type_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';

class TourSearchResultsByTourTypeScreen extends StatefulWidget {
  final String? tourTypeId;
  const TourSearchResultsByTourTypeScreen({
    super.key,
    required this.tourTypeId,
  });

  @override
  State<TourSearchResultsByTourTypeScreen> createState() =>
      _TourSearchResultsByTourTypeScreenState();
}

class _TourSearchResultsByTourTypeScreenState
    extends State<TourSearchResultsByTourTypeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final id = widget.tourTypeId ?? "";
      context.read<HomeViewModel>().fetchTourPointsByType(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          vm.searchItemsByType.isNotEmpty
              ? vm.searchItemsByType.first.tourTypeName ?? "Sonuçlar"
              : "Sonuçlar",
        ),
      ),
      body: Builder(
        builder: (_) {
          if (vm.isLoadingSearchByType) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.messageSearchByType != null) {
            return Center(child: Text(vm.messageSearchByType!));
          }
          if (vm.searchItemsByType.isEmpty) {
            return const Center(child: Text("Kayıt bulunamadı"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: vm.searchItemsByType.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = vm.searchItemsByType[index];

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Detay sayfasına git (query param ile)
                  context.pushNamed('searchDetail', extra: item.id);
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        (item.mainImage != null && item.mainImage!.isNotEmpty)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  imageUrl: item.mainImage!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.image, size: 60),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Başlık
                              Text(
                                item.name ?? "Başlık",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),

                              // Şehir, İlçe
                              Text(
                                "${item.cityName ?? ''}${item.districtName != null ? ', ${item.districtName}' : ''}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),

                              // Zorluk (not: şu an districtName yazıyordu, düzelttim)
                              if (item.tourDifficultyName != null &&
                                  item.tourDifficultyName!.isNotEmpty)
                                Text(
                                  "Zorluk: ${item.tourDifficultyName!}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
