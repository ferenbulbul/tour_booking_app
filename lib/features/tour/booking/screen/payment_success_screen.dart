import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:confetti/confetti.dart';
import 'package:tour_booking/core/theme/app_icon_size.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String conversationId;

  const PaymentSuccessScreen({super.key, required this.conversationId});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
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
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: context.colors.surfaceContainerHighest,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Confetti
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2,
            emissionFrequency: 0.05,
            numberOfParticles: 25,
            gravity: 0.25,
            shouldLoop: false,
            colors: [
              context.ext.success,
              context.ext.confettiGreen,
              context.ext.confettiGold,
              context.colors.secondary,
            ],
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.l,
                AppSpacing.xxxxl,
                AppSpacing.l,
                bottomPad > 0 ? bottomPad : AppSpacing.l,
              ),
              child: Column(
                children: [
                  const Spacer(),

                  // Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.ext.success.withValues(alpha: 0.08),
                      border: Border.all(
                        color: context.ext.success.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Icon(
                      SolarIconsOutline.checkCircle,
                      size: AppIconSize.xxxxl,
                      color: context.ext.success,
                      semanticLabel: 'Payment successful',
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Title
                  Text(
                    tr("payment_success_title"),
                    style: AppTextStyles.titleLarge,
                  ),

                  const SizedBox(height: AppSpacing.s),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Text(
                      tr("payment_success_description"),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: context.colors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  // Reservation code card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.ml),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.ml),
                      border: Border.all(color: context.colors.outline),
                    ),
                    child: Column(
                      children: [
                        Text(
                          tr("reservation_number_title"),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: context.ext.textLight,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          widget.conversationId,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.titleSmall.copyWith(
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Home button
                  Semantics(
                    button: true,
                    label: tr("back_to_home"),
                    child: GestureDetector(
                      onTap: () => context.go('/home'),
                      child: Container(
                        width: double.infinity,
                        height: 46,
                        decoration: BoxDecoration(
                          color: context.colors.secondary,
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          tr("back_to_home"),
                          style: AppTextStyles.labelLarge.copyWith(
                            color: context.colors.onSecondary,
                          ),
                        ),
                      ),
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
