import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:url_launcher/url_launcher.dart';

/// Zorunlu güncelleme ekranı — kapatılamaz (geri tuşu dahil).
/// Router, backend "updateRequired" dediği sürece kullanıcıyı burada tutar.
class ForceUpdateScreen extends StatelessWidget {
  final String? storeUrl;

  const ForceUpdateScreen({super.key, this.storeUrl});

  Future<void> _openStore() async {
    final url = storeUrl;
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: context.colors.surface,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colors.secondary.withValues(alpha: 0.1),
                    ),
                    child: Icon(
                      SolarIconsOutline.refreshCircle,
                      size: 42,
                      color: context.colors.secondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    tr('force_update_title'),
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    tr('force_update_message'),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: context.colors.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  if (storeUrl != null && storeUrl!.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _openStore,
                        child: Text(tr('force_update_button')),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
