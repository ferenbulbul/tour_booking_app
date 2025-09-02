import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/tour_search_detail/tour_search_detail_viewmodel.dart';
import 'package:tour_booking/features/tour_search_detail/widget/place_saerch_widget.dart';
import 'package:tour_booking/models/place_section/place_section.dart';

class TourSearchDetailScreen extends StatefulWidget {
  final String tourPointId;
  final void Function(String)? onSelected;
  const TourSearchDetailScreen({
    super.key,
    required this.tourPointId,
    this.onSelected,
  });

  @override
  State<TourSearchDetailScreen> createState() => _TourSearchDetailScreenState();
}

class _TourSearchDetailScreenState extends State<TourSearchDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TourSearchDetailViewModel>(
        context,
        listen: false,
      ).fetchTourPointDetail(widget.tourPointId);
    });
    times = _generateTimes();
    selectedTime = times.first;
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TourSearchDetailViewModel>(context);
    final detail = vm.detail;

    if (vm.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (detail == null) {
      return const Scaffold(body: Center(child: Text("Detay bulunamadı.")));
    }

    // --- YENİLİK: Ana resim ve diğer resimleri tek bir listede birleştiriyoruz ---
    final allImages = [detail.mainImage, ...detail.otherImages];

    return Scaffold(
      appBar: AppBar(
        title: Text(detail.title),
        actions: [
          IconButton(
            icon: Icon(
              vm.isFavorite ? Icons.star : Icons.star_border,
              color: vm.isFavorite
                  ? Colors.yellow
                  : Colors.white, // tema rengine göre
            ),
            onPressed: () {
              vm.toggleFavorite(detail.isFavorites); // itemId veya detail.id
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- YENİLİK: Ana görsel artık tıklanabilir ---
              GestureDetector(
                onTap: () =>
                    _openGallery(context, images: allImages, initialIndex: 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageUrl: detail.mainImage,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Diğer görseller (yatay)
              if (detail.otherImages.isNotEmpty) ...[
                _buildImageGallery(
                  allImages,
                ), // Artık tüm resim listesini gönderiyoruz
                const SizedBox(height: 16),
              ],

              // Açıklama + meta (sade kart içinde)
              Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(
                            label: Text("Tur Tipi: ${detail.tourTypeName}"),
                            visualDensity: VisualDensity.compact,
                          ),
                          Chip(
                            label: Text("Zorluk: ${detail.tourDifficultyName}"),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Kalkış Şehri (bottom sheet picker)
              _buildCityPicker(vm),
              const SizedBox(height: 12),

              // Kalkış İlçesi (bottom sheet picker)
              _buildDistrictPicker(vm),
              const SizedBox(height: 10),

              // Konum Ekle butonu (Google Places)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.add_location_alt_outlined),
                  label: const Text("Tam Konum Ekle"),
                  onPressed: () async {
                    final sel = await context.pushNamed<PlaceSelection>(
                      'placePicker',
                    );
                    if (sel != null) {
                      vm.setSelectedPlace(sel); // VM'e yaz
                    }
                  },
                ),
              ),

              // Seçilen konumu göster
              if (vm.selectedPlaceDesc != null) ...[
                Card(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.outlineVariant, // Border rengi
                      width: 0.5, // Kalınlık
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "📍 ${vm.selectedPlaceDesc!}",
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              // Tarih seçici
              Row(
                children: [
                  Expanded(child: _buildDatePicker(vm)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTimePicker(vm)),
                ],
              ),

              const SizedBox(height: 20),

              // Araçları Gör (orijinal akış)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (vm.selectedCityId == null ||
                        vm.selectedDistrictId == null ||
                        vm.selectedDate == null) {
                      _showSnack("Lütfen tüm alanları doldurun");
                      return;
                    } else if (vm.selectedPlaceDesc == null) {
                      _showSnack("Lütfen tam konumu ekleyin");
                      return;
                    }

                    await vm.fetchVehicles();

                    if (vm.vehicles.isEmpty) {
                      _showSnack("Bu tarihte müsait araç bulunamadı");
                    } else {
                      context.pushNamed(
                        'vehicleList',
                        queryParameters: {
                          'cityId': vm.selectedCityId!,
                          'districtId': vm.selectedDistrictId!,
                          'tourPointId': widget.tourPointId,
                          'date': vm.selectedDate!.toIso8601String(),
                        },
                      );
                    }
                  },
                  child: const Text("Araçları Gör"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- YENİLİK: Galeri açma mantığını tek bir fonksiyona taşıdık ---
  void _openGallery(
    BuildContext context, {
    required List<String> images,
    required int initialIndex,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.9,
              child: PageView.builder(
                controller: PageController(initialPage: initialIndex),
                itemCount: images.length,
                itemBuilder: (context, pageIndex) {
                  return CachedNetworkImage(
                    // BURADA DA DEĞİŞİKLİK
                    imageUrl: images[pageIndex],
                    fit: BoxFit.fill,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Diğer görseller yatay scroll
  Widget _buildImageGallery(List<String> allImages) {
    // Ana resmi atlayıp sadece diğer resimleri listeliyoruz
    final otherImages = allImages.sublist(1);

    return SizedBox(
      height: 100,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: otherImages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final thumb = otherImages[index];
          return GestureDetector(
            onTap: () {
              // --- YENİLİK: Ortak galeriyi çağırıyoruz, doğru başlangıç index'i ile ---
              // index + 1 çünkü 'allImages' listesinde ana resim 0. index'te
              _openGallery(context, images: allImages, initialIndex: index + 1);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6,
                    offset: Offset(0, 2),
                    color: Colors.black12,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageUrl: thumb,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Tarih seçici (outlined görünüm)
  Widget _buildDatePicker(TourSearchDetailViewModel vm) {
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (pickedDate != null) vm.setSelectedDate(pickedDate);
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: "Tarih Seçin",
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today_outlined),
        ),
        child: Text(
          vm.selectedDate != null
              ? "${vm.selectedDate!.day}.${vm.selectedDate!.month}.${vm.selectedDate!.year}"
              // Formatlama için intl paketi kullanılabilir: DateFormat('dd.MM.yyyy').format(vm.selectedDate!)
              : "Tarih Seçiniz",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // --- Şehir seçici (bottom sheet açar)
  Widget _buildCityPicker(TourSearchDetailViewModel vm) {
    final cities = vm.detail?.cities ?? [];
    String? currentName;
    if (vm.selectedCityId != null) {
      final match = cities.where((c) => c.id == vm.selectedCityId).toList();
      if (match.isNotEmpty) currentName = match.first.name;
    }

    return _SelectField(
      label: "Kalkış Şehri",
      valueLabel: currentName,
      icon: Icons.location_city_outlined,
      onTap: () async {
        final id = await _openPicker(
          title: "Kalkış Şehri Seçin",
          initialId: vm.selectedCityId,
          options: cities.map<_Option>((c) => _Option(c.id, c.name)).toList(),
        );
        if (id != null) vm.setSelectedCity(id);
      },
    );
  }

  late List<String> times;
  String? selectedTime;

  List<String> _generateTimes() {
    List<String> result = [];
    for (int hour = 6; hour < 12; hour++) {
      result.add("${hour.toString().padLeft(2, '0')}:00");
      result.add("${hour.toString().padLeft(2, '0')}:30");
    }
    result.add("12:00");
    return result;
  }

  Widget _buildTimePicker(TourSearchDetailViewModel vm) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (sheetContext) {
            return SizedBox(
              height: 300,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Saat Seç",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(sheetContext);
                          },
                          child: const Text("Seç"),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      itemExtent: 40,
                      scrollController: FixedExtentScrollController(
                        initialItem: times.indexOf(selectedTime ?? times.first),
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedTime = times[index];
                        });
                        vm.setSelectedTime(
                          times[index],
                        ); // ViewModel’de güncelle
                      },
                      children: times
                          .map(
                            (time) => Center(
                              child: Text(
                                time,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Kalkış Saati",
          labelStyle: const TextStyle(fontSize: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: const Icon(Icons.access_time),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
        child: Text(
          vm.selectedTime != null
              ? "${vm.selectedTime!.toString().padLeft(2, '0')}"
              : "Saat Seçiniz",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // --- İlçe seçici (seçilen şehre göre filtreli)
  Widget _buildDistrictPicker(TourSearchDetailViewModel vm) {
    final districts = (vm.detail?.districts ?? [])
        .where((d) => d.cityId == vm.selectedCityId)
        .toList();

    String? currentName;
    if (vm.selectedDistrictId != null) {
      final match = districts
          .where((d) => d.id == vm.selectedDistrictId)
          .toList();
      if (match.isNotEmpty) currentName = match.first.name;
    }

    return _SelectField(
      label: "Kalkış İlçesi",
      valueLabel: currentName,
      icon: Icons.location_on_outlined,
      onTap: () async {
        final id = await _openPicker(
          title: "Kalkış İlçesi Seçin",
          initialId: vm.selectedDistrictId,
          options: districts
              .map<_Option>((d) => _Option(d.id, d.name))
              .toList(),
        );
        if (id != null) vm.setSelectedDistrict(id);
      },
    );
  }

  // --- Ortak açılır seçim altlığı (arama + liste)
  Future<String?> _openPicker({
    required String title,
    required List<_Option> options,
    String? initialId,
  }) async {
    String query = '';
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                final filtered = options
                    .where(
                      (o) => o.name.toLowerCase().contains(query.toLowerCase()),
                    )
                    .toList();
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          tooltip: 'Kapat',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      autofocus: true,
                      onChanged: (v) => setState(() => query = v),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Ara...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 420),
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final o = filtered[i];
                          final selected = o.id == initialId;
                          return ListTile(
                            title: Text(o.name),
                            trailing: selected
                                ? const Icon(Icons.check, size: 20)
                                : null,
                            onTap: () => Navigator.pop(context, o.id),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// --- Küçük yardımcı sınıflar/widget’lar
class _Option {
  final String id;
  final String name;
  const _Option(this.id, this.name);
}

class _SelectField extends StatelessWidget {
  final String label;
  final String? valueLabel;
  final VoidCallback onTap;
  final IconData? icon;
  const _SelectField({
    required this.label,
    required this.valueLabel,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: icon != null ? Icon(icon) : null,
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          valueLabel ?? 'Seçiniz',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
