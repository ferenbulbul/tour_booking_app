import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/theme/app_radius.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/theme/app_text_styles.dart';
import 'package:tour_booking/core/theme/app_theme_context.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/tour/booking/payment_viewmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String bookingId;
  const PaymentScreen({super.key, required this.bookingId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  WebViewController? _controller;
  late AnimationController _pulseController;
  bool _callbackDetected = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentViewModel>().initPayment(widget.bookingId);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  /// Called once when the callback URL is fully loaded (onPageFinished).
  /// The ViewModel's retry logic gives the backend time to process.
  void _onCallbackPageLoaded(PaymentViewModel vm) {
    final token = vm.initData?.token;
    if (token == null) return;

    vm.checkPaymentResult(token).then((_) {
      if (!mounted) return;

      if (vm.resultData?.paymentStatus == "Success" &&
          vm.resultData?.bookingStatus == "Success") {
        context.replace(
          '/payment-success',
          extra: widget.bookingId,
        );
      } else {
        context.replace('/payment-fail');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentViewModel>(
      builder: (context, vm, _) {
        // Show checking screen first — takes priority over everything
        if (vm.isCheckingPayment) {
          return _buildCheckingPaymentScreen();
        }

        if (vm.isLoading) {
          return Scaffold(
            appBar: CommonAppBar(title: tr('payment_title')),
            body: Center(
              child: CircularProgressIndicator(
                color: context.colors.secondary,
              ),
            ),
          );
        }

        if (vm.errorMessage != null) {
          return Scaffold(
            appBar: CommonAppBar(title: tr('payment_title')),
            body: Center(
              child: Text("${tr("payment_error_prefix")} ${vm.errorMessage}"),
            ),
          );
        }

        final url = vm.initData?.paymentPageUrl;

        if (url != null && _controller == null) {
          _controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onNavigationRequest: (req) {
                  // Detect callback URL early — only switch to checking UI.
                  // Do NOT call the API here; the backend hasn't processed
                  // the iyzico callback yet at this point.
                  const callbackIdentifier = "payments/callback";
                  if (req.url.contains(callbackIdentifier) &&
                      !_callbackDetected) {
                    _callbackDetected = true;
                    vm.setCheckingPayment(true);
                  }
                  return NavigationDecision.navigate;
                },
                onPageFinished: (String finishedUrl) {
                  // When the callback page finishes loading, the backend
                  // has received iyzico's POST — safe to query the result.
                  if (_callbackDetected) {
                    _onCallbackPageLoaded(vm);
                  } else {
                    vm.setPageFinished();
                  }
                },
              ),
            )
            ..loadRequest(Uri.parse(url));
        }

        return Scaffold(
          appBar: CommonAppBar(title: tr("payment_title")),
          body: _controller == null
              ? Center(child: Text(tr("payment_page_preparing")))
              : Stack(
                  children: [
                    WebViewWidget(controller: _controller!),
                    if (!vm.isPageFinished)
                      Scaffold(
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: context.colors.secondary,
                              ),
                              const SizedBox(height: AppSpacing.l),
                              Text(
                                tr('payment_page_loading'),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: context.colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildCheckingPaymentScreen() {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pulsing icon
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = 1.0 + (_pulseController.value * 0.08);
                  final opacity = 0.7 + (_pulseController.value * 0.3);
                  return Transform.scale(
                    scale: scale,
                    child: Opacity(opacity: opacity, child: child),
                  );
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: context.colors.secondary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    SolarIconsOutline.card,
                    size: 36,
                    color: context.colors.secondary,
                    semanticLabel: 'Payment processing',
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Title
              Text(
                tr('payment_checking_result'),
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.colors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.m),

              // Subtitle
              Text(
                tr('payment_checking_subtitle'),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Progress bar
              SizedBox(
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    backgroundColor:
                        context.colors.secondary.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.colors.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
