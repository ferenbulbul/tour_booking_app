import 'package:tour_booking/models/base/base_response.dart';
import 'result.dart';
import 'failure_model.dart';

Result<T> handleResponse<T>(BaseResponse<T> response) {
  if (response.isSuccess == true && response.data != null) {
    return Result.success(response.data!);
  } else {
    return Result.failure(
      FailureModel(
        message: response.message ?? 'Bilinmeyen hata',
        statusCode: response.statusCode,
        validationErrors: response.validationErrors ?? [],
      ),
    );
  }
}
