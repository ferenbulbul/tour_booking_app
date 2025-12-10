import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/widgets/skelaton/tour_card_skeleton.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/features/home/widgets/tour_type_result_card.dart';

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
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: CommonAppBar(
        title: vm.searchItemsByType.isNotEmpty
            ? vm.searchItemsByType.first.tourTypeName ?? "Sonuçlar"
            : "Sonuçlar",
        showBack: true,
      ),

      body: Builder(
        builder: (_) {
          if (vm.isLoadingSearchByType) {
            return const TourCardSkeleton();
          }

          if (vm.messageSearchByType != null) {
            return Center(child: Text(vm.messageSearchByType!));
          }

          if (vm.searchItemsByType.isEmpty) {
            return const Center(
              child: Text(
                "Kayıt bulunamadı",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vm.searchItemsByType.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (_, i) {
              final item = vm.searchItemsByType[i];

              return TourTypeResultCard(
                id: item.id,
                image: item.mainImage ?? "",
                title: item.name ?? "-",
                city: item.cityName ?? "-",
                district: item.districtName,
                difficulty: item.tourDifficultyName,
                onTap: () {
                  context.pushNamed(
                    "searchDetail",
                    extra: {"id": item.id, "initialImage": item.mainImage},
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
