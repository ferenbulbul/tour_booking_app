import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/home/home_viewmodel.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final current = context.locale.languageCode;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: const CommonAppBar(title: "Dil Ayarları"),

      body: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.m),
        child: Column(
          children: [
            _languageTile(
              context,
              title: "Türkçe",
              locale: const Locale("tr"),
              selected: current == "tr",
            ),
            _languageTile(
              context,
              title: "English",
              locale: const Locale("en"),
              selected: current == "en",
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Uygulama dili '$title' olarak değiştirildi",
              style: TextStyle(color: scheme.onPrimary),
            ),
            backgroundColor: scheme.primary,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(AppSpacing.m),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
          ),
        );
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
                      Icons.check_circle_rounded,
                      key: const ValueKey(true),
                      color: scheme.primary,
                      size: 24,
                    )
                  : Icon(
                      Icons.circle_outlined,
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
