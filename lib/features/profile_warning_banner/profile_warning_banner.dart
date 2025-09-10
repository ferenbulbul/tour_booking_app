import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/profile/profile_status_viewmodel.dart';

class ProfileWarningBanner extends StatelessWidget {
  const ProfileWarningBanner({super.key, this.onAction});
  final VoidCallback? onAction; // Örn: Telefon doğrulama sayfasına git

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileStatusViewModel>(
      builder: (_, vm, __) {
        // Yükleniyor, profil tamamlanmış veya bu oturumda kapatılmışsa gösterme
        if (vm.isComplete == null ||
            vm.isComplete == true ||
            vm.dismissedThisSession) {
          return const SizedBox.shrink();
        }

        // Ana banner'ı ekran kenarlarından boşluk bırakacak şekilde yerleştiriyoruz.
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              // Arka plan rengini daha yumuşak bir tona çeviriyoruz
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              // Kenarlık ekleyerek kartı daha belirgin hale getiriyoruz
              border: Border.all(color: Colors.amber.shade200, width: 1.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Sol taraftaki ikon
                Icon(
                  Icons.info_outline_rounded,
                  color: Colors.amber.shade800,
                  size: 28,
                ),
                const SizedBox(width: 12),
                // Mesaj ve Buton
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Profilini Tamamla',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.amber.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Telefon numaranı doğrulayarak sipariş oluşturabilirsin.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Eğer bir aksiyon varsa butonu göster
                      if (onAction != null) ...[
                        const SizedBox(height: 4),
                        // Butonu daha az yer kaplayan bir TextButton ile değiştiriyoruz
                        TextButton(
                          onPressed: onAction,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft,
                          ),
                          child: Text(
                            'Şimdi Doğrula',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Sağ üst köşedeki kapatma butonu
                IconButton(
                  onPressed: () => context
                      .read<ProfileStatusViewModel>()
                      .dismissForThisSession(),
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  tooltip: 'Kapat',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
