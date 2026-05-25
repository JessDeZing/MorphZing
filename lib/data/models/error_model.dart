class ErrorModel {
  late List<SingleError> errors = [];

  ErrorModel({required this.errors});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    json['errors'].forEach((e) {
      errors.add(SingleError.fromJson(e));
    });
  }
}

class SingleError {
  final String? message;
  final String? code;
  final String? field;

  SingleError({
    required this.message,
    required this.code,
    required this.field,
  });

  factory SingleError.fromJson(Map<String, dynamic> json) => SingleError(
      message: json['message'], code: json['code'], field: json['field'] ?? 'Error');
}
