import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/buttons/primary_button.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String conversitationId;

  const PaymentSuccessPage({super.key, required this.conversitationId});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // 🎉 Sayfa açılır açılmaz patlasın
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // 🎉 CONFETTI (üstten yağar, premium)
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2, // aşağı
            emissionFrequency: 0.05,
            numberOfParticles: 25,
            gravity: 0.25,
            shouldLoop: false,
            colors: const [
              Color(0xff4CAF50),
              Color(0xff81C784),
              Color(0xffA5D6A7),
              Color(0xffFFD54F),
            ],
          ),

          // 🔥 ASIL UI (hiç bozulmadı)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              child: Column(
                children: [
                  const Spacer(),

                  // ✅ ICON + HALO
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.success.withOpacity(.15),
                          AppColors.success.withOpacity(.05),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 64,
                      color: AppColors.success,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ✅ TITLE
                  Text(
                    "Ödeme Başarılı",
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.4,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Rezervasyonunuz başarıyla tamamlandı.\nKeyifli bir tur dileriz ✨",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // 🎟️ REZERVASYON KODU
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
                          "Rezervasyon Numaranız",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.conversitationId,
                          style: AppTextStyles.bodyMedium.copyWith(
                            letterSpacing: .6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // 🔘 HOME BUTTON (isteğe bağlı ama yakışır)
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
        ],
      ),
    );
  }
}
