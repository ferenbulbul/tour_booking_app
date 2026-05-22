import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

void showLanguageSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
    ),
    builder: (_) => _LanguageSheetContent(parentContext: context),
  );
}

class _LanguageSheetContent extends StatefulWidget {
  final BuildContext parentContext;
  const _LanguageSheetContent({required this.parentContext});

  @override
  State<_LanguageSheetContent> createState() => _LanguageSheetContentState();
}

class _LanguageSheetContentState extends State<_LanguageSheetContent> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.parentContext.locale.languageCode;
  }

  void _selectLanguage(Locale locale, String title) async {
    setState(() => _selected = locale.languageCode);
    await widget.parentContext.setLocale(locale);
    widget.parentContext.read<HomeViewModel>().init();
    if (mounted) {
      Navigator.of(context).pop();
      UIHelper.showSuccess(
        widget.parentContext,
        tr("language_changed_message", namedArgs: {"language": title}),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = context.textStyles;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxl, AppSpacing.m, AppSpacing.xxl, AppSpacing.l,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppIconSize.xxxl,
              height: AppSpacing.xs,
              decoration: BoxDecoration(
                color: context.colors.outline,
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
            ),
            const SizedBox(height: AppSpacing.ml),
            Text(
              tr('language_settings'),
              style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.l),
            _LanguageRow(
              icon: SolarIconsOutline.globus,
              label: tr("language_turkish"),
              selected: _selected == "tr",
              onTap: () => _selectLanguage(const Locale("tr"), tr("language_turkish")),
            ),
            Divider(height: 1, color: context.colors.outline.withValues(alpha: 0.5)),
            _LanguageRow(
              icon: SolarIconsOutline.globus,
              label: tr("language_english"),
              selected: _selected == "en",
              onTap: () => _selectLanguage(const Locale("en"), tr("language_english")),
            ),
            Divider(height: 1, color: context.colors.outline.withValues(alpha: 0.5)),
            _LanguageRow(
              icon: SolarIconsOutline.globus,
              label: tr("language_arabic"),
              selected: _selected == "ar",
              onTap: () => _selectLanguage(const Locale("ar"), tr("language_arabic")),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageRow({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
        child: Row(
          children: [
            Container(
              width: AppSpacing.xxxl,
              height: AppSpacing.xxxl,
              decoration: BoxDecoration(
                color: scheme.onSurface.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: Icon(icon, size: AppIconSize.ml, color: context.colors.onSurfaceVariant),
            ),
            const SizedBox(width: AppSpacing.ms),
            Expanded(
              child: Text(
                label,
                style: context.textStyles.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: selected
                  ? Icon(
                      SolarIconsOutline.checkCircle,
                      key: const ValueKey(true),
                      color: context.colors.secondary,
                      size: AppIconSize.xl,
                    )
                  : Icon(
                      SolarIconsOutline.recordCircle,
                      key: const ValueKey(false),
                      color: scheme.onSurfaceVariant,
                      size: AppIconSize.xl - 2,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final current = context.locale.languageCode;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: CommonAppBar(title: tr("language_settings")),

      body: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.m),
        child: Column(
          children: [
            _languageTile(
              context,
              title: tr("language_turkish"),
              locale: const Locale("tr"),
              selected: current == "tr",
            ),
            _languageTile(
              context,
              title: tr("language_english"),
              locale: const Locale("en"),
              selected: current == "en",
            ),
            _languageTile(
              context,
              title: tr("language_arabic"),
              locale: const Locale("ar"),
              selected: current == "ar",
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageTile(
    BuildContext context, {
    required String title,
    required Locale locale,
    required bool selected,
  }) {
    final scheme = context.colors;

    return Semantics(
      button: true,
      label: 'Select language $title',
      child: InkWell(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      onTap: () async {
        await context.setLocale(locale);
        context.read<HomeViewModel>().init();

        UIHelper.showSuccess(context, tr("language_changed_message", namedArgs: {"language": title}));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.l,
        ),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(
            color: selected
                ? scheme.primary.withValues(alpha: 0.4)
                : scheme.outline.withValues(alpha: 0.2),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeOutBack,
              child: selected
                  ? Icon(
                      SolarIconsOutline.checkCircle,
                      key: const ValueKey(true),
                      color: scheme.primary,
                      size: AppIconSize.xl,
                      semanticLabel: 'Selected',
                    )
                  : Icon(
                      SolarIconsOutline.recordCircle,
                      key: const ValueKey(false),
                      color: scheme.onSurfaceVariant,
                      size: AppIconSize.xl - 2,
                      semanticLabel: 'Not selected',
                    ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
