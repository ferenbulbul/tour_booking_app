import 'package:easy_localization/easy_localization.dart';
import 'package:tour_booking/models/base/base_response.dart';
import 'result.dart';
import 'failure_model.dart';

Result<T> handleResponse<T>(BaseResponse<T> response) {
  if (response.isSuccess == true) {
    return Result.success(response.data);
  } else {
    return Result.failure(
      FailureModel(
        message: response.message ?? tr('error_unknown'),
        statusCode: response.statusCode,
        validationErrors: response.validationErrors ?? [],
      ),
    );
  }
}
