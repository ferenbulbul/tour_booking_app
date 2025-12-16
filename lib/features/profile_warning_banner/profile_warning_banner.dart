import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/profile/profile_status_viewmodel.dart';

class ProfileWarningBanner extends StatelessWidget {
  const ProfileWarningBanner({super.key, this.onAction});
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Consumer<ProfileStatusViewModel>(
      builder: (_, vm, __) {
        if (vm.isComplete == null ||
            vm.isComplete == true ||
            vm.dismissedThisSession) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withOpacity(.25),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: scheme.primary.withOpacity(.35),
                width: 1.2,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔵 ICON (premium soft)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: scheme.primary.withOpacity(.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: scheme.primary,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 14),

                // 📄 TEXTS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        "Profilini Tamamla",
                        style: text.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Subtitle
                      Text(
                        "Telefon numaranı doğrulayarak rezervasyon oluşturabilirsin.",
                        style: text.bodySmall?.copyWith(
                          color: scheme.onSurface.withOpacity(.7),
                          height: 1.3,
                        ),
                      ),

                      if (onAction != null) ...[
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: onAction,
                          child: Text(
                            "Şimdi doğrula",
                            style: text.labelLarge?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ❌ CLOSE BUTTON
                GestureDetector(
                  onTap: () => context
                      .read<ProfileStatusViewModel>()
                      .dismissForThisSession(),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: scheme.onSurface.withOpacity(.5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
