import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/detailed_search/flow/payment_viewmodel.dart';
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

                        if (vm.resultData?.paymentStatus == "Success" &&
                            vm.resultData?.bookingStatus == "Success") {
                          context.replace(
                            '/payment-success',
                            extra: vm.initData?.conversationId,
                          );
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
            appBar: AppBar(title: Text(tr('payment_title'))),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(tr('payment_checking_result')),
                ],
              ),
            ),
          );
        }

        // DEĞİŞİKLİK: WebView'i bir Stack içine alarak üzerine yükleme ekranı ekliyoruz.
        return Scaffold(
          appBar: CommonAppBar(title: (tr("payment_title"))),
          body: _controller == null
              ? Center(child: Text(tr("payment_page_preparing")))
              : Stack(
                  children: [
                    // WebView her zaman altta, görünmez bile olsa var olacak.
                    WebViewWidget(controller: _controller!),

                    // Sayfa yüklenmediyse (_isPageFinished false ise) bu katman WebView'in üzerinde görünecek.
                    if (!_isPageFinished)
                      Scaffold(
                        // Arka planın temiz görünmesi için Scaffold kullandık
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(tr('payment_page_loading')),
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
