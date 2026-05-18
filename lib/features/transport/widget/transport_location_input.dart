import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/widgets/shake_widget.dart';

// ─────────────────────────────────────────────────────────────
// Single location input (used standalone or inside Connected)
// ─────────────────────────────────────────────────────────────

class TransportLocationInput extends StatelessWidget {
  final String label;
  final String? address;
  final Color dotColor;
  final VoidCallback onTap;
  final bool showError;
  final bool showBorder;
  final bool showDot;
  final BorderRadius? borderRadius;

  const TransportLocationInput({
    super.key,
    required this.label,
    this.address,
    required this.dotColor,
    required this.onTap,
    this.showError = false,
    this.showBorder = true,
    this.showDot = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final hasAddress = address != null && address!.isNotEmpty;

    final Color borderColor;
    if (showError) {
      borderColor = AppColors.error.withValues(alpha: 0.5);
    } else if (hasAddress) {
      borderColor = dotColor.withValues(alpha: 0.4);
    } else {
      borderColor = AppColors.border;
    }

    // Subtle tinted background when filled
    final Color bgColor;
    if (hasAddress) {
      bgColor = dotColor.withValues(alpha: 0.04);
    } else {
      bgColor = AppColors.surface;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: showBorder ? bgColor : Colors.transparent,
          borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.medium),
          border: showBorder ? Border.all(color: borderColor) : null,
        ),
        child: Row(
          children: [
            if (showDot) ...[
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: hasAddress ? dotColor : dotColor.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                  border: hasAddress
                      ? null
                      : Border.all(color: dotColor.withValues(alpha: 0.5), width: 1.5),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                hasAddress ? address! : label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 14,
                  fontWeight: hasAddress ? FontWeight.w500 : FontWeight.w400,
                  color: hasAddress ? AppColors.textPrimary : AppColors.textLight,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              SolarIconsOutline.gps,
              size: 18,
              color: hasAddress ? AppColors.textSecondary : AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Connected pickup + dropoff (Uber/Bolt style)
// ─────────────────────────────────────────────────────────────

class ConnectedLocationInputs extends StatelessWidget {
  final String pickupLabel;
  final String? pickupAddress;
  final String dropoffLabel;
  final String? dropoffAddress;
  final VoidCallback onPickupTap;
  final VoidCallback onDropoffTap;
  final VoidCallback? onSwap;
  final bool showPickupError;
  final bool showDropoffError;
  final GlobalKey<ShakeWidgetState>? pickupShakeKey;
  final GlobalKey<ShakeWidgetState>? dropoffShakeKey;

  const ConnectedLocationInputs({
    super.key,
    required this.pickupLabel,
    this.pickupAddress,
    required this.dropoffLabel,
    this.dropoffAddress,
    required this.onPickupTap,
    required this.onDropoffTap,
    this.onSwap,
    this.showPickupError = false,
    this.showDropoffError = false,
    this.pickupShakeKey,
    this.dropoffShakeKey,
  });

  bool get _hasPickup => pickupAddress != null && pickupAddress!.isNotEmpty;
  bool get _hasDropoff => dropoffAddress != null && dropoffAddress!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main container
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(color: AppColors.border),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Left rail: dots + dashed line ──
                SizedBox(
                  width: 40,
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      // Green dot (pickup)
                      _dot(AppColors.success, _hasPickup),
                      // Dashed line
                      Expanded(
                        child: CustomPaint(
                          painter: _DashedVerticalLinePainter(
                            color: AppColors.border,
                          ),
                          child: const SizedBox(width: 2),
                        ),
                      ),
                      // Red dot (dropoff)
                      _dot(AppColors.error, _hasDropoff),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),

                // ── Right column: input rows ──
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pickup
                      ShakeWidget(
                        key: pickupShakeKey,
                        child: TransportLocationInput(
                          label: pickupLabel,
                          address: pickupAddress,
                          dotColor: AppColors.success,
                          onTap: onPickupTap,
                          showError: showPickupError,
                          showBorder: false,
                          showDot: false,
                        ),
                      ),
                      // Dashed horizontal divider
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          height: 1,
                          child: CustomPaint(
                            painter: _DashedHorizontalLinePainter(
                              color: AppColors.border,
                            ),
                            child: const SizedBox(width: double.infinity),
                          ),
                        ),
                      ),
                      // Dropoff
                      ShakeWidget(
                        key: dropoffShakeKey,
                        child: TransportLocationInput(
                          label: dropoffLabel,
                          address: dropoffAddress,
                          dotColor: AppColors.error,
                          onTap: onDropoffTap,
                          showError: showDropoffError,
                          showBorder: false,
                          showDot: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Swap button (right-center) ──
        if (onSwap != null)
          Positioned(
            right: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: onSwap,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    SolarIconsOutline.sortVertical,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _dot(Color color, bool filled) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.25),
        shape: BoxShape.circle,
        border: filled
            ? null
            : Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Painters
// ─────────────────────────────────────────────────────────────

class _DashedVerticalLinePainter extends CustomPainter {
  final Color color;
  _DashedVerticalLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const dashHeight = 4.0;
    const dashSpace = 3.0;
    double y = 0;
    final x = size.width / 2;

    while (y < size.height) {
      canvas.drawLine(Offset(x, y), Offset(x, y + dashHeight), paint);
      y += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DashedHorizontalLinePainter extends CustomPainter {
  final Color color;
  _DashedHorizontalLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashSpace = 3.0;
    double x = 0;

    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
