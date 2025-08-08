import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/network/handle_response.dart';
import 'package:tour_booking/models/tour_search/mobile_tour_points_by_search_dto.dart';
import 'package:tour_booking/models/tour_search_list/mobile_tour_points_response.dart';
import 'package:tour_booking/services/tour/tour_service.dart';

class SearchLocationPage extends StatefulWidget {
  const SearchLocationPage({super.key});

  @override
  State<SearchLocationPage> createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  final TextEditingController _controller = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 300);
  final TourService _tourService = TourService();
  int selectedIndex = -1;

  List<MobileTourPointsBySearchDto> points = [];

  void _search(String query) {
    setState(() {
      points = [];
    });
    if (query.length < 2) return;

    _debouncer.run(() async {
      final response = await _tourService.getTourTypesSearch(query);
      final result = handleResponse<MobileTourPointsResponse>(response);

      if (mounted && result != null) {
        setState(() {
          points = response.data?.tourPoints ?? [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: "Yer adı yaz (örn: Ayder)",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: _search,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: points.length,
          itemBuilder: (context, index) {
            final point = points[index];
            final isSelected = index == selectedIndex;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                print("Seçilen yer: ${point.name}");
              },
              child: Container(
                color: isSelected
                    ? Colors.blue.shade100
                    : const Color.fromARGB(
                        255,
                        93,
                        186,
                        236,
                      ), // arka plan rengi
                child: ListTile(
                  leading: const Icon(Icons.location_city),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  title: Text(point.name),
                  subtitle: Text(point.type),
                ),
              ),
            );
          },
        ),
      ],
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
