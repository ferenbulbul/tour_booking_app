import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/features/tour/booking/place_picker_viewmodel.dart';
import 'package:tour_booking/models/place_section/place_section.dart';

class PlacePickerScreen extends StatefulWidget {
  final String city;
  final String district;

  const PlacePickerScreen({
    super.key,
    required this.city,
    required this.district,
  });

  @override
  State<PlacePickerScreen> createState() => _PlacePickerScreenState();
}

class _PlacePickerScreenState extends State<PlacePickerScreen> {
  final _ctrl = TextEditingController();
  final _debouncer = _Debouncer(ms: 300);

  @override
  void dispose() {
    _debouncer.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PlacePickerViewModel>().search("");
    });
  }

  // ---------------------------------------------------------------------------
  // PICK PLACE
  // ---------------------------------------------------------------------------
  Future<void> _pick(int index) async {
    final vm = context.read<PlacePickerViewModel>();
    final prediction = vm.predictions[index];
    final result = await vm.pick(prediction);

    if (!mounted) return;

    if (result == null) {
      if (vm.errorMessage != null) {
        UIHelper.showError(context, vm.errorMessage!);
      } else {
        UIHelper.showWarning(context, tr("location_coordinates_not_found"));
      }
      return;
    }

    Navigator.pop(
      context,
      PlaceSelection(description: result.description, lat: result.lat, lng: result.lng),
    );
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = context.watch<PlacePickerViewModel>();

    return Scaffold(
      backgroundColor: context.colors.surface,

      body: SafeArea(
        child: Column(
          children: [
            // -------------------------------------------------------------------
            // SEARCH BAR (back button inside)
            // -------------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.m, AppSpacing.l, 0),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : context.ext.surfaceDark,
                  borderRadius: BorderRadius.circular(AppRadius.ml),
                  border: Border.all(color: context.colors.outline.withValues(alpha: 0.4)),
                ),
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Row(
                  children: [
                    // Back button
                    Material(
                      color: Colors.transparent,
                      child: Semantics(
                        button: true,
                        label: 'Go back',
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          onTap: () => Navigator.of(context).pop(),
                          child: SizedBox(
                            width: 48,
                            height: 52,
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: AppIconSize.ml,
                              color: context.colors.onSurface,
                              semanticLabel: 'Back',
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Search field
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        onChanged: (v) => _debouncer(() {
                          context.read<PlacePickerViewModel>().search(v);
                        }),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: context.colors.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: tr(
                            "search_in_location",
                            namedArgs: {
                              "city": widget.city,
                              "district": widget.district,
                            },
                          ),
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: context.ext.textLight,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: AppSpacing.ml),
                        ),
                      ),
                    ),

                    // Clear button
                    if (_ctrl.text.isNotEmpty)
                      Material(
                        color: Colors.transparent,
                        child: Semantics(
                          button: true,
                          label: 'Clear search',
                          child: InkWell(
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            onTap: () {
                              _ctrl.clear();
                              vm.predictions = [];
                              vm.notifyListeners();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.ms),
                              child: Icon(
                                Icons.close_rounded,
                                size: AppIconSize.l,
                                color: context.colors.onSurfaceVariant,
                                semanticLabel: 'Clear search',
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.m),

            if (vm.isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                child: LinearProgressIndicator(
                  color: context.colors.secondary,
                  backgroundColor: context.colors.secondary.withValues(alpha: 0.2),
                ),
              ),

            // -------------------------------------------------------------------
            // RESULTS LIST
            // -------------------------------------------------------------------
            Expanded(
              child: vm.predictions.isEmpty
                  ? Center(
                      child: Text(
                        tr("no_results_found"),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.l, 0, AppSpacing.l, AppSpacing.l),
                      physics: const BouncingScrollPhysics(),
                      itemCount: vm.predictions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.ms),
                      itemBuilder: (_, i) {
                        final p = vm.predictions[i];
                        return Semantics(
                          button: true,
                          label: 'Select place ${p.mainText}',
                          child: InkWell(
                          onTap: () => _pick(i),
                          borderRadius: BorderRadius.circular(AppRadius.large),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.ml),
                            decoration: BoxDecoration(
                              color: context.colors.surface,
                              borderRadius: BorderRadius.circular(AppRadius.large),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  SolarIconsOutline.mapPoint,
                                  color: context.colors.secondary,
                                  size: AppIconSize.xl,
                                  semanticLabel: 'Location',
                                ),

                                const SizedBox(width: AppSpacing.m),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.mainText,
                                        style: AppTextStyles.titleSmall
                                            .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: context.colors.onSurface,
                                            ),
                                      ),
                                      if (p.secondaryText != null)
                                        Text(
                                          p.secondaryText!,
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                color: context.colors.onSurfaceVariant,
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Debouncer
// ---------------------------------------------------------------------------
class _Debouncer {
  final int ms;
  Timer? _t;
  _Debouncer({this.ms = 300});

  void call(void Function() action) {
    _t?.cancel();
    _t = Timer(Duration(milliseconds: ms), action);
  }

  void dispose() {
    _t?.cancel();
  }
}
