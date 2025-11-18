import 'package:flutter/material.dart';
import 'package:tour_booking/core/models/option_item.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';

class OptionPickerSheet extends StatelessWidget {
  final String title;
  final List<OptionItem> options;
  final String? initialId;

  const OptionPickerSheet({
    super.key,
    required this.title,
    required this.options,
    required this.initialId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.40,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                /// --- Sheet Header ---
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// --- Title ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// --- Options List ---
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.l,
                      vertical: 8,
                    ),
                    itemCount: options.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.s),
                    itemBuilder: (_, index) {
                      final item = options[index];
                      final isSelected = item.id == initialId;

                      return GestureDetector(
                        onTap: () => Navigator.pop(context, item.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppRadius.medium,
                            ),
                            color: isSelected
                                ? Colors.blue.withOpacity(0.12)
                                : Colors.grey.shade100,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: isSelected
                                  ? Colors.blueAccent
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
