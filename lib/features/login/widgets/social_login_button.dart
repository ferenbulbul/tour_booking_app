import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/features/login/widgets/google_view_model.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    // final googleVM = Provider.of<GoogleViewModel>(context); // Bu satır doğrudan build metodu içinde kullanılmadığı için burada durmasına gerek yok.

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Eğer Facebook girişi de asenkron bir işlem içeriyorsa,
            // buraya da benzer bir yükleme animasyonu ekleyebilirsiniz.
            context.go('/home');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 12),
              Icon(Icons.facebook, color: AppColors.primary, size: 30),
              const SizedBox(width: 12),
              Text('login_with_facebook'.tr()),
            ],
          ),
        ),

        const SizedBox(height: 12),

        ElevatedButton(
          onPressed: () async {
            // 1. Yükleme animasyonunu göster
            showDialog(
              context: context,
              barrierDismissible:
                  false, // Kullanıcının dialogu kapatmasını engeller
              builder: (context) => const Center(
                child: CircularProgressIndicator(
                  color: AppColors
                      .primary, // Temanıza uygun bir renk seçebilirsiniz
                ),
              ),
            );

            // GoogleViewModel'ı dinlemeden alıyoruz çünkü sadece metodunu çağıracağız
            final viewModel = Provider.of<GoogleViewModel>(
              context,
              listen: false,
            );

            // 2. Google giriş işlemini başlat
            final result = await viewModel.signInWithGoogle();

            // 3. Yükleme animasyonunu gizle
            // context'in hala mounted olup olmadığını kontrol etmek önemlidir.
            if (context.mounted) {
              Navigator.of(context).pop(); // Yükleme dialogunu kapat
            }

            // 4. Sonuca göre işlem yap
            if (context.mounted) {
              // Dialog kapandıktan sonra context'in hala geçerli olup olmadığını tekrar kontrol et
              if (result.isSuccess) {
                context.go('/home');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      result.error?.message ?? "Bilinmeyen bir hata oluştu.",
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/google_logo.png',
                width: 25, // Facebook ikonunla aynı boy!
                height: 25,
              ),
              const SizedBox(width: 12),
              Text('login_with_google'.tr()),
            ],
          ),
        ),
      ],
    );
  }
}
