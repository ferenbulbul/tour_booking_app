import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/tour_search_detail/tour_search_detail_viewmodel.dart';
import 'package:tour_booking/models/guide/guide.dart';

class GuidesScreen extends StatefulWidget {
  const GuidesScreen({super.key});

  @override
  State<GuidesScreen> createState() => _GuidesScreenState();
}

class _GuidesScreenState extends State<GuidesScreen> {
  @override
  void initState() {
    super.initState();
    // Sayfa açılır açılmaz verileri çekiyoruz.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TourSearchDetailViewModel>().fetchGuides();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Daha ferah bir görünüm için arka plan rengini değiştiriyoruz.
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Rehber Seçimi')),
      body: Consumer<TourSearchDetailViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(vm.errorMessage!, textAlign: TextAlign.center),
              ),
            );
          }

          final hasGuides = vm.guides.isNotEmpty;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            // Rehber yoksa: 2 eleman (Rehbersiz + bilgilendirme)
            // Rehber varsa: rehber sayısı + 1 (baştaki Rehbersiz)
            itemCount: hasGuides ? vm.guides.length + 1 : 2,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              // 0 → her zaman Rehbersiz Devam Et
              if (index == 0) {
                return WithoutGuideCard(
                  onTap: () {
                    vm.setSelectedGuide(null, 0);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.push('/summary');
                    }); // (route adında yazım: summary mı sumary mı?)
                  },
                );
              }

              // Rehber yoksa 1. index bilgilendirme kartı
              if (!hasGuides && index == 1) {
                return const _NoGuideFoundCard();
              }

              // Rehber varsa normal kartlar
              final guide = vm.guides[index - 1];
              return GuideCard(
                guide: guide,
                onTap: () {
                  vm.setSelectedGuide(guide.guideId, guide.price.toInt());
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.push('/summary');
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Tek bir rehberi gösteren, minimalist tasarıma sahip kart.
class GuideCard extends StatelessWidget {
  final Guide guide;
  final VoidCallback? onTap;
  const GuideCard({super.key, required this.guide, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      // Minimalist bir görünüm için çok hafif bir gölge veya hiç gölge
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias, // InkWell'in köşelerden taşmasını engeller
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Profil fotoğrafı
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    (guide.image != null && guide.image!.isNotEmpty)
                    ? NetworkImage(guide.image!)
                    : null,
                child: (guide.image == null || guide.image!.isEmpty)
                    ? const Icon(Icons.person, size: 32, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 16),
              // Rehber bilgileri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${guide.firstName} ${guide.lastName}',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),
                    Text(
                      '${guide.price} ₺ / Gün',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (guide.languages.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: guide.languages
                            .map((lang) => LanguageChip(label: lang))
                            .toList(),
                      ),
                  ],
                ),
              ),
              // Seçim göstergesi
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Rehbersiz devam et" seçeneğini sunan kart.
class WithoutGuideCard extends StatelessWidget {
  final VoidCallback? onTap;
  const WithoutGuideCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              Icon(Icons.person_off_outlined, color: Colors.grey[700]),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Rehbersiz devam etmek istiyorum',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dilleri göstermek için kullanılan daha küçük ve stil sahibi Chip.
class LanguageChip extends StatelessWidget {
  final String label;
  const LanguageChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _NoGuideFoundCard extends StatelessWidget {
  const _NoGuideFoundCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.info_outline),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Bu tarihte uygun rehber bulunamadı. İstersen rehbersiz devam edebilirsin.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
