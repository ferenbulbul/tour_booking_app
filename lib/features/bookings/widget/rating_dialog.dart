import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/bookings/rating_viewmodel.dart';
import 'package:tour_booking/models/pending_rating/pending_rating_dto.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';

class RatingDialog extends StatefulWidget {
  final String token;

  const RatingDialog({super.key, required this.token});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RatingsViewModel>().loadPendingRating(token: widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RatingsViewModel>(
      builder: (_, vm, __) {
        if (vm.isRatingLoading) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 36,
                    width: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'common_loading'.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (vm.pendingRating == null) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      SolarIconsOutline.infoCircle,
                      color: AppColors.warning,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'rating_invalid_link'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('common_close'.tr()),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final canSubmit = vm.ratings.values.any((v) => v > 0);

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _header(context, vm),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: vm.pendingRating!.targets
                          .map((t) => _ratingBlock(context, vm, t))
                          .toList(),
                    ),
                  ),
                ),
                _footer(context, vm, canSubmit),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _ratingBlock(
    BuildContext context,
    RatingsViewModel vm,
    PendingRatingTargetDto t,
  ) {
    final current = vm.ratings[t.targetId] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _labelForTarget(t.targetType),
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final isFilled = i < current;
              return GestureDetector(
                onTap: vm.isSubmitting
                    ? null
                    : () => vm.setRating(t.targetId, i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.star_rounded,
                    size: 36,
                    color: isFilled ? AppColors.accent : AppColors.border,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          TextField(
            minLines: 2,
            maxLines: 3,
            maxLength: 250,
            enabled: !vm.isSubmitting,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'rating_optional_comment'.tr(),
              hintStyle: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textLight,
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.accent),
              ),
            ),
            onChanged: (v) => vm.setComment(t.targetId, v),
          ),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context, RatingsViewModel vm, bool canSubmit) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.3),
            disabledForegroundColor: Colors.white70,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: (!canSubmit || vm.isSubmitting)
              ? null
              : () async {
                  final ok = await vm.submitRating(token: widget.token);
                  if (!context.mounted) return;
                  if (ok) {
                    Navigator.pop(context, true);
                  } else {
                    UIHelper.showError(context, 'rating_submit_error'.tr());
                  }
                },
          child: vm.isSubmitting
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text('rating_submit'.tr()),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, RatingsViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 12, 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.star_rounded,
              color: AppColors.accent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'rating_subtitle'.tr(),
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              SolarIconsOutline.closeCircle,
              color: AppColors.textLight,
            ),
            onPressed: vm.isSubmitting ? null : () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  String _labelForTarget(int type) {
    switch (type) {
      case 1:
        return 'rating_tour'.tr();
      case 2:
        return 'rating_vehicle'.tr();
      case 3:
        return 'rating_guide'.tr();
      default:
        return 'rating';
    }
  }
}
