class FailureModel {
  final String message;
  final int? statusCode;
  final List<String> validationErrors;

  FailureModel({
    required this.message,
    this.statusCode,
    this.validationErrors = const [],
  });

  bool get hasValidationErrors => validationErrors.isNotEmpty;
}
