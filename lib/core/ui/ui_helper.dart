import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_colors.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';

class UIHelper {
  /// MaterialApp.router'a verilecek global key.
  static final rootMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static String? _lastMessage;
  static DateTime? _lastShown;
  static const _deduplicateWindow = Duration(seconds: 2);

  static bool _isDuplicate(String message) {
    final now = DateTime.now();
    if (_lastMessage == message &&
        _lastShown != null &&
        now.difference(_lastShown!) < _deduplicateWindow) {
      return true;
    }
    _lastMessage = message;
    _lastShown = now;
    return false;
  }

  static void showSuccess(BuildContext context, String message) {
    _showSnack(context, message, AppColors.success, SolarIconsOutline.checkCircle);
  }

  static void showError(BuildContext context, String message) {
    _showSnack(context, message, AppColors.error, SolarIconsOutline.closeCircle);
  }

  static void showWarning(BuildContext context, String message) {
    _showSnack(context, message, AppColors.warning, SolarIconsOutline.infoCircle);
  }

  static void showValidationErrors(BuildContext context, List<String> errors) {
    final fullText = errors.join("\n");
    _showSnack(context, fullText, AppColors.error, SolarIconsOutline.dangerCircle);
  }

  // ─── Ana gösterim metodu ───────────────────────────────────
  static void _showSnack(BuildContext context, String text, Color bg, IconData icon) {
    if (_isDuplicate(text)) return;

    // Bottom sheet veya dialog içindeyken ScaffoldMessenger snackbar'ı
    // modalın altında gösterir. Bu durumda Overlay'e direkt ekliyoruz.
    final route = ModalRoute.of(context);
    if (route is PopupRoute) {
      _showOverlaySnack(context, text, bg, icon);
      return;
    }

    final messenger = rootMessengerKey.currentState ?? ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ));
  }

  // ─── Modal içi overlay snackbar ────────────────────────────
  static OverlayEntry? _currentOverlayEntry;

  static void _showOverlaySnack(BuildContext context, String text, Color bg, IconData icon) {
    _currentOverlayEntry?.remove();
    _currentOverlayEntry = null;

    final overlay = Overlay.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _AnimatedOverlaySnack(
        text: text,
        bg: bg,
        icon: icon,
        bottom: bottomInset + bottomPadding + 16,
        onDismissed: () {
          entry.remove();
          if (_currentOverlayEntry == entry) _currentOverlayEntry = null;
        },
      ),
    );

    _currentOverlayEntry = entry;
    overlay.insert(entry);
  }
}

// ─── Animasyonlu overlay snackbar widget ──────────────────────
class _AnimatedOverlaySnack extends StatefulWidget {
  final String text;
  final Color bg;
  final IconData icon;
  final double bottom;
  final VoidCallback onDismissed;

  const _AnimatedOverlaySnack({
    required this.text,
    required this.bg,
    required this.icon,
    required this.bottom,
    required this.onDismissed,
  });

  @override
  State<_AnimatedOverlaySnack> createState() => _AnimatedOverlaySnackState();
}

class _AnimatedOverlaySnackState extends State<_AnimatedOverlaySnack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _controller.reverse().then((_) {
      if (mounted) widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: widget.bottom,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.bg,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(widget.icon, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
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
