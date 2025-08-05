// lib/core/network/safe_call.dart

import 'dart:async';

import 'package:tour_booking/models/base/base_response.dart';

/// Verilen async fn’i çalıştırır, exception fırlatılsa da yakalar
/// ve BaseResponse<T> formatında döner.
Future<BaseResponse<T>> safeCall<T>(
  Future<BaseResponse<T>> Function() fn,
) async {
  try {
    return await fn();
  } catch (e, st) {
    // Burada dilersen loglayabilirsin: debugPrint('$e\n$st');
    return BaseResponse<T>(
      isSuccess: false,
      message: 'İşlem sırasında bir hata oluştu. Lütfen tekrar deneyin.',
      validationErrors: [],
      data: null,
    );
  }
}
