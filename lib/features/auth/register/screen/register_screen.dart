import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/features/auth/register/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Login ekranı ile aynı ferah arka plan
      backgroundColor: const Color(0xFFF8F9FA),
      // AppBar'ı şeffaf yapıyoruz, sadece geri butonu görünüyor
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _CleanRegisterHeader(),
                const SizedBox(height: 30),

                // Form Kartı - Artık ayrı bir dosyadan geliyor
                Container(
                  padding: const EdgeInsets.all(24), // Kart içi boşluk
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child:
                      const RegisterForm(), // Burası import edilen form bileşeni
                ),

                const SizedBox(height: 30),

                // Zaten hesabın var mı?
                const _LoginPrompt(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- HEADER (Ekran içinde tutulabilir) ---
class _CleanRegisterHeader extends StatelessWidget {
  const _CleanRegisterHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'create_account'.tr(), // "Hesap Oluştur"
          style: AppTextStyles.headlineSmall.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'register_subtitle'
              .tr(), // "Formu doldurarak aramıza katıl" (Örnek key)
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.grey[600],
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// --- FOOTER (Ekran içinde tutulabilir) ---
class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tr("already_have_account"), // "Zaten hesabın var mı?"
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () => context.pop(), // Login ekranına geri dön
          child: Text(
            tr("login"), // "Giriş Yap"
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
