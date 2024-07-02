import 'package:base_bloc/core/error/index.dart';

class ApiError extends RemoteException {
  ApiError({
    int? httpStatusCode,
    String? errorCode,
    String? errorMessage,
  }) : super(
          httpStatusCode: httpStatusCode,
          errorCode: errorCode,
          errorMessage: errorMessage,
        );

  factory ApiError.initCombine(int? httpStatusCode, Map<String, dynamic> json,
      {String? statusMessage}) {
    try {
      final errorCode = json['statusCode'];
      final errorMessage = json['message']?.toString();

      return ApiError(
          httpStatusCode: httpStatusCode,
          errorCode: errorCode,
          errorMessage: errorMessage ??
              ((statusMessage?.isNotEmpty ?? false)
                  ? statusMessage
                  : json.toString()));
    } catch (ex) {
      return ApiError(
          httpStatusCode: httpStatusCode, errorMessage: json.toString());
    }
  }
}
