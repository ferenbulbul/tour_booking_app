import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/bookings/rating_viewmodel.dart';
import 'package:tour_booking/models/pending_rating/pending_rating_dto.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

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
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: context.colors.secondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.l),
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
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppSpacing.xxxxxl,
                    height: AppSpacing.xxxxxl,
                    decoration: BoxDecoration(
                      color: context.ext.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.ml),
                    ),
                    child: Icon(
                      SolarIconsOutline.infoCircle,
                      color: context.ext.warning,
                      size: AppIconSize.xl,
                      semanticLabel: 'Invalid rating link',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.l),
                  Text(
                    'rating_invalid_link'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: context.colors.primary,
                        foregroundColor: context.colors.onSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
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
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _header(context, vm),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
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
      margin: const EdgeInsets.only(bottom: AppSpacing.ml),
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.ml),
        border: Border.all(
          color: context.colors.outline.withValues(alpha: 0.5),
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
          const SizedBox(height: AppSpacing.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final isFilled = i < current;
              return Semantics(
                button: true,
                label: 'Rate ${i + 1} stars',
                child: GestureDetector(
                  onTap: vm.isSubmitting
                      ? null
                      : () => vm.setRating(t.targetId, i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    child: Icon(
                      Icons.star_rounded,
                      size: AppIconSize.xxxl,
                      color: isFilled ? context.colors.secondary : context.colors.outline,
                      semanticLabel: '${i + 1} stars',
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.m),
          TextField(
            minLines: 2,
            maxLines: 3,
            maxLength: 250,
            enabled: !vm.isSubmitting,
            style: AppTextStyles.bodySmall.copyWith(
              color: context.colors.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'rating_optional_comment'.tr(),
              hintStyle: AppTextStyles.bodySmall.copyWith(
                color: context.ext.textLight,
              ),
              filled: true,
              fillColor: context.colors.surface,
              contentPadding: const EdgeInsets.all(AppSpacing.m),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.ms),
                borderSide: BorderSide(
                  color: context.colors.outline.withValues(alpha: 0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.ms),
                borderSide: BorderSide(
                  color: context.colors.outline.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.ms),
                borderSide: BorderSide(color: context.colors.secondary),
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
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.s, AppSpacing.xl, AppSpacing.xl),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: context.colors.secondary,
            foregroundColor: context.colors.onSecondary,
            disabledBackgroundColor: context.colors.secondary.withValues(alpha: 0.3),
            disabledForegroundColor: context.colors.onSecondary.withValues(alpha: 0.7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
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
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.m, AppSpacing.s),
      child: Row(
        children: [
          Container(
            width: AppSpacing.xxxxl,
            height: AppSpacing.xxxxl,
            decoration: BoxDecoration(
              color: context.colors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Icon(
              Icons.star_rounded,
              color: context.colors.secondary,
              size: AppIconSize.lm,
              semanticLabel: 'Rating',
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Text(
              'rating_subtitle'.tr(),
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Close',
            icon: Icon(
              SolarIconsOutline.closeCircle,
              color: context.ext.textLight,
              semanticLabel: 'Close',
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
