import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/bookings/rating_viewmodel.dart';
import 'package:tour_booking/models/pending_rating/pending_rating_dto.dart';

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
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 36,
                    width: 36,
                    child: CircularProgressIndicator(strokeWidth: 3),
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
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'rating_invalid_link'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('common_close'.tr()),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final canSubmit = vm.ratings.values.any(
          (v) => v > 0,
        ); // 🔥 güçlü kontrol

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _header(context, vm),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _labelForTarget(t.targetType),
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (i) {
              return IconButton(
                onPressed: vm.isSubmitting
                    ? null
                    : () => vm.setRating(t.targetId, i + 1),
                icon: Icon(
                  i < current ? Icons.star_rounded : Icons.star_border_rounded,
                  color: Colors.amber,
                ),
              );
            }),
          ),
          TextField(
            minLines: 2,
            maxLines: 4,
            maxLength: 250,
            enabled: !vm.isSubmitting, // 🔥 submit sırasında kilitle
            decoration: InputDecoration(
              hintText: 'rating_optional_comment'.tr(),
            ),
            onChanged: (v) => vm.setComment(t.targetId, v),
          ),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context, RatingsViewModel vm, bool canSubmit) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: (!canSubmit || vm.isSubmitting)
            ? null
            : () async {
                final ok = await vm.submitRating(token: widget.token);

                if (!context.mounted) return;

                if (ok) {
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('rating_submit_error'.tr())),
                  );
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
    );
  }

  Widget _header(BuildContext context, RatingsViewModel vm) => ListTile(
    subtitle: Text(
      'rating_subtitle'.tr(),
      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500),
    ),
    trailing: IconButton(
      icon: const Icon(Icons.close),
      onPressed: vm.isSubmitting ? null : () => Navigator.pop(context),
    ),
  );

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
