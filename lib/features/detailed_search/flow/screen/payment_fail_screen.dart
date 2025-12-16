import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';

class PaymentFailPage extends StatelessWidget {
  const PaymentFailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            children: [
              const Spacer(),

              // ❌ ICON + HALO (ERROR)
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.error.withOpacity(.15),
                      AppColors.error.withOpacity(.05),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.error_rounded,
                  size: 64,
                  color: AppColors.error,
                ),
              ),

              const SizedBox(height: 28),

              // ❌ TITLE
              Text(
                "Ödeme Başarısız",
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.4,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Ödemeniz alınamadı.\nLütfen tekrar deneyin veya farklı bir yöntem kullanın.",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 36),

              // ⚠️ INFO CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Ne yapabilirsin?",
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _hint("• Kart bilgilerini kontrol et"),
                    _hint("• İnternet bağlantını kontrol et"),
                    _hint("• Daha sonra tekrar dene"),
                  ],
                ),
              ),

              const Spacer(),

              // 🔁 CTA
              SizedBox(
                width: double.infinity,
                height: 52,
                child: PrimaryButton(
                  text: "Ana Sayfaya Dön",
                  onPressed: () => context.go('/home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
