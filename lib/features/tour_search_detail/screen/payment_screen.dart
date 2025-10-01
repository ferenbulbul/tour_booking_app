import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/features/tour_search_detail/payment_viewmodel.dart';
import 'package:tour_booking/features/tour_search_detail/screen/payment_fail.dart';
import 'package:tour_booking/features/tour_search_detail/screen/payment_success.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String bookingId;
  const PaymentPage({super.key, required this.bookingId});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  WebViewController? _controller;
  bool _isCheckingPayment = false;

  // DEĞİŞİKLİK: WebView'in ilk yüklemesinin bitip bitmediğini takip etmek için yeni bir bayrak
  bool _isPageFinished = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentViewModel>().initPayment(widget.bookingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (vm.errorMessage != null) {
          return Scaffold(
            body: Center(child: Text("Hata: ${vm.errorMessage}")),
          );
        }

        final url = vm.initData?.paymentPageUrl;

        if (url != null && _controller == null) {
          _controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onNavigationRequest: (req) {
                  debugPrint("WebView gezinme isteği: ${req.url}");
                  return NavigationDecision.navigate;
                },
                onPageFinished: (String url) {
                  debugPrint("Sayfa yüklendi: $url");

                  // DEĞİŞİKLİK: İlk sayfa yüklemesi bittiğinde bayrağı true yapıyoruz ki yükleme ekranı kaybolsun.
                  if (!_isPageFinished) {
                    setState(() {
                      _isPageFinished = true;
                    });
                  }

                  const String callbackIdentifier = "payments/callback";

                  if (url.contains(callbackIdentifier) && !_isCheckingPayment) {
                    setState(() {
                      _isCheckingPayment = true;
                    });

                    final token = vm.initData?.token;
                    if (token != null) {
                      vm.checkPaymentResult(token).then((_) {
                        if (!mounted) return;

                        if (vm.resultData?.paymentStatus == "SUCCESS") {
                          context.replace('/payment-success');
                        } else {
                          context.replace('/payment-fail');
                        }
                      });
                    }
                  }
                },
              ),
            )
            ..loadRequest(Uri.parse(url));
        }

        if (_isCheckingPayment) {
          return Scaffold(
            appBar: AppBar(title: const Text("Ödeme")),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Ödeme sonucu kontrol ediliyor..."),
                ],
              ),
            ),
          );
        }

        // DEĞİŞİKLİK: WebView'i bir Stack içine alarak üzerine yükleme ekranı ekliyoruz.
        return Scaffold(
          appBar: AppBar(title: const Text("Ödeme")),
          body: _controller == null
              ? const Center(child: Text("Ödeme sayfası hazırlanıyor..."))
              : Stack(
                  children: [
                    // WebView her zaman altta, görünmez bile olsa var olacak.
                    WebViewWidget(controller: _controller!),

                    // Sayfa yüklenmediyse (_isPageFinished false ise) bu katman WebView'in üzerinde görünecek.
                    if (!_isPageFinished)
                      const Scaffold(
                        // Arka planın temiz görünmesi için Scaffold kullandık
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text("Ödeme sayfası yükleniyor..."),
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
}
