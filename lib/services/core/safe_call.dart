// lib/core/network/safe_call.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tour_booking/models/base/base_response.dart';

/// Executes the given async function, catches any thrown exceptions,
/// and returns the result in BaseResponse<T> format.

Future<BaseResponse<T>> safeCall<T>(
  Future<BaseResponse<T>> Function() fn,
) async {
  try {
    return await fn();
  } catch (e, st) {
    debugPrint('$e\n$st');

    return BaseResponse<T>(
      isSuccess: false,
      message: 'error_generic',
      validationErrors: const [],
      data: null,
    );
  }
}
