import 'failure_model.dart';

class Result<T> {
  final T? data;
  final FailureModel? error;
  final bool isSuccess;

  Result.success(this.data) : isSuccess = true, error = null;

  Result.failure(this.error) : isSuccess = false, data = null;
}
