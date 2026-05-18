import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
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
          color: scheme.surfaceVariant.withOpacity(.4),
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(
            color: selected
                ? scheme.primary.withOpacity(.4)
                : scheme.outline.withOpacity(.2),
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
                      size: 24,
                    )
                  : Icon(
                      SolarIconsOutline.recordCircle,
                      key: const ValueKey(false),
                      color: scheme.onSurfaceVariant,
                      size: 22,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
