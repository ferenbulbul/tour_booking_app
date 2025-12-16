import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';

class PickerSheet extends StatefulWidget {
  final String title;
  final List<PickerOption> options;
  final String? initialId;

  const PickerSheet({
    super.key,
    required this.title,
    required this.options,
    required this.initialId,
  });

  @override
  State<PickerSheet> createState() => _PickerSheet();
}

class _PickerSheet extends State<PickerSheet> {
  String query = "";
  Timer? _debounce;

  List<PickerOption> get filtered {
    if (query.isEmpty) return widget.options;
    final q = query.toLowerCase();
    return widget.options
        .where((o) => o.name.toLowerCase().contains(q))
        .toList();
  }

  void _onSearchChanged(String v) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 130), () {
      if (query != v) {
        setState(() => query = v);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.45,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                /// HANDLE
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(.22)
                          : Colors.black.withOpacity(.18),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                /// SEARCH BAR
                _SearchBar(isDark: isDark, onChanged: _onSearchChanged),

                const SizedBox(height: 14),

                /// LIST
                Expanded(
                  child: ListView.separated(
                    controller: controller,
                    itemCount: filtered.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.l,
                      vertical: 8,
                    ),
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.s),
                    itemBuilder: (_, i) {
                      final item = filtered[i];
                      final selected = item.id == widget.initialId;

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
                            color: selected
                                ? AppColors.primary.withOpacity(.10)
                                : (isDark
                                      ? Colors.white.withOpacity(.05)
                                      : Colors.grey.shade100),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
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

class _SearchBar extends StatelessWidget {
  final bool isDark;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.isDark, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(.07)
            : Colors.black.withOpacity(.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(.12)
              : Colors.black.withOpacity(.08),
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary.withOpacity(.8),
            size: 20,
          ),
          hintText: "Ara...",
          hintStyle: TextStyle(color: AppColors.textLight.withOpacity(.85)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12,
          ),
        ),
      ),
    );
  }
}

class PickerOption {
  final String id;
  final String name;
  const PickerOption(this.id, this.name);
}
