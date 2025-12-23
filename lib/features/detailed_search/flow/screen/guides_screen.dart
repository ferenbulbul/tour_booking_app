import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TourSearchDetailViewModel>().fetchGuides();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: CommonAppBar(title: tr("guide_selection_title")),
      body: Consumer<TourSearchDetailViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, __) => const GuideCardSkeleton(),
            );
          }

          final hasGuides = vm.guides.isNotEmpty;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: hasGuides ? vm.guides.length + 1 : 2,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return WithoutGuideCard(
                  onTap: () {
                    vm.setSelectedGuide(null, 0);
                    context.push('/summary');
                  },
                );
              }

              if (!hasGuides && index == 1) {
                return const _NoGuideFoundCard();
              }

              final guide = vm.guides[index - 1];
              return GuideCard(
                guide: guide,
                onTap: () {
                  vm.setSelectedGuide(guide.guideId, guide.price);
                  context.push('/summary');
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ============================================================================
// GUIDE CARD
// ============================================================================
class GuideCard extends StatelessWidget {
  final Guide guide;
  final VoidCallback? onTap;

  const GuideCard({super.key, required this.guide, this.onTap});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('tr_TR');
    final price = formatter.format(guide.price);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),

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
                      color: AppColors.border,
                      shape: BoxShape.circle,
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.textLight,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${guide.firstName} ${guide.lastName}",
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$price ₺",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: guide.languages.map(_LanguageChip.new).toList(),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textLight,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LANGUAGE CHIP
// ============================================================================
class _LanguageChip extends StatelessWidget {
  final String label;
  const _LanguageChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ============================================================================
// WITHOUT GUIDE CARD
// ============================================================================
class WithoutGuideCard extends StatelessWidget {
  final VoidCallback? onTap;
  const WithoutGuideCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
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
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  tr("continue_without_guide"),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 26,
                color: AppColors.textLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// NO GUIDE FOUND
// ============================================================================
class _NoGuideFoundCard extends StatelessWidget {
  const _NoGuideFoundCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "no_guide_available_message",
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
