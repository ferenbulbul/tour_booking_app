import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:tour_booking/core/di/service_locator.dart';
import 'package:tour_booking/services/core/analytics_service.dart';
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
  bool _ktResultHandled = false;

  /// Webview açıkken dönen arka plan polling'i — banka yönlendirmesi hiç
  /// gelmese bile sonucu yakalar (backend Pending KT'de bankaya anlık sorar).
  Timer? _bgPollTimer;

  /// Sonuç ekranına bir kez gidilmesini garanti eder (polling + yönlendirme
  /// + KT yakalama aynı anda tetiklenebilir).
  bool _finished = false;

  /// Bankanın dönüş parametrelerinden yakalanan hata sebebi (fail ekranında gösterilir).
  String? _bankMessage;

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
    _bgPollTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  /// Webview açıldığı andan itibaren her 10 sn'de bir sonucu yoklar.
  /// Terminal sonuç gelirse webview'i beklemeden native ekrana geçer.
  void _startBackgroundPolling(PaymentViewModel vm) {
    _bgPollTimer?.cancel();
    _bgPollTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      if (_finished || !mounted) return;
      final token = vm.initData?.token;
      if (token == null) return;
      final terminal = await vm.checkPaymentResultOnce(token);
      if (terminal && mounted) _finishWithResult(vm);
    });
  }

  /// Sonucu TEK noktadan kapatır: polling, yönlendirme ve KT yakalama
  /// hangisi önce ulaşırsa ulaşsın çifte navigasyon olmaz.
  void _finishWithResult(PaymentViewModel vm) {
    if (_finished || !mounted) return;
    _finished = true;
    _bgPollTimer?.cancel();

    if (vm.resultData?.paymentStatus == "Success" &&
        vm.resultData?.bookingStatus == "Success") {
      _logPurchaseAnalytics(vm);
      context.replace('/payment-success', extra: widget.bookingId);
    } else {
      AnalyticsService.instance.logEvent('payment_failed');
      context.replace('/payment-fail', extra: _bankMessage);
    }
  }

  /// Başarılı ödemede analitik: Meta Purchase (reklam optimizasyonunun ana
  /// sinyali) + Firebase purchase. Fire-and-forget — akışı asla bekletmez.
  void _logPurchaseAnalytics(PaymentViewModel vm) {
    final amount = vm.resultData?.amount;
    final currency = vm.resultData?.currency ?? 'TRY';
    if (amount != null && amount > 0) {
      ServiceLocator.instance.metaEventsService
          .logPurchase(amount: amount, currency: currency);
      AnalyticsService.instance.logEvent('purchase', parameters: {
        'value': amount,
        'currency': currency,
      });
    } else {
      AnalyticsService.instance.logEvent('purchase');
    }
  }

  /// Banka IP eşleşme reddi (ResponseCode=99) sonrası tek seferlik otomatik
  /// yeniden başlatma yapıldı mı?
  bool _ipMismatchRetried = false;

  /// Bankanın dönüş URL'lerindeki hata sebebini yakalar (kt/return ve
  /// SecurePaymentResult, ResponseCode/ResponseMessage paramları taşır).
  void _captureBankMessage(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final path = uri.path.toLowerCase();
    if (!path.contains('payments/kt/return') &&
        !path.contains('securepaymentresult')) {
      return;
    }
    final code = uri.queryParameters['ResponseCode'];
    final message = uri.queryParameters['ResponseMessage'];
    if (code != null && code != '00' && message != null && message.isNotEmpty) {
      _bankMessage = message;
    }
  }

  /// ResponseCode=99: banka "token alınan IP ile sayfayı açan IP farklı" dedi —
  /// mobil ağlarda cihaz Wi-Fi↔hücresel arasında geçince oluyor (2026-08-26'da
  /// gerçek cihazda tespit edildi; para ÇEKİLMEZ, form hiç açılmaz). Kullanıcıya
  /// hata göstermek yerine BİR kez sessizce yeni ödeme başlatıp taze sayfayı
  /// yükleriz — ikinci denemede ağ genelde oturmuş olur. İkincisi de 99 yerse
  /// normal hata akışı işler (fail ekranı banka mesajıyla).
  bool _isIpMismatchRedirect(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (!uri.path.toLowerCase().contains('payments/kt/return')) return false;
    return uri.queryParameters['ResponseCode'] == '99';
  }

  Future<void> _retryAfterIpMismatch(PaymentViewModel vm) async {
    _ipMismatchRetried = true;
    _callbackDetected = false;
    _ktResultHandled = false;
    _bankMessage = null;
    vm.setCheckingPayment(false);

    await vm.initPayment(widget.bookingId); // yeni kayıt + taze hosted URL
    if (!mounted || _finished) return;

    final url = vm.initData?.paymentPageUrl;
    if (url != null) {
      _controller?.loadRequest(Uri.parse(url));
    }
    // initPayment de başarısız olduysa errorMessage dolar → mevcut nazik
    // hata ekranı (Tekrar Dene) devreye girer.
  }

  /// Callback URL'i sadece substring ile değil, host bazında doğrula:
  /// path'te payments/callback geçmeli VE host kendi API'mizin host'u olmalı.
  bool _isCallbackUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (!uri.path.toLowerCase().contains('payments/callback')) return false;

    final apiHost = Uri.tryParse(dotenv.env['cloud'] ?? '')?.host;
    return apiHost != null && apiHost.isNotEmpty && uri.host == apiHost;
  }

  /// KT hosted kart formu sayfası mı? (sonuç sayfası DEĞİL — o ayrı ele alınır)
  bool _isKuveytTurkPaymentPageUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    final path = uri.path.toLowerCase();
    return uri.host.toLowerCase().endsWith('kuveytturk.com.tr') &&
        path.contains('ktpay/securepayment') &&
        !path.contains('securepaymentresult');
  }

  /// Bankanın kart formu inputları type=text geliyor (tam klavye açılıyor) ve
  /// autocomplete ipuçları yok. Sayfaya küçük bir JS enjekte edip kart/CVV/tarih
  /// alanlarına inputmode=numeric (sayı klavyesi) + autocomplete cc-* ipuçları
  /// basıyoruz. Banka sayfa yapısını değiştirirse enjeksiyon sessizce etkisiz
  /// kalır — akışı hiçbir durumda bozmaz. (Alan id'leri: card-number,
  /// card-expire-date, card-cvv, card-holder — 2026-08-23'te sayfadan doğrulandı.)
  void _enhanceKuveytTurkCardForm() {
    _controller?.runJavaScript('''
      (function () {
        function tune(id, mode, ac) {
          var e = document.getElementById(id);
          if (!e) return;
          if (mode) e.setAttribute('inputmode', mode);
          if (ac) e.setAttribute('autocomplete', ac);
        }
        tune('card-number', 'numeric', 'cc-number');
        tune('card-expire-date', 'numeric', 'cc-exp');
        tune('card-cvv', 'numeric', 'cc-csc');
        tune('card-holder', null, 'cc-name');
      })();
    ''');
  }

  /// Kuveyt Türk hosted ödeme, successUrl'e YÖNLENDİRME YAPMAZ (2026-08-18'de
  /// banka ortamına karşı kanıtlandı); sonucu kendi SecurePaymentResult
  /// sayfasının URL parametrelerinde verir (Result, MerchantOrderId, OrderId...).
  bool _isKuveytTurkResultUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    return uri.host.toLowerCase().endsWith('kuveytturk.com.tr') &&
        uri.path.toLowerCase().contains('ktpay/securepaymentresult');
  }

  /// KT sonucu yakalandığında kendi API'mizin kt/return ucunu webview'de açar;
  /// backend inquiry ile teyit edip callback/done'a yönlendirir — oradan sonrası
  /// Iyzico akışıyla aynı (callback tespiti → polling → native ekran).
  bool _handleKuveytTurkResult(PaymentViewModel vm, String url) {
    if (_ktResultHandled) return true;
    final uri = Uri.tryParse(url);
    final oid = uri?.queryParameters['MerchantOrderId'];
    if (oid == null || oid.isEmpty) return false;
    _ktResultHandled = true;

    final result = uri!.queryParameters['Result'];
    final status = result?.toLowerCase() == 'success' ? 'SUCCESS' : 'FAIL';
    final apiBase = (dotenv.env['cloud'] ?? '').replaceAll(RegExp(r'/+$'), '');
    // kt/return sayfası (302 → callback/done) yüklendiğinde polling başlasın;
    // yüklenemese bile polling + reconciliation sonucu güvenle çözer.
    _callbackDetected = true;
    vm.setCheckingPayment(true);
    _controller?.loadRequest(
      Uri.parse('$apiBase/payments/kt/return?status=$status&oid=$oid'),
      // ngrok free'nin tarayıcı uyarı sayfası dev'de zinciri kesmesin (prod'da etkisiz).
      headers: const {'ngrok-skip-browser-warning': '1'},
    );
    return true;
  }

  /// Called once when the callback URL is fully loaded (onPageFinished).
  /// The ViewModel's retry logic gives the backend time to process.
  void _onCallbackPageLoaded(PaymentViewModel vm) {
    final token = vm.initData?.token;
    if (token == null) return;

    vm.checkPaymentResult(token).then((_) {
      if (!mounted || _finished) return;

      if (vm.isResultUnknown) {
        // Sonuç netleşmedi — para çekilmiş olabilir; başarısız GÖSTERME.
        // Backend reconciliation birkaç dakika içinde durumu çözer.
        _finished = true;
        _bgPollTimer?.cancel();
        _showPendingResultAndLeave();
      } else {
        _finishWithResult(vm);
      }
    });
  }

  Future<void> _showPendingResultAndLeave() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(tr('payment_result_pending_title')),
        content: Text(tr('payment_result_pending_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(tr('payment_result_pending_ok')),
          ),
        ],
      ),
    );
    if (mounted) context.go('/reservations');
  }

  /// Ödeme sürerken çıkışta onay iste; ödeme başlamadıysa direkt çık.
  /// Geri/çıkış davranışı çıkış ANINA göre ayrışır (2026-08-26):
  ///  • Ödeme henüz DENENMEDİYSE (kart formu aşaması) → özete GERİ dön (pop):
  ///    kullanıcı satın alma akışında kalır, "Ödemeye Geç" ile kaldığı yerden
  ///    devam eder. Form hiç yüklenmediyse dialog bile sorulmaz (para riski yok).
  ///  • Ödeme GÖNDERİLDİYSE (callback algılandı / sonuç kontrol ediliyor) →
  ///    Seyahatlerim: para çekilmiş olabilir; özete döndürüp "tekrar öde"
  ///    dedirtmek çifte ödeme riski doğurur — reconciliation arkada tamamlar.
  Future<void> _handleBackPressed(PaymentViewModel vm) async {
    final paymentSubmitted = _callbackDetected || vm.isCheckingPayment;

    // Banka sayfası daha yüklenmediyse (veya init hatası ekranındaysak):
    // sorulacak bir şey yok, sessizce özete dön.
    if (!paymentSubmitted && !vm.isPageFinished) {
      Navigator.of(context).pop();
      return;
    }

    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(tr('payment_exit_title')),
        content: Text(tr('payment_exit_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(tr('payment_exit_stay')),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(tr('payment_exit_leave')),
          ),
        ],
      ),
    );

    if (leave == true && mounted) {
      if (paymentSubmitted) {
        // Sonuç ekranda netleşmeden çıkılıyor — rezervasyonlara yönlendir,
        // ödeme alındıysa polling/reconciliation rezervasyonu otomatik onaylar.
        context.go('/reservations');
      } else {
        // Kart formundan vazgeçti — satın alma akışına (özet ekranına) geri dön.
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentViewModel>(
      builder: (context, vm, _) {
        // Sistem geri tuşu (Android) ödeme sürerken onaysız çıkışa izin vermesin.
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            _handleBackPressed(vm);
          },
          child: _buildBody(context, vm),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PaymentViewModel vm) {
    // Show checking screen first — takes priority over everything
    if (vm.isCheckingPayment) {
      return _buildCheckingPaymentScreen();
    }

    if (vm.isLoading) {
      return Scaffold(
        appBar: CommonAppBar(
          title: tr('payment_title'),
          onBack: () => _handleBackPressed(vm),
        ),
        body: Center(
          child: CircularProgressIndicator(color: context.colors.secondary),
        ),
      );
    }

    if (vm.errorMessage != null) {
      // Ham hata metnini (exception/HTML dökümü) ASLA gösterme — banka geçici
      // engellerinde (WAF vb.) kullanıcıya sakin, tekrar denemeye teşvik eden
      // bir ekran çıkar. Kartından para çekilmediği açıkça söylenir.
      return Scaffold(
        appBar: CommonAppBar(
          title: tr('payment_title'),
          onBack: () => _handleBackPressed(vm),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colors.secondary.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    SolarIconsOutline.cloudCross,
                    size: 34,
                    color: context.colors.secondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  tr('payment_init_failed_title'),
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.m),
                Text(
                  tr('payment_init_failed_message'),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.colors.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => vm.initPayment(widget.bookingId),
                    child: Text(tr('payment_init_retry')),
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(tr('payment_init_go_back')),
                ),
              ],
            ),
          ),
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
              // IP eşleşme reddi → kullanıcıya göstermeden bir kez tazele.
              if (!_ipMismatchRetried && _isIpMismatchRedirect(req.url)) {
                _retryAfterIpMismatch(vm);
                return NavigationDecision.prevent;
              }

              _captureBankMessage(req.url);

              // KT hosted: bankanın sonuç sayfasını yakala, kt/return'e taşı.
              if (_isKuveytTurkResultUrl(req.url) &&
                  _handleKuveytTurkResult(vm, req.url)) {
                return NavigationDecision.prevent;
              }
              // Detect callback URL early — only switch to checking UI.
              // Do NOT call the API here; the backend hasn't processed
              // the iyzico callback yet at this point.
              if (_isCallbackUrl(req.url) && !_callbackDetected) {
                _callbackDetected = true;
                vm.setCheckingPayment(true);
              }
              return NavigationDecision.navigate;
            },
            onPageFinished: (String finishedUrl) {
              // Fallback: 99 redirect'i onNavigationRequest'i atlamış olabilir.
              if (!_ipMismatchRetried && _isIpMismatchRedirect(finishedUrl)) {
                _retryAfterIpMismatch(vm);
                return;
              }

              _captureBankMessage(finishedUrl);

              // KT kart formu yüklendi → sayı klavyesi + autofill ipuçları enjekte et.
              if (_isKuveytTurkPaymentPageUrl(finishedUrl)) {
                _enhanceKuveytTurkCardForm();
              }

              // KT sonuç sayfası POST/JS ile gelirse onNavigationRequest
              // tetiklenmeyebilir — fallback.
              if (_isKuveytTurkResultUrl(finishedUrl)) {
                _handleKuveytTurkResult(vm, finishedUrl);
              }

              // Android WebView does NOT fire onNavigationRequest
              // for POST-based form submissions (iyzico 3DS callback).
              // Detect the callback URL here as a fallback.
              if (!_callbackDetected && _isCallbackUrl(finishedUrl)) {
                _callbackDetected = true;
                vm.setCheckingPayment(true);
              }

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

      // Banka yönlendirmesinden bağımsız güvenlik ağı: sonuç arka planda yoklanır.
      _startBackgroundPolling(vm);
    }

    return Scaffold(
      appBar: CommonAppBar(
        title: tr("payment_title"),
        onBack: () => _handleBackPressed(vm),
      ),
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
                    backgroundColor: context.colors.secondary.withValues(
                      alpha: 0.12,
                    ),
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
