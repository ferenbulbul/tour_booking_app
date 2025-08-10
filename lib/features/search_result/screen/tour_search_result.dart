import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/search_result/search_result_viewmodel.dart';
import 'package:tour_booking/models/tour_search_detail_request/tour_search_detailed_request.dart';

class TourSearchResultsScreen extends StatefulWidget {
  final int type;
  final String? regionId;
  final String? cityId;
  final String? districtId;

  const TourSearchResultsScreen({
    super.key,
    required this.type,
    this.regionId,
    this.cityId,
    this.districtId,
  });

  @override
  State<TourSearchResultsScreen> createState() =>
      _TourSearchResultsScreenState();
}

class _TourSearchResultsScreenState extends State<TourSearchResultsScreen> {
  @override
  void initState() {
    super.initState();

    final request = TourSearchRequest(
      type: widget.type,
      regionId: widget.regionId,
      cityId: widget.cityId,
      districtId: widget.districtId,
    );

    Future.microtask(() {
      context.read<TourSearchResultsViewModel>().fetchTourPoints(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TourSearchResultsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Arama Sonuçları")),
      body: Builder(
        builder: (context) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.errorMessage != null) {
            return Center(child: Text(vm.errorMessage!));
          }

          if (vm.tourPoints.isEmpty) {
            return const Center(child: Text("Hiçbir sonuç bulunamadı."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vm.tourPoints.length,
            itemBuilder: (context, index) {
              final point = vm.tourPoints[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      point.mainImage,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    point.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${point.cityName}, ${point.districtName}"),
                      Text(
                        "Tür: ${point.tourTypeName} • Zorluk: ${point.tourDifficultyName}",
                      ),
                    ],
                  ),
                  onTap: () {
                    context.pushNamed('searchDetail', extra: point.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
