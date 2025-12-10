import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/detailed_search/flow/tour_search_detail_viewmodel.dart';
import 'package:tour_booking/features/detailed_search/flow/widget/guide_skelaton.dart';
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
      appBar: const CommonAppBar(title: "Rehber Seçimi"),
      body: Consumer<TourSearchDetailViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => const GuideCardSkeleton(),
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

class GuideCard extends StatelessWidget {
  final Guide guide;
  final VoidCallback? onTap;

  const GuideCard({super.key, required this.guide, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 🔥 TR formatında fiyat (13.500 gibi)
    final formatter = NumberFormat.decimalPattern('tr_TR');
    final formattedPrice = formatter.format(guide.price);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              // FOTO – yüksek kalite (memCache yok)
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: guide.image ?? "",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${guide.firstName} ${guide.lastName}",
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -.3,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // 🔥 GÜN kaldırıldı + fiyat düzenlendi
                    Text(
                      "$formattedPrice ₺",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // LANGUAGES
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: guide.languages
                          .map((lang) => _langChip(lang))
                          .toList(),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade500,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _langChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class WithoutGuideCard extends StatelessWidget {
  final VoidCallback? onTap;

  const WithoutGuideCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(
                Icons.person_off_outlined,
                size: 28,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  "Rehbersiz devam etmek istiyorum",
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 26,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
